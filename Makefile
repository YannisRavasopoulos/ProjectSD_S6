.DELETE_ON_ERROR:
.PHONY: all clean

BUILD_DIR := build

PLANTUML_FILES := $(wildcard uml/*.plantuml)
PLANTUML_PNGS := $(patsubst uml/%.plantuml,$(BUILD_DIR)/images/%.png,$(PLANTUML_FILES))

all:

clean:
	rm -rf $(BUILD_DIR)

report: $(BUILD_DIR)/project.pdf

uml: $(PLANTUML_PNGS)

$(BUILD_DIR)/images/%.png: uml/%.plantuml
	plantuml -tpng $< -o ../$(dir $@)

$(BUILD_DIR)/project.pdf: tex/project.tex $(PLANTUML_PNGS)
	cd $(BUILD_DIR) && lualatex ../$<
