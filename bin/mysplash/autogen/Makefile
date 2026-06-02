TOML_SRC  := fastfetch.toml
JSON_OUT  := config.jsonc

# Preferred: taplo (TOML-aware, preserves key order)
# Fallback:  python3 with tomllib + json (stdlib, no install needed)

.PHONY: all clean

all: $(JSON_OUT)

$(JSON_OUT): $(TOML_SRC)
	@if command -v taplo >/dev/null 2>&1; then \
		taplo fmt --stdin-filepath input.toml < $< | \
		taplo get --output-format json - > $@; \
	elif command -v python3 >/dev/null 2>&1; then \
		python3 -c "\
import sys, json; \
try: import tomllib \
except ImportError: import tomli as tomllib; \
data = tomllib.loads(open('$<').read()); \
print(json.dumps(data, indent=4))" > $@; \
	else \
		echo "Error: need taplo or python3 (3.11+) to convert TOML → JSON" >&2; exit 1; \
	fi
	@echo "Written $@"

clean:
	rm -f $(JSON_OUT)
