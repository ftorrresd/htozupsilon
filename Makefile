# Variables
VENV_DIR := venv
PYTHON := python3
PIP := $(VENV_DIR)/bin/pip
PYTHON_VENV := $(VENV_DIR)/bin/python

.PHONY: all install venv clean

# Default target
all: install

# Create and set up virtual environment if it doesn't exist
venv:
	@if [ ! -d "$(VENV_DIR)" ]; then \
		echo "Creating virtual environment..."; \
		$(PYTHON) -m venv $(VENV_DIR); \
		echo "Installing scikit_build_core..."; \
		$(PIP) install --upgrade pip; \
		$(PIP) install scikit_build_core; \
	else \
		echo "Virtual environment already exists."; \
	fi

# Install the package
install: venv
	@echo "Installing package..."
	@source $(VENV_DIR)/bin/activate && $(PIP) install --no-build-isolation -v .
	@echo "Installation complete!"

# Clean up
clean:
	@echo "Cleaning up..."
	rm -rf build/ dist/ *.egg-info/
	@echo "Cleaned build artifacts."

# Help target
help:
	@echo "Available targets:"
	@echo "  all      : Set up virtual environment and install package (default)"
	@echo "  venv     : Create virtual environment if it doesn't exist"
	@echo "  install  : Install package using pip"
	@echo "  clean    : Remove build artifacts"
	@echo "  help     : Show this help message"
