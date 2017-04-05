#!/usr/bin/env bash

function _errquit {
    echo "ERROR: ${1}"
    exit 1
}

function get_tag {
    local TAG=$(git describe --tags $(git rev-list --tags --max-count=1))
    [[ -z "${TAG}" ]] && _errquit "Currently not on a tagged version"
    echo $TAG | sed 's/^v//'
}

command -v fpm > /dev/null 2>&1 || _errquit "fpm not found"

VERSION=$(get_tag)

fpm -s dir \
    -t rpm \
    -n dehydrated \
    -v $VERSION \
    --url https://github.com/spilgames/dehydrated \
    --description "This is a client for signing certificates with an ACME-server (currently only provided by Let's Encrypt) implemented as a relatively simple bash-script." \
    --depends curl \
    --depends openssl \
    --depends diffutils \
    --depends grep \
    --depends sed \
    --depends openssl \
    --prefix /bin \
    dehydrated


echo "Build package"
echo "Upload it to the reposync"
