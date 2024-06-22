#!/bin/bash

# Function to URL-encode a string
url_encode() {
    local string="$1"
    local encoded=""
    local i c o
    for ((i = 0; i < ${#string}; i++)); do
        c=${string:$i:1}
        case "$c" in
            [a-zA-Z0-9.~_-]) o="$c" ;;
            *) printf -v o '%%%02x' "'$c"
        esac
        encoded+="$o"
    done
    echo "$encoded"
}

# Function to URL-decode a string
url_decode() {
    local string="${1//+/ }"
    printf '%b' "${string//%/\\x}"
}

# Check for command-line arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <url> <-encode|-decode>"
    exit 1
fi

url="$1"
option="$2"

# Split URL into part before and after the equals sign
before_equals="${url%%=*}"
after_equals="${url#*=}"

# Perform encoding or decoding based on the command-line option
case "$option" in
    -encode)
        encoded_after_equals=$(url_encode "$after_equals")
        echo "$before_equals=$encoded_after_equals"
        ;;
    -decode)
        decoded_after_equals=$(url_decode "$after_equals")
        echo "$before_equals=$decoded_after_equals"
        ;;
    *)
        echo "Invalid option: $option"
        echo "Usage: $0 <url> <-encode|-decode>"
        exit 1
        ;;
esac
