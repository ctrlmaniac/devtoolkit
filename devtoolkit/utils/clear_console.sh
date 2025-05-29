#!/usr/bin/env bash
# shellcheck shell=bash

clear_console() {
  command -v clear &>/dev/null && clear || printf "\033c"
}
