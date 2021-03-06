#!/bin/bash

DOCROOT="$1"
[[ -z "$DOCROOT" ]] && exit 1
[[ ! -f /usr/bin/mvn ]] && echo "No mvn binary found" && exit 0

[[ -z "$LANG" ]] && export LANG=en_US.UTF-8
[[ -z "$HOME" ]] && export HOME=/var/www

pushd $DOCROOT >/dev/null
(( $? != 0 )) && exit 1
find . -maxdepth 6 -name pom.xml | while read GFILE; do
  pushd "${GFILE%/*}" >/dev/null
  /usr/bin/mvn install
  popd >/dev/null
done
popd > /dev/null