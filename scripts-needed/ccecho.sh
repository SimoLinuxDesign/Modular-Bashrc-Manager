#!/bin/bash

ccecho() {
  local text_color=""
  local bg_color=""
  local style=""
  local msg=""

  # Color and Styles in ANSI code
  declare -A COLORS=(
    [black]=30 [red]=31 [green]=32 [yellow]=33 [blue]=34
    [magenta]=35 [cyan]=36 [white]=37
    [bblack]=90 [bred]=91 [bgreen]=92 [byellow]=93
    [bblue]=94 [bmagenta]=95 [bcyan]=96 [bwhite]=97
  )

  declare -A BGCOLORS=(
    [black]=40 [red]=41 [green]=42 [yellow]=43 [blue]=44
    [magenta]=45 [cyan]=46 [white]=47
    [bblack]=100 [bred]=101 [bgreen]=102 [byellow]=103
    [bblue]=104 [bmagenta]=105 [bcyan]=106 [bwhite]=107
  )

  declare -A STYLES=(
    [bold]=1 [dim]=2 [italic]=3 [underline]=4
    [blink]=5 [reverse]=7 [hidden]=8 [strike]=9
  )

  # Parsing options
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -t|--text)       text_color=${COLORS[$2]}; shift 2 ;;
      -b|--bg)         bg_color=${BGCOLORS[$2]}; shift 2 ;;
      -s|--style)      style=${STYLES[$2]}; shift 2 ;;
      *)               msg+="$1 "; shift ;;
    esac
  done

  local sequence=""
  [[ -n "$style" ]]      && sequence+="${style};"
  [[ -n "$text_color" ]] && sequence+="${text_color};"
  [[ -n "$bg_color" ]]   && sequence+="${bg_color};"

  if [[ -n "$sequence" ]]; then
    sequence="${sequence%;}"  # remove the last ";"
    echo -e "\e[${sequence}m${msg}\e[0m"
  else
    echo "$msg"
  fi
}

