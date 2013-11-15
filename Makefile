translated: po4a.conf
	mkdir -p po4a
	po4a po4a.conf

translated/asciidoc.conf: ../../asciidoc.conf
	cp ../../asciidoc.conf translated/asciidoc.conf

html:
	cd translated && asciidoc git.txt
