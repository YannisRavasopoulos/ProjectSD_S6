.DELETE_ON_ERROR:
.PHONY: all clean sequence robustness use-case

ROBUSTNESS_DRAWIO_FILES := $(wildcard reports/robustness/*.drawio.png)
SEQUENCE_UML_FILES := $(wildcard reports/sequence/*.plantuml)
USE_CASE_MD_FILES := $(wildcard reports/use-case/*.md)
ROBUSTNESS_PNG_FILES := $(patsubst reports/robustness/%.drawio.png, build/robustness/%.png, $(ROBUSTNESS_DRAWIO_FILES))
SEQUENCE_PNG_FILES := $(patsubst reports/sequence/%.plantuml, build/sequence/%.png, $(SEQUENCE_UML_FILES))
USE_CASE_TEX_FILES := $(patsubst reports/use-case/%.md, build/use-case/%.tex, $(USE_CASE_MD_FILES))

all: report.pdf

$(SEQUENCE_PNG_FILES): build/sequence/%.png: reports/sequence/%.plantuml
	mkdir -p $(dir $@)
	plantuml -progress -tpng -o ../../$(dir $@) $<

$(ROBUSTNESS_PNG_FILES): build/robustness/%.png: reports/robustness/%.drawio.png
	mkdir -p $(dir $@)
	cp $< $@

$(USE_CASE_TEX_FILES): build/use-case/%.tex: reports/use-case/%.md
	mkdir -p $(dir $@)
	pandoc $< -o $@

sequence: $(SEQUENCE_PNG_FILES)

robustness: $(ROBUSTNESS_PNG_FILES)

use-case: $(USE_CASE_TEX_FILES)

build/domain-model.png: reports/domain-model.plantuml
	mkdir -p $(dir $@)
	plantuml -progress -tpng -o ../$(dir $@) $<

build/class-diagram.png: reports/class-diagram.plantuml
	mkdir -p $(dir $@)
	plantuml -progress -tpng -o ../$(dir $@) $<

build/use-case-diagram.png: reports/use-case-diagram.plantuml
	mkdir -p $(dir $@)
	plantuml -progress -tpng -o ../$(dir $@) $<

generated.tex: sequence robustness use-case
	./combine.sh >> $@

report.pdf: generated.tex
	latexmk --lualatex report.tex

clean:
	rm -rf build
	latexmk -C
