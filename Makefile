# https://github.com/jgm/pandocfilters/ is necessary to build graphs

title:="Sealious User Reference"
files:=0-intro.md 1-declarations.md 2-base-chips.md
common_params:=--filter=./graphviz.py --toc -V title=$(title) --toc-depth=4
no_edit_message = "<!-- DON'T EDIT THIS FILE!! This is a file built from the source .md files (see Makefile). The build process will override changes made to this file. Edit other .md files instead. -->\n\n\n"

md: ./*.md 
	rm -rf ./graphviz-images
	pandoc $(files)  $(common_params) \
		--standalone \
		-t markdown_github \
		--template=./templates/markdown.markdown \
		-o __temp.md
	echo $(no_edit_message) > README.md
	cat __temp.md >> README.md
	sed -i "s/<div class=\"wide\">//" README.md
	sed -i "s/<\/div>//" README.md
	sed -i "s/<\/pre>/<\/pre>\n/" README.md

	rm __temp.md

html: ./*.md style.css
	rm -rf ./graphviz-images
	pandoc $(files) $(common_params) \
		-H style.inc \
		--highlight-style=kate \
		--title=$(title) \
		--template=./templates/html.html \
		-o __temp.html;
	echo $(no_edit_message) > docs.html
	cat __temp.html >> docs.html
	rm __temp.html
