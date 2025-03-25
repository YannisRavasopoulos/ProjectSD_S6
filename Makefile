.DELETE_ON_ERROR:
.PHONY: all clean

BUILD_DIR := build

PLANTUML_FILES := $(wildcard uml/*.plantuml)
PLANTUML_PNGS := $(patsubst uml/%.plantuml,images/%.png,$(PLANTUML_FILES))

all: $(PLANTUML_PNGS) project.pdf

clean:
	rm -f $(PLANTUML_PNGS)
	rm -rf $(BUILD_DIR)

images/%.png: uml/%.plantuml
	plantuml -tpng $< -o ../$(dir $@)

project.pdf: tex/project.tex $(PLANTUML_PNGS)
	mkdir -p $(BUILD_DIR)
	lualatex -output-directory=$(BUILD_DIR) $<
