.DELETE_ON_ERROR:
.PHONY: all clean

PLANTUML_FILES := $(wildcard uml/*.plantuml)
PLANTUML_PNGS := $(patsubst uml/%.plantuml,images/%.png,$(PLANTUML_FILES))

all:

clean:
	latexmk --lualatex tex/project.tex -C

report: project.pdf

uml: $(PLANTUML_PNGS)

images/%.png: uml/%.plantuml
	plantuml -tpng $< -o ../$(dir $@)

project.pdf: tex/project.tex $(PLANTUML_PNGS)
	latexmk --lualatex $<
