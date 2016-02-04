#!/bin/bash -e

function deps {
  uglifyjs \
    node_modules/zepto/zepto.min.js \
    node_modules/vis/dist/vis.min.js \
    node_modules/riot/riot.min.js \
    -o tmp/deps.js

  cp node_modules/vis/dist/vis.min.css tmp/_vis.scss
}

$1