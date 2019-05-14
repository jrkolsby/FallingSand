.PHONY demo:
demo: playground/sand.py
	python playground/sand.py

.PHONY hardware:
hardware:
	cd src/hw && make build
