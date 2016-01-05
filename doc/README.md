2WS20-2014-Group-9
==================
Generate by running:

    xelatex index.tex && xelatex index.tex && latexmk -c

You can use either `xelatex` or `pdflatex`. `xelatex` supports UTF-8 encoding, which is totaly more awesome.

`latexmk -c` cleans-up all auxillary files

The `&&` symbol let's you run multiple commands in a single line. If you want the table of contents to be generated, run `xelatex` twice, before cleaning up.
