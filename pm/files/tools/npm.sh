#!/bin/bash

DOCROOT="$1"
[[ -z "$DOCROOT" ]] && exit 1

pushd $DOCROOT >/dev/null
(( $? != 0 )) && exit 1
find . -maxdepth 6 -name package.json | grep -v "vendor" | grep -v "node_modules" | while read GFILE; do
  pushd "${GFILE%/*}" >/dev/null
  echo "======= package.json in folder ${GFILE%/*} ======="
  npm install -q
  grep '"build"' package.json >/dev/null 2>&1 && npm run build
  popd >/dev/null
done

find . -maxdepth 6 -name bower.json | grep -v "vendor" | grep -v "node_modules" | while read GFILE; do
  pushd "${GFILE%/*}" >/dev/null
  echo "======= bower.json in folder ${GFILE%/*} ======="
  bower install
  popd >/dev/null
done

find . -maxdepth 6 -name Gruntfile.js | grep -v "vendor" | grep -v "node_modules" | while read GFILE; do
  pushd "${GFILE%/*}" >/dev/null
  echo "======= Gruntfile.js in folder ${GFILE%/*} ======="
  grunt build --force
  popd >/dev/null
done

find . -maxdepth 6 -name gulpfile.js | grep -v "vendor" | grep -v "node_modules" | while read GFILE; do
  pushd "${GFILE%/*}" >/dev/null
  echo "======= gulpfile.js in folder ${GFILE%/*} ======="
  ISSASS=$(find . -type d -regex '^.*vendor/bundle/.*bin$' | tail -n 1 | tr -d "\n" | sed "s;/bin;;")
  [[ -n "$ISSASS" ]] && export PATH="${PATH}:${ISSASS}/bin" && export GEM_HOME="${ISSASS}"
  gulp build
  popd >/dev/null
done

popd > /dev/null
