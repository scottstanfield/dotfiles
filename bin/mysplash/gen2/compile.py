#!/usr/bin/env python3
"""
Generate fastfetch config.jsonc from a simple modules file.

Modules file format (one per line):
    type:Label
    # comment lines and blank lines are ignored

Example:
    os:OS
    kernel:Kernel
    wm:Window Manager
"""

import json
import sys

# Colors extracted from the original config, cycling if more modules are added
COLORS = [
    "38;5;210",  # salmon
    "38;5;84",   # green
    "38;5;147",  # lavender
    "38;5;44",   # teal
    "38;5;75",   # sky blue
    "38;5;123",  # cyan
    "38;5;220",  # gold
    "38;5;203",  # coral
    "38;5;105",  # purple
    "38;5;200",  # pink
]

SCHEMA = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json"

def parse_modules(path):
    modules = []
    with open(path) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            type_, _, label = line.partition(":")
            if not type_:
                print(f"Warning: skipping malformed line: {line!r}", file=sys.stderr)
                continue
            modules.append((type_.strip(), label.strip()))
    return modules

def build_config(modules):
    # Pad all labels to the same width so values line up
    max_len = max(len(label) for _, label in modules)

    return {
        "$schema": SCHEMA,
        "logo": {"type": "small"},
        "display": { 
            "constants": ["• ", "██ "],
            "separator": "  "
                    },
        "modules": [
            {
                "type": type_,
                "key": "{$1}" + label.ljust(max_len),
                "keyColor": COLORS[i % len(COLORS)],
            }
            for i, (type_, label) in enumerate(modules)
        ],
    }


def post_config(config):
    for module in config["modules"]:
        if module.get("type") == "title":
            module["format"] = "{host-name-colored}"
    return config


if __name__ == "__main__":
    src = sys.argv[1] if len(sys.argv) > 1 else "fastfetch.modules"
    modules = parse_modules(src)
    if not modules:
        print("Error: no modules found", file=sys.stderr)
        sys.exit(1)

    config = post_config(build_config(modules))
    print(json.dumps(config, indent=4))
