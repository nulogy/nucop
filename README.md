# Nucop

This gem contains custom cops and additional tooling for Nulogy's implementation of [RuboCop](https://github.com/rubocop-hq/rubocop).

This functionaltiy is executed by the `bin/nucop` executable. If you installed the gem, it will be added to your path.

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
