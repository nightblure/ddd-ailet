dev:
	npm exec slidev -- --port 3030 "slides.md"

# https://sli.dev/guide/exporting
pdf:
	npm exec slidev export --dark --output slides.md

md:
	npm exec slidev export --format md --output slides.md
