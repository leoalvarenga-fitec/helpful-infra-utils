# Runs a command passed via args, directing its stdout to null (silencing it)
run_silent() {
    "$@" > /dev/null
}

# Wrapper to log something to stdout
log() {
    echo -e "$1"
}

toggle_cursor() {
    log "\e[?25l"
}

clear_screen() {
    log "\e[H"
    log "\e[0J"
}

has_output() {
    if [ -n "$("$@" 2> /dev/null)" ]; then
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

