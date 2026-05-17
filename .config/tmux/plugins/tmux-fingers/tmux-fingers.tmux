#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if command -v "tmux-fingers" &>/dev/null; then
  FINGERS_BINARY="tmux-fingers"
elif [[ -f "$CURRENT_DIR/bin/tmux-fingers" ]]; then
  FINGERS_BINARY="$CURRENT_DIR/bin/tmux-fingers"
fi

echo "$FINGERS_BINARY"

if [[ -z "$FINGERS_BINARY" ]]; then
  tmux run-shell -b "bash $CURRENT_DIR/install-wizard.sh"
  exit 0
fi

CURRENT_FINGERS_VERSION="$($FINGERS_BINARY version)"

SKIP_WIZARD=$(tmux show-option -gqv @fingers-skip-wizard)
SKIP_WIZARD=${SKIP_WIZARD:-0}

if [[ "$TERM" == "dumb" ]]; then
  # force term value to get proper colors in systemd and tmux 3.6a
  # https://github.com/Morantron/tmux-fingers/issues/143
  FINGERS_TERM=$(tmux show-option -gqv default-terminal)
else
  FINGERS_TERM="$TERM"
fi

tmux run "TERM=$FINGERS_TERM $FINGERS_BINARY load-config"
exit $?
