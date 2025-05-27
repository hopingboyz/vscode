#!/bin/bash

# Start SSH server in background (optional)
sudo service ssh start

# Start code-server
exec code-server --bind-addr 0.0.0.0:8080 --auth password /workspace
