#!/bin/sh
echo -ne '\033c\033]0;Entropy The Metal Anomaly\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Entropy The Metal Anomaly.x86_64" "$@"
