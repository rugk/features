#!/usr/bin/env bash
# This code was generated by the dcontainer cli 
# For more information: https://github.com/devcontainers-contrib/cli 

set -e



ensure_curl() {
    # Ensure curl available
    if ! type curl >/dev/null 2>&1; then
        apt-get update -y && apt-get -y install --no-install-recommends curl ca-certificates
    fi 
}


ensure_dcontainer() {
    # Ensure existance of the dcontainer cli program
    local variable_name=$1
    local dcontainer_location=""

    # If possible - try to use an already installed dcontainer
    if [[ -z "${DCONTAINER_FORCE_CLI_INSTALLATION}" ]]; then
        if [[ -z "${DCONTAINER_CLI_LOCATION}" ]]; then
            if type dcontainer >/dev/null 2>&1; then
                dcontainer_location=dcontainer
            fi
        elif [ -f "${DCONTAINER_CLI_LOCATION}" ] && [ -x "${DCONTAINER_CLI_LOCATION}" ] ; then
            dcontainer_location=${DCONTAINER_CLI_LOCATION}
        fi
    fi

    # If not previuse installation found, download it temporarly and delete at the end of the script 
    if [[ -z "${dcontainer_location}" ]]; then
        tmp_dir=$(mktemp -d -t dcontainer-XXXXXXXXXX)

        clean_up () {
            ARG=$?
            rm -rf $tmp_dir
            exit $ARG
        }

        trap clean_up EXIT

        curl -sSL -o $tmp_dir/dcontainer https://github.com/devcontainers-contrib/cli/releases/download/v0.2.0/dcontainer 
        curl -sSL -o $tmp_dir/checksums.txt https://github.com/devcontainers-contrib/cli/releases/download/v0.2.0/checksums.txt
        (cd $tmp_dir ; sha256sum --check --strict --ignore-missing $tmp_dir/checksums.txt)
        chmod a+x $tmp_dir/dcontainer
        dcontainer_location=$tmp_dir/dcontainer
    fi

    # Expose outside the resolved location
    declare -g ${variable_name}=$dcontainer_location

}

ensure_curl

ensure_dcontainer dcontainer_location

$dcontainer_location \
    feature install \
    "ghcr.io/devcontainers-contrib/features/npm-package:1.0.2" \
    --option package="tldr" --option version="$VERSION"


