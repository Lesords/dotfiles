#!/bin/bash
######################################################
# Automatically change the current working directory #
######################################################

# ranger
ranger-cd() {
    temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
    ranger --choosedir="$temp_file" -- "${@:-$PWD}"
    if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
        cd -- "$chosen_dir"
    fi
    rm -f -- "$temp_file"
}

# joshuto
function joshuto-cd() {
	ID="$$"
	mkdir -p /tmp/$USER
	OUTPUT_FILE="/tmp/$USER/joshuto-cwd-$ID"
	env joshuto --output-file "$OUTPUT_FILE" $@
	exit_code=$?

	case "$exit_code" in
		# regular exit
		0)
			;;
		# output contains current directory
		101)
			JOSHUTO_CWD=$(cat "$OUTPUT_FILE")
			cd "$JOSHUTO_CWD"
			;;
		# output selected files
		102)
			;;
		*)
			echo "Exit code: $exit_code"
			;;
	esac
}

# vifm
vicd()
{
    local dst="$(command vifm --choose-dir - "$@")"
    if [ -z "$dst" ]; then
        echo 'Directory picking cancelled/failed'
        return 1
    fi
    if [[ "$dst" =~ ^[[:space:]] ]]; then
        dst=$(echo "$dst" | sed 's/^[[:space:]]*//')
    fi
    cd "$dst" || echo "$dst"
}



if type ranger >/dev/null 2>&1; then
    if [ -t 1 ]; then bind '"\C-o":"\C-uranger-cd\C-m"'; fi
fi

if type joshuto >/dev/null 2>&1; then
    if [ -t 1 ]; then bind '"\ej": "\C-ujoshuto-cd\C-m"'; fi
fi

if type vifm >/dev/null 2>&1; then
    if [ -t 1 ]; then bind '"\eo": "\C-uvicd .\C-m"'; fi
fi
