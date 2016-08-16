#!/usr/bin/python3

"""
Pandoc filter to process code blocks with class "graphviz" into
graphviz-generated images.

Needs pygraphviz and Pandoc 1.16
"""

import os
import sys
import hashlib

import pygraphviz

from pandocfilters import toJSONFilter, Para, Image


def graphviz(key, value, format, _):
    if key == 'CodeBlock':
        [[ident, classes, keyvals], code] = value
        if "graphviz" in classes:
            typef = "png"
            caption = ""
            keyvals = []
            filetype = "png"
            dest = "graphviz-images/" + hashlib.md5(code.encode()).hexdigest() + "." + filetype

            if not os.path.isfile(dest):
                g = pygraphviz.AGraph(string=code)
                g.layout('dot')
                g.draw(dest)
                sys.stderr.write('Created image ' + dest + '\n')

            return [{"t":"Para","c":[{"t":"Image","c":[["",[],[]],[],[dest,"fig:"]]}]}]

if __name__ == "__main__":
    toJSONFilter(graphviz)
