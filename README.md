# Nucop

This gem contains custom cops and additional tooling for Nulogy's implementation of [RuboCop](https://github.com/rubocop-hq/rubocop).

This functionaltiy is executed by the `bin/nucop` executable. If you installed the gem, it will be added to your path.

## Purpose

When integrating RuboCop into large existing project, it is likely that it will have an overwhelming number of offenses.
To aid adoption, RuboCop can generate a `.rubocop_todo.yml` file to exclude existing violations.

This presents two problems:

* It is harder for developers to fix existing problems, since TODO violations are ignored
* Cops with too many violations are disabled, so new violations can be introduced into the codebase

Editors can help with the former. However, `nucop` provides a couple tools to help speed adoption:

1. Enforced cops

This is a new list of cops and/or departments that MUST not have violations.

This is useful in CI if you do not want developers to add new `Layout/` violations, etc.

Also, if `nucop regen_backlog` is used to regenerate the TODO file, any cops that had TODO violations,
but no longer have vioations are automatically added to enforced cops list.

2. `nucop modified_lines`

This command will print ALL RuboCop violations (i.e. including TODO violations) for all code lines changes since some git SHA.

This can be useful for local development, to increases visibility of existing violations during development cycles, but does
not hold up code in CI.

Finally, several custom cops are included, which may be application/framework/gem specific.

## CLI Commands

The [nucop CLI](lib/nucop/cli.rb) provides the following commands:

| Command              | Description                                                                                              |
|----------------------|----------------------------------------------------------------------------------------------------------|
| diff_enforced        | run RuboCop on the current diff using only the enforced cops                                             |
| diff_enforced_github | run RuboCop on the current diff using only the enforced cops (uses GitHub to determine the current diff) |
| diff                 | run RuboCop on the current diff                                                                          |
| diff_github          | run RuboCop on the current diff (uses GitHub to determine the current diff)                              |                                                                          |
| rubocop              | run RuboCop on files provided (without backlog by default)                                               |
| regen_backlog        | update the RuboCop backlog, updating enforced cops list                                                  |
| update_enforced      | update the enforced cops list with file with cops that no longer have violations                         |
| modified_lines       | display RuboCop violations for ONLY modified lines                                                       |
| ready_for_promotion  | display the next n cops with the fewest violations                                                       |

## Requirements

Beyond a working Ruby installation and what is specified in the gemspec, we make some assumptions about your environment:

* [git](https://git-scm.com/) for SCM
* `grep`

## Configuration

`nucop` can be configured by the YAML file `.nucop.yml`.

See the example config file `.nucop.yml.example`

| Option                   | Description                                                                                                                         | Default               |
|--------------------------|-------------------------------------------------------------------------------------------------------------------------------------|-----------------------|
| enforced_cops_file       | List of Cops or Departments that will be enforced. Only violations of enforced cops will cause the `diff_enforced` command to fail. | .rubocop.enforced.yml |
| rubocop_todo_file        | A generated file, containing the RuboCop TODO violations (i.e. RuboCop backlog)                                                     | .rubocop_todo.yml     |
| rubocop_todo_config_file | RuboCop configuration that will generate the list of RuboCop TODO violations                                                        | .rubocop.backlog.yml  |
| diffignore_file          | A file of paths or files that removed. Must be passable to `grep -f`.                                                               | .nucop_diffignore     |

## TODO

* Update README
  * Describe features
  * Document commands
* Undocumented option `junit_report` in `rubocop` command
* Introduce `RubocopCommandBuilder`
* Add tests!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
