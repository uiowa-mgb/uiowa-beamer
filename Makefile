EXAMPLE=example.tex
THEME=beamerthemeuiowa.sty

ALL=$(THEME) $(EXAMPLE)

all: release

out/%.pdf: %.tex $(THEME)
	mkdir -p out
	latexmk --pdfxe $<

out/example.zip: $(ALL)
	mkdir -p out
	zip $@ $^

release: out/example.zip out/example.pdf## Prepare a release for github

clean: ## Remove build artifacts
	rm -rf out

format: ## Format the codebase
	nix fmt

watch: ## Watch the example document for changes, rebuild on change (requires inotifywait)
	@make all && while true; do \
		inotifywait -r $(ALL); \
		make all; \
		done

help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
