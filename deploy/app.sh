#!/bin/bash -e

function deploy {
  setup
  deploy_code
  cleanup

  # PROWEB_PATH="/home/schepp/Desktop/dev/proweb/src"
  RSYNC_OPTS="--recursive --times --rsh=ssh --compress --human-readable --progress -e 'ssh -p $PORT'"
  # local "rsync $RSYNC_OPTS $PROWEB_PATH/ $HOST:$SHARED_PATH/proweb/"

  # DFK_PATH="/home/schepp/Desktop/dev/dfk_scripts/src/dfk"
  # local "rsync $RSYNC_OPTS $DFK_PATH/ $HOST:$SHARED_PATH/dfk/"

  task "bundle config set --local clean 'true'"
  task "bundle config set --local path '/home/app/or_bundle.2.6.6'"
  task "bundle config set --local without 'test development'"

  task "bundle --quiet"

  # remote "ln -sfn $SHARED_PATH/database.yml $CURRENT_PATH/config/database.yml"
  task "ln -sfn $SHARED_PATH/app.yml $CURRENT_PATH/config/app.yml"
  task "ln -sfn $SHARED_PATH/secrets.yml $CURRENT_PATH/config/secrets.yml"
  task "ln -sfn $SHARED_PATH/data $CURRENT_PATH/data"
  task "ln -sfn $SHARED_PATH/public_files $CURRENT_PATH/public/files"
  task "ln -sfn $SHARED_PATH/images $CURRENT_PATH/public/images"

  local "npm run build"
  local "rsync $RSYNC_OPTS public/app.js $HOST:$CURRENT_PATH/public/app.js"
  local "rsync $RSYNC_OPTS public/app.css $HOST:$CURRENT_PATH/public/app.css"
  local "rsync $RSYNC_OPTS public/vendor.css $HOST:$CURRENT_PATH/public/vendor.css"
  local "rsync $RSYNC_OPTS public/spinner.gif $HOST:$CURRENT_PATH/public/spinner.gif"
  local "rsync $RSYNC_OPTS json/ $HOST:$CURRENT_PATH/json/"

  task "cd $CURRENT_PATH && RAILS_ENV=production bundle exec rake or:from_json"

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
