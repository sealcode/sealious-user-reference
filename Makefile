

all: ./*.md
	rm -rf ./graphviz-images
	pandoc 0-intro.md 1-declarations.md --filter=./graphviz.py -H style.inc --highlight-style=kate -o intro.html
