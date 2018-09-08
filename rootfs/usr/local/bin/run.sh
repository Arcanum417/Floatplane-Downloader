#!/bin/sh

echo "Starting"

echo node version: `node --version`

if [ "$JUST_RUN" = "N" ]; then
  echo "Getting newest version from GitHub"
  cp /app/partial.json $CONFIG_PATH
  cp /app/videos.json $CONFIG_PATH
  rm -rf /app
  git clone $GIT_URL /app
  cd /app
  npm install
  cp -f $CONFIG_PATH/settings.json /app
  cp -f $CONFIG_PATH/partial.json /app
  cp -f $CONFIG_PATH/videos.json /app
  echo "Update complete"
fi

echo "Updating permissions..."
for dir in /config /etc/s6.d; do
  if $(find $dir ! -user $UID -o ! -group $GID|egrep '.' -q); then
    echo "Updating permissions in $dir..."
    chown -R $UID:$GID $dir
  else
    echo "Permissions in $dir are correct."
  fi
done
echo "Done updating permissions."

echo "Setting up settings"
sed -i 's/"user": "",/"user": "'$USERNAME'",/' /app/settings.json
sed -i 's/"password": ""/"password": "'$PASSWORD'"/' /app/settings.json
sed -i 's/"videoFolder": ".*",/"videoFolder": "'${MEDIA_PATH//\//\\/}'",/' /app/settings.json
sed -i 's/"repeatScript": "false",/"repeatScript": "'$REPEAT_SCRIPT'",/' /app/settings.json
echo "Done setting up settings"

echo "Moving settings file"
if [ ! -f $CONFIG_PATH/settings.json ]; then
  cp /app/settings.json $CONFIG_PATH
else
  cp -f $CONFIG_PATH/settings.json /app
fi
echo "Done moving settings file"

su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
