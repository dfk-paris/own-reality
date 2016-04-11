#!/bin/bash -e

function deps {
  uglifyjs \
    node_modules/jquery/dist/jquery.js \
    widgets/vendor/jquery-ui.js \
    widgets/vendor/jquery.easyModal.js \
    node_modules/riot/riot.min.js \
    -o tmp/deps.js

  #   node_modules/vis/dist/vis.min.js \
  # cp node_modules/vis/dist/vis.min.css tmp/_vis.scss
  cp widgets/vendor/jquery-ui.css tmp/_jquery-ui.css
  cp widgets/vendor/jquery-ui.structure.css tmp/_jquery-ui.structure.css
  cp widgets/vendor/jquery-ui.theme.css tmp/_jquery-ui.theme.css
}

function i18n {
  uglifyjs widgets/locale/*.js -o tmp/i18n.js
}

$1
