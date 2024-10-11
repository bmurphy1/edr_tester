EDR Tester

Description

The project is a cross-platform Ruby-based testing framework designed to generate specific endpoint activities for the purpose of testing Endpoint Detection and Response (EDR) agents. It supports macOS and Linux platforms and triggers various system activities such as process creation, file operations, and network communications. The framework logs all activities in a JSON format log file.

Key Features

Project is split into a few classes for the purposes of single responsibility, dependency injection, and ease of testing.

Installation

Install the version of ruby specified in the .ruby-version file on the host machine.




Usage Examples

- run a process:
```bash
ruby edr_tester_cli.rb -a run_process --path /bin/ls
```

- send network data:
```bash
ruby edr_tester_cli.rb -a send_network_data --host localhost --port 80 --data "abc"
```

- create a file:
```bash
ruby edr_tester_cli.rb -a create_file --file "/path/to/file"
```

- modify a file:
```bash
ruby edr_tester_cli.rb -a modify_file --file "/path/to/file" --content "new content"
```

- delete a file:
```bash
ruby edr_tester_cli.rb -a delete_file --file "/path/to/file"
```