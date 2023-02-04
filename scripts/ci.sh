#!/bin/bash

set -x

echo "Confirm that dependencies are installed"
rotrieve install

echo "Run linting"
roblox-cli analyze tests.project.json

echo "Build and run tests"
rojo build tests.project.json --output test-model.rbxmx
roblox-cli run --load.model test-model.rbxmx --run scripts/run-tests.lua
