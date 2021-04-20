#!/usr/bin/env bash

. "$(cd "${BASH_SOURCE[0]%/*}/.."; pwd)/parse_args.sh"


declare -A USAGE
USAGE['firstname']="Your first name"
USAGE['-s']="Your surname"
USAGE['--formal']="Whether or not to create a formal greeting"
USAGE['--title']="Your title, if any"
USAGE['--say']="Additional phrases to say"

KEYWORDS=("-s|--surname" "--formal;bool" "--title" "--say;list")
REQUIRED=("firstname")

parse_args "$@" || exit $?

firstname="${NAMED_ARGS['firstname']}"
surname="${KW_ARGS['-s']:-${KW_ARGS['--surname']}}"


if [[ -n "${KW_ARGS['--title']}" ]]
then
  name="${KW_ARGS['--title']} ${surname:-$firstname}"
else
  name="$firstname${surname:+ ${surname}}"
fi

if [[ "${KW_ARGS['--formal']}" == "true" ]]
then
  greeting="Good day"
else
  greeting="Hey"
fi

echo "$greeting, $name"
if [[ -n "${KW_ARGS['--say']}" ]]
then
  echo "${KW_ARGS['--say']}"
fi

