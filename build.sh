#!/usr/bin/env bash

set -eu

cd "$(dirname "$0")"

DOCKER_REPO=dplusic/stack-ghcjs
PUSH=false
DRY=false
LATEST=false

usage() {
    echo "$0: $1" >&2
    echo
    echo "Usage: $0 [--push] [--dry-run] [--latest] tag"
    echo
    exit 1
}

dry() {
    echo ">>> $*"
    [[ $DRY = true ]] || "$@"
}

push() {
    [[ $PUSH = false ]] || dry docker push "$1"
}

tagpush() {
    dry docker tag "$1" "$2"
    push "$2"
}

LTS_SLUG=
while [[ $# -gt 0 ]]; do
    case "$1" in
        --push)
            PUSH=true
            shift
            ;;
        --dry-run)
            DRY=true
            shift
            ;;
        --latest)
            LATEST=true
            shift
            ;;
        -*)
            usage "Unknown option: $1"
            ;;
        *)
            if [[ -n "$LTS_SLUG" ]]; then
                usage "Cannot specify multiple tags: $1"
            fi
            LTS_SLUG="$1"
            shift
            ;;
    esac
done

if [[ "$LTS_SLUG" = "" ]]; then
    usage "Missing argument: tag"
fi

if [ ! -d "$LTS_SLUG" ]; then
    echo "$0: Cannot find tag: $LTS_SLUG" >&2
    exit 1
fi

dry docker build -t "$DOCKER_REPO:$LTS_SLUG" $LTS_SLUG
push "$DOCKER_REPO:$LTS_SLUG"

if [[ $LATEST = true ]]; then
    tagpush "$DOCKER_REPO:$LTS_SLUG" "$DOCKER_REPO:latest"
fi
