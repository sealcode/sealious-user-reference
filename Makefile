# https://github.com/jgm/pandocfilters/ is necessary to build graphs

title:="Sealious User Reference"

md: ./*.md 
	rm -rf ./graphviz-images
	pandoc 0-intro.md 1-declarations.md \
		--filter=./graphviz.py \
		--highlight-style=kate \
		--standalone \
		--toc  \
		-V title=$(title) \
		--template=./templates/markdown.markdown \
		-o __temp.md
	echo "<!-- DON'T EDIT THIS FILE! This is a file built from the source .md files (see Makefile). The build process will override changes made to this file. Edit other .md files instead. -->\n\n\n" > README.md
	cat __temp.md >> README.md
	sed -i "s/<div class=\"wide\">//" README.md
	sed -i "s/<div\/>//" README.md

	rm __temp.md

html: ./*.md style.css
	rm -rf ./graphviz-images
	pandoc 0-intro.md 1-declarations.md \
		--filter=./graphviz.py \
		-H style.inc \
		--highlight-style=kate \
		--toc \
		--toc-depth=3 \
		--title=$(title) \
		-V title=$(title) \
		--template=./templates/html.html \
		-o __temp.html;
	echo "<!-- DON'T EDIT THIS FILE! This is a file built from the source .md files (see Makefile). The build process will override changes made to this file. Edit other .md files instead. -->\n\n\n" > docs.html
	cat __temp.html >> docs.html
	rm __temp.html
