# bash args

*Producing quality scripts with ease.*

## Description

bash-args is a small library which does the heavy-lifting for all your argument parsing needs (if not: [request a feature][gh-issues] :P) for your bash scripts.
Written originally for my own [bash-utils][bash-utils-repo].

## How do I use it?

Source the library, then define keyword and required arguments and call the `parse_args` function.
If you want to create a self-contained script with this library, you could use [bundle-script.sh][bundle-script] (which is what I do myself).

Example (You can find this and more examples in the [examples](./examples) folder):

```bash
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
```

### What does this get me?

Let's say, you saved the example above as `example.sh` (don't forget adding a shebang and making it executable). Now, you'd get the following behavior:

1. If you to call your script with `--help`, you get your usage instructions:

  ```sh
  $ ./examples/demo.sh --help
  A dummy function to showcase the bash-args library
  
  USAGE:
    demo.sh [--config] [-i|--interactive] [-s|--sleep] [--letter] username
      username    Your username
  
    OPTIONS:
      --sleep <number>, -s <number>    Sleep <number> seconds before doing anything
      --config <value>                 Read configuration from a file
      --interactive, -i                Ask before doing anything dangerous
      --letter <value>                 Provide some letters (Can be supplied multiple times)
  ```

2. If you call it without the required positional argument `username`, you get an error:

  ```sh
  $ ./examples/demo.sh
  ERROR: The following required arguments are missing: username
  USAGE:
    demo.sh [--config] [-i|--interactive] [-s|--sleep] [--letter] username
      username    Your username
  
    OPTIONS:
      --sleep <number>, -s <number>    Sleep <number> seconds before doing anything
      --config <value>                 Read configuration from a file
      --interactive, -i                Ask before doing anything dangerous
      --letter <value>                 Provide some letters (Can be supplied multiple times)
  ```

3. If you call it with an invalid (non-int) argument for `-s` or `--sleep`, you get an error:

  ```sh
  $ ./examples/demo.sh -s five
  ERROR: Expected a number but got 'five'!
  
  USAGE:
    demo.sh [--config] [-i|--interactive] [-s|--sleep] [--letter] username
      username    Your username
  
    OPTIONS:
      --sleep <number>, -s <number>    Sleep <number> seconds before doing anything
      --config <value>                 Read configuration from a file
      --interactive, -i                Ask before doing anything dangerous
      --letter <value>                 Provide some letters (Can be supplied multiple times)
  ```

4. If you call it with proper arguments, it does what it's supposed to:

  ```sh
  $ ./examples/demo.sh thecalcaholic -s 5 extra --config /home/thecalcaholic/example_config.json -i --letter a --letter b --letter c
  Your arguments:
  username: thecalcaholic
  config: /home/thecalcaholic/example_config.json
  interactive: true
  Your letters: a, b, c
  sleep: 5
  any other args you provided: extra
  ```

## Roadmap

* typed lists
* type checking/support for named (required) arguments
* some kind of automatic tests

[gh-issues]: https://github.com/theCalcaholic/bash-args/issues
[bash-utils-repo]: https://github.com/theCalcaholic/bash-utils
[bundle-script]: https://github.com/theCalcaholic/bash-utils#bundle-scriptsh
