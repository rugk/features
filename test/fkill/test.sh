#!/usr/bin/env bash
# This code was generated by the dcontainer cli 
# For more information: https://github.com/devcontainers-contrib/cli 

set -e

source dev-container-features-test-lib

check "fkill --version" fkill --version

reportResults
