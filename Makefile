.DELETE_ON_ERROR:
.PHONY: all clean

PLANTUML_FILES := $(wildcard uml/*.plantuml)
PLANTUML_PNGS := $(patsubst uml/%.plantuml,images/%.png,$(PLANTUML_FILES))
TEX_FILES := $(wildcard tex/use-cases/*.tex) $(wildcard tex/*.tex)

all:

clean:
	latexmk --lualatex tex/project.tex -C

report: project.pdf

uml: $(PLANTUML_PNGS)

images/%.png: uml/%.plantuml
	plantuml -tpng $< -o ../$(dir $@)

project.pdf: $(PLANTUML_PNGS) $(TEX_FILES)
	latexmk --lualatex tex/project.tex

project.docx: $(PLANTUML_PNGS) $(TEX_FILES)
	pandoc -s tex/project.tex -o project.docx
