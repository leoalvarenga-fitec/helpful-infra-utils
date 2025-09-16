CURSOR_IS_VISIBLE=true

# Runs a command passed via args, directing its stdout to null (silencing it)
run_silent() {
  if [[ $VERBOSE == "true" ]]; then
    echo "Running -> $@"

    "$@"
    return
  fi

  "$@" > /dev/null 2>&1
}

# Decides and executes privilege escalation
impersonate_root() {
  if has_output doas; then
    doas "$@"
    return
  fi

  sudo "$@"
}

run_func_as_root() {
  impersonate_root "bash -c 'declare -f $1'; $1"
}

# Wrapper to log something to stdout
log() {
  echo -e "$1"
}

log_fatal() {
  log "\x1b[1;31m[FATAL] $1\x1b[0m"
  exit 1
}

log_warn() {
  log "\x1b[1;33m[WARNING] $1\x1b[0m"
}

hide_cursor() {
  CURSOR_IS_VISIBLE=false
  log "\e[?25l"
}

show_cursor() {
  CURSOR_IS_VISIBLE=true
  log "\e[?25h"
}

toggle_cursor() {
  if $CURSOR_IS_VISIBLE; then
    hide_cursor
    return
  fi

  show_cursor
}

clear_screen() {
  log "\e[H"
  log "\e[0J"
}

read_and_return() {
  local TEMP_VAR=""

  if [[ -z $PROMPT ]]; then
    read TEMP_VAR
  else 
    read -p "$PROMPT" TEMP_VAR
  fi

  if [[ ! -z $EXIT_IF_EMPTY && -z $TEMP_VAR ]]; then
    log_fatal "$FAIL_MSG"
    exit 1
  fi

  echo $TEMP_VAR
}

has_output() {
  if command -v "$@" &> /dev/null; then
    return 0
  fi

  return 1
}

progress_bar() {
	local current=$1
	local len=$2

	local bar_char='>'
	local empty_char='-'
	local length=50
	local perc_done=$((current * 100 / len))
	local num_bars=$((perc_done * length / 100))

	local i
	local s='\e[1;34m[\e[0m\e[1;32m'

	for ((i = 0; i < num_bars; i++)); do
		s+=$bar_char
	done

    s+='\e[0m\e[2;33m'

	for ((i = num_bars; i < length; i++)); do
		s+=$empty_char
	done

	s+='\e[0m\e[1;34m]\e[0m'

	echo -ne "$s $current/$len ($perc_done%)\r"
}

