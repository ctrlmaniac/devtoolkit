#!/usr/bin/env bash

_devtoolkit_config_log_theme() {
  mapfile -t COMPREPLY < <(compgen -W "fun ascii minimal ci" -- "${COMP_WORDS[COMP_CWORD]}")
}
complete -F _devtoolkit_config_log_theme "devtoolkit"
