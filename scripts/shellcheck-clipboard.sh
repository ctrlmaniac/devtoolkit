#!/usr/bin/env bash
#
# Checks for errors inside the bin, scripts, and devtoolkit only, and only f or sh files
# copies output to clipboard

find ./bin ./scripts ./devtoolkit -type f -name '*.sh' -exec shellcheck -x {} + | xclip -selection clipboard && printf "\n✅ Done\n"
