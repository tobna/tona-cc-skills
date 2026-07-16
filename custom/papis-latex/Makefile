# $(BIB) is generated -- fix references with `papis edit`, not here.

TEX   := main
BIB   := main.bib
SRC   := $(wildcard *.tex)
PAPIS := papis bibtex --no-auto-read read $(BIB)

.PHONY: all tex full bib bib-check clean

all: full

# latex only
tex-only:
	latexmk -pdf -e '$$bibtex_use=0' $(TEX).tex

# latex + bibtex, no papis
full:
	latexmk -pdf $(TEX).tex

bibtex: full

# regenerate $(BIB) from the library
bib:
	papis export -a -b -f bibtex -o $(BIB)
	$(PAPIS) filter-cited $(addprefix -f ,$(SRC)) unique save -f $(BIB)

# read-only
bib-check:
	$(PAPIS) iscited -f $(TEX).tex doctor -k ref -k title -k author -k year
	@grep -s 'Warning--' $(TEX).blg || echo "bibtex: clean"

clean:
	latexmk -C
