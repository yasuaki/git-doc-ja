#!/bin/perl
#
# 日本語訳したマニュアルを生成するためのスクリプト
#
# 実行方法：
#  $ make.pl ファイル名
# ※ 日本語版のマニュアルを ../Documentation.ja 配下に生成される。
#
# なお、引数で指定したファイルは、以下の形式で記述すること。
#
#	<記述方法>
#	xxxxxxxxxxxxxxx
#	xxxxxxxxxxxxxxx
#	// 英文のすぐ下に「// で日本語訳を記述する」
#	// ・・・・・・・・・
#
#	English title
#	-------------
#	// = 見出しは先頭に「=」を付ける。(レベルに合わせて「==」や「===」に)
#
#	--------------------------------
#	$ command		# xxxx	# コマンドに対する説明が「#」で記述されている場合、
#	$ command		# xxxx	# 行末に「#」を追加し、その後ろに日本語訳を追記する。
#	--------------------------------
#
# このスクリプトは、単に、次の手順で変換しているだけです・・・。
#「//」で始まる行と、「-------------------」のブロック部分を抜き出したファイルを生成。
# make ファイル名.html で HTML 形式に変換。
#

#---------------------------------------------------------------------
# 関数定義
#---------------------------------------------------------------------

#---------------------------------------------------------------------
# 本処理開始
#---------------------------------------------------------------------

$targetFile = $ARGV[0];			# 変換するファイル
$jadir="../Documentation.ja";	# 出力先ディレクトリ

$jafile   = "$jadir/$targetFile";
$htmlFile = "$targetFile";
$htmlFile =~ s/txt$/html/;

#---------------------------------------
# Makefile, conf ファイルを Documentation.ja ディレクトリにコピー
#---------------------------------------
if (! -d $jadir) {
	mkdir $jadir;
	`cp Makefile $jadir/`;
	`cp *.conf   $jadir/`;
}

#---------------------------------------
# 日本語訳のみを抜き出した .txt ファイルを、Documentation.ja ディレクトリに出力
#---------------------------------------
printf "Create ../Documentation.ja/$targetFile\n";

open(IN, $targetFile) or die("failed to open $targetFile .\n");
@lines = <IN>;
close(IN);

open(OUT, ">$jafile") or die("failed to open $jafile .\n");
$flg = 0;
$cnt = @lines;
for ($i=0; $i<$cnt; $i++) {
	$_ = $lines[$i];
	chop;

	if (/^\s*$/ || /^\[\[.*\]\]/) {
		# 空行 または [[xxx]] の行はそのまま出力
		printf OUT "%s\n", $_;
		next;
	}

	if (/^\/\//) {
		# 「//」で始まる行は「//」を削除してから出力
		s/^\/\/ ?//;
		printf OUT "%s\n", $_;
		next;
	}

	if (/^\s+/) {
		# インデントされている行はそのまま出力
		printf OUT "%s\n", $_;
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

