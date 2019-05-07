.PHONY demo:
demo: playground/sand.py
	python3 playground/sand.py

.PHONY hardware:
hardware:
	cd src/hw && make build
