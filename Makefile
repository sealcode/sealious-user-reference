# https://github.com/jgm/pandocfilters/ is necessary to build graphs

md: ./*.md 
	rm -rf ./graphviz-images
	pandoc 0-intro.md 1-declarations.md --filter=./graphviz.py --highlight-style=kate -o __temp.md
	echo "<!-- DON'T EDIT THIS FILE! This is a file built from the source .md files (see Makefile). The build process will override changes made to this file. Edit other .md files instead. -->\n\n\n" > README.md
	cat __temp.md >> README.md
	rm __temp.md

html: ./*.md style.css
	rm -rf ./graphviz-images
	pandoc 0-intro.md 1-declarations.md --filter=./graphviz.py -H style.inc --highlight-style=kate -o __temp.html
	echo "<!-- DON'T EDIT THIS FILE! This is a file built from the source .md files (see Makefile). The build process will override changes made to this file. Edit other .md files instead. -->\n\n\n" > docs.html
	cat __temp.html >> docs.html
	rm __temp.html
