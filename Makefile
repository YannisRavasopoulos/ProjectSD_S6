.DELETE_ON_ERROR:
.PHONY: all clean

PLANTUML_FILES := $(wildcard reports/sequence/*.plantuml)
PNG_FILES := $(patsubst reports/sequence/%.plantuml, build/sequence/%.png, $(PLANTUML_FILES))

all: $(PNG_FILES)

build/sequence/%.png: reports/sequence/%.plantuml
	mkdir -p $(dir $@)
	plantuml -progress -tpng -o ../../$(dir $@) $<

clean:
	rm -rf build/sequence
