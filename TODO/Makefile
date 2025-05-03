.DELETE_ON_ERROR:
.PHONY: all clean

USE_CASES := edit-profile.md rate-user.md report-user.md view-past-rides.md

all:

use-cases.md: $(USE_CASES)
	echo "# Use Cases" > use-cases.md
	echo "" >> use-cases.md
	echo "![image](./use-cases.drawio.png)" >> use-cases.md
	echo "" >> use-cases.md
	sed -e '$$s/$$/\n/' -s $(USE_CASES) >> use-cases.md

clean:
	rm -f use-cases.md

# rm -f use-cases.tex`
# latexmk --lualatex project-description.tex -C
# latexmk --lualatex use-cases-old.tex -C
# latexmk --lualatex domain-model.tex -C
# # images/uml/%.png: uml/%.plantuml
# # 	plantuml -tpng $< -o ../$(dir $@)

# # project-description.pdf: tex/project-description.tex
# # 	latexmk --lualatex $<

# use-cases.pdf: use-cases-old.tex
# 	latexmk --lualatex $<

# use-cases.tex: report.md
# 	pandoc report.md -o $@

# # domain-model.pdf: tex/domain-model.tex images/uml/domain-model.png
# # 	latexmk --lualatex $<
