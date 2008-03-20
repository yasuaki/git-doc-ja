#!/bin/perl
#-------------------------------------------------------------------------------
# 日本語訳したマニュアルを生成するためのスクリプト
#
# 実行方法：
#  $ make.pl ファイル名 
#  とすると、日本語版のマニュアルを ../Documentation.ja 配下に生成する。
#
# なお、引数で指定するファイルは、以下の形式で記述すること。
#
#	<記述方法>
#	・日本語訳は必ず行頭に「//」を付けることとし、
#	  英文ブロック毎に、そのすぐ下に日本語訳を記述する。
#		例）
#		eibun1 ...
#		eibun2 ...
#		// 英文1・・・
#		// 英文2・・・
#
#	・日本語の見出しは、その見出しレベルに合わせて「=」や「===」を付ける。
#		例）
#		English title
#		-------------
#		// == 日本語タイトル
#
#	・インラインの記述は日本語訳不要。
#	  ただし、「#」で始まるコメント部分は、当該行のすぐ次の行に日本語訳を記述する。
#		例）
#		--------------------------------
#		$ command		# xxxx
#		//				# 日本語訳
#		$ command		# xxxx
#		//				# 日本語訳
#		--------------------------------
#
#	・[[]]のアンカーは日本語訳不要。
#	  ただし、[[]] の後ろに文章がある場合は、以下のように記述。
#		例）
#		--------------------------------
#		[[def_tracking_branch]]tracking branch::
#		// [[def_tracking_branch]]追跡ブランチ::
#		--------------------------------
#
# 作者：Yasuaki Nairta (yasuaki_n@mti.biglobe.ne.jp)
# ライセンス：GPL(GNU General Public License) v2 に準じます。
#             たいしたツールではありませんが、役に立つなら使ってください。
#             バグがあっても責任とれませんがご了承ください。
#-------------------------------------------------------------------------------

#---------------------------------------
# 定数の定義
#---------------------------------------

$targetFile = $ARGV[0];			# 変換するファイル
$jadir="../Documentation.ja";	# 出力先ディレクトリ

$jafile   = "$jadir/$targetFile";
$htmlFile = "$targetFile";
$htmlFile =~ s/txt$/html/;

#---------------------------------------
# 日本語訳のみを抜き出した .txt ファイルを、Documentation.ja ディレクトリに出力
#---------------------------------------
printf "Create ../Documentation.ja/$targetFile\n";

open(IN, $targetFile) or die("failed to open $targetFile .\n");
@lines = <IN>;
close(IN);

open(OUT, ">$jafile") or die("failed to open $jafile .\n");
$inline = 0;
$cnt = @lines;
for ($i=0; $i<$cnt; $i++) {
	$_ = $lines[$i];
	chop;

	# 空行 または [[xxx]] のみの行はそのまま出力
	if (/^\s*$/ || /^\[\[.*\]\]$/) {
		printf OUT "%s\n", $_;
		next;
	}

	# 「//」で始まる行は「//」を削除してから出力
	if (/^\/\//) {
		s/^\/\/ ?//;
		printf OUT "%s\n", $_;
		next;
	}

	# インライン部分の開始・終了行
	if ( (/^---------------/ || /^\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\.\./)
	  && ( $lines[$i+1] !~ /^\/\// ) ) {

		# インラインの開始・終了記号を出力
		printf OUT "%s\n", $_;

		# インラインフラグの ON/OFF を反転
		$inline = ($inline == 1) ? 0 : 1;
		next;
	}

	# インライン内の文字出力
	if ($inline == 1) {
		if (/#/ && $lines[$i+1] =~ /^\/\//) {
			# "#" で始まるコメントを含む場合、
			# "#"より前の文字列と、次行の日本語訳を出力
			$cmd_text = $lines[$i];
			$cmd_text =~ s/\s*$//;
			$cmd_text =~ s/#.*$//;
			$ja_cmnt  = $lines[$i+1];
			$ja_cmnt  =~ s/\s*$//;
			$ja_cmnt  =~ s/^\/\/\s*#//;

			printf OUT "%s#%s\n", $cmd_text, $ja_cmnt;

			++$i;	# 次の行(#部分の日本語訳)は出力済みなので、処理をスキップする
			next;
		} else {
			printf OUT "%s\n", $_;
		}
		next;
	}
}
close(OUT);

#---------------------------------------
# HTML形式へ変換
#---------------------------------------
printf "Create ../Documentation.ja/$htmlFile\n";
$cwd = `pwd`;
chdir $jadir;
`make $htmlFile`;
`sed -e 's/sans-serif//' -e 's/serif//' $htmlFile > $htmlFile.new`;
`mv $htmlFile.new $htmlFile`;
chdir $cwd;

exit 0;

