#!/bin/sh
#
# オリジナル(英語版)との差分有無を確認する
#

Usage() {
	echo "$0 [diffオプション] <ファイル名>.."
	exit;
}

tmp_file=check_status.tmp.$$
origin=~/git/Documentation

opt=""
while test $# != 0
do
	case "$1" in
	-h)
		Usage;;
	-*)
		opt="$opt $1"
		shift;;
	--)
		break;;
	*)
		break;;
	esac
done

for file in ${*}
do
	grep -v '^//' "$file" > "$tmp_file"

	echo ""
	echo "* diff $opt $file"
	diff $opt "$tmp_file" "$origin/$file"
	if test $? = 0
	then
		echo "-> $file 差分はありません"
		continue
	fi
done

test -f $tmp_file && rm $tmp_file

