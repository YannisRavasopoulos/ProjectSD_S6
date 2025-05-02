.DELETE_ON_ERROR:
.PHONY: all clean

USE_CASES := edit-profile.md rate-user.md report-user.md view-past-rides.md

all:

report.md: $(USE_CASES)
	cat $^ > $@

clean:
	latexmk --lualatex project-description.tex -C
	latexmk --lualatex use-cases.tex -C
	latexmk --lualatex domain-model.tex -C

# images/uml/%.png: uml/%.plantuml
# 	plantuml -tpng $< -o ../$(dir $@)

# project-description.pdf: tex/project-description.tex
# 	latexmk --lualatex $<

use-cases.pdf: report.md
	pandoc $< -o $@ --pdf-engine=lualatex
# domain-model.pdf: tex/domain-model.tex images/uml/domain-model.png
# 	latexmk --lualatex $<
