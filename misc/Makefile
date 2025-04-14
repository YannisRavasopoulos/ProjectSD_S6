.DELETE_ON_ERROR:
.PHONY: all clean

PLANTUML_FILES := $(wildcard uml/*.plantuml)
PLANTUML_PNGS := $(patsubst uml/%.plantuml,images/uml/%.png,$(PLANTUML_FILES))

all:

clean:
	latexmk --lualatex tex/project-description.tex -C
	latexmk --lualatex tex/use-cases.tex -C
	latexmk --lualatex tex/domain-model.tex -C

uml: $(PLANTUML_PNGS)

images/uml/%.png: uml/%.plantuml
	plantuml -tpng $< -o ../$(dir $@)

project-description.pdf: tex/project-description.tex
	latexmk --lualatex $<

use-cases.pdf: tex/use-cases.tex images/uml/use-cases.png
	latexmk --lualatex $<

domain-model.pdf: tex/domain-model.tex images/uml/domain-model.png
	latexmk --lualatex $<
