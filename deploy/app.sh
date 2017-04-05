#!/bin/bash -e

function deploy {
  setup
  deploy_code
  cleanup

  PROWEB_PATH="/home/schepp/Desktop/dev/proweb/src"
  RSYNC_OPTS="--recursive --times --rsh=ssh --compress --human-readable --progress -e 'ssh -p $PORT'"
  local "rsync $RSYNC_OPTS $PROWEB_PATH/ $HOST:$SHARED_PATH/proweb/"

  # DFK_PATH="/home/schepp/Desktop/dev/dfk_scripts/src/dfk"
  # local "rsync $RSYNC_OPTS $DFK_PATH/ $HOST:$SHARED_PATH/dfk/"

  task "bundle --clean --quiet --without test development --path /home/app/or_bundle"

  # remote "ln -sfn $SHARED_PATH/database.yml $CURRENT_PATH/config/database.yml"
  task "ln -sfn $SHARED_PATH/app.yml $CURRENT_PATH/config/app.yml"
  task "ln -sfn $SHARED_PATH/secrets.yml $CURRENT_PATH/config/secrets.yml"
  task "ln -sfn $SHARED_PATH/data $CURRENT_PATH/data"
  task "ln -sfn $SHARED_PATH/public_files $CURRENT_PATH/public/files"

  local "npm run build"
  local "rsync $RSYNC_OPTS public/app.js $HOST:$CURRENT_PATH/public/app.js"
  local "rsync $RSYNC_OPTS public/spinner.gif $HOST:$CURRENT_PATH/public/spinner.gif"

  task "touch tmp/restart.txt"

  finalize
}

function configure {
  source deploy/config.sh
  $1
  source deploy/lib.sh
}

configure
deploy



########################


  # within_do $CURRENT_PATH "RAILS_ENV=production bundle exec rake db:migrate"
  # within_do $CURRENT_PATH "RAILS_ENV=production bundle exec rake assets:precompile"

  # local "bundle exec rake assets:precompile"
  # local "rsync --recursive --times --rsh=ssh --compress --human-readable --progress public/assets/* $HOST:$CURRENT_PATH/public/assets"
  # remote "mkdir -p $CURRENT_PATH/public/assets/images"
  # # remote "mv $CURRENT_PATH/public/assets/bootstrap/dist/fonts $DEPLOY_TO/current/public"
  # # remote "mv $CURRENT_PATH/public/assets/jqueryui/themes/base/images/* $CURRENT_PATH/public/assets/images"
  # local "bundle exec rake assets:clean"
