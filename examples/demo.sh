#!/usr/bin/env bash

# Source the library
. "$(cd "${BASH_SOURCE[0]%/*}/.."; pwd)/parse_args.sh"

# Define the keywords to use for (optional) keyword arguments. You can define aliases by separating parameter names with the pipe symbol |
# If using aliases, you for all purposes the first name in the list will be used (see below)
KEYWORDS=("--config" "-i|--interactive;bool" "-s|--sleep;int" "--letter;list")
# Define required positional arguments
REQUIRED=("username")

# Define a description which will be used in the --help message
DESCRIPTION="A dummy function to showcase the bash-args library"

# Define usage information for your arguments which will be used in the aut-generated usage message, e.g. when the --help argument was given
# Alternatively, you can define USAGE as a single string which will then replace the usage message generator
declare -A USAGE
USAGE[--config]="Read configuration from a file"
USAGE['-i']="Ask before doing anything dangerous"
USAGE['-s']="Sleep <number> seconds before doing anything" # Always use the first parameter name in your script if there are aliases
USAGE[username]="Your username"
USAGE["--letter"]="Provide some letters"
# Optionally, you can also set USAGE['COMMAND']. Otherwise, parse-args will defer the command name from your script

# Parse all arguments in "$@" and exit if there are parsing errors
parse_args "$@" || exit $?

# Show the usage message on specific exit codes in your script
set_trap 1 2

# Retrieve the arguments

echo "Your arguments:"
echo "username: ${NAMED_ARGS['username']}"
echo "config: ${KW_ARGS['--config']}"
# -i will always be set, because bools have a default value of "false"
echo "interactive: ${KW_ARGS['-i']}"
# list type arguments allow you to supply the argument multiple times. The arguments will be stored to KW_ARGS
# separated by newlines
echo "Your letters: ${KW_ARGS['--letter']//$'\n'/, }"

# Set a default value for the sleep argument
sleep="${KW_ARGS['-s']:-0}"
echo "sleep: $sleep"
echo "any other args you provided: ${ARGS[*]}"

