#!/bin/sh

echo "Starting"

echo "Moving settings file"
if [ ! -f $CONFIG_PATH/settings.json ]; then
  cp /opt/Floatplane-Downloader/settings.json $CONFIG_PATH
else
  cp -f $CONFIG_PATH/settings.json /opt/Floatplane-Downloader
fi
echo "Done moving settings file"

echo "Updating permissions..."
for dir in /opt/Floatplane-Downloader /etc/s6.d $CONFIG_PATH $MEDIA_PATH; do
  if $(find $dir ! -user $UID -o ! -group $GID|egrep '.' -q); then
    echo "Updating permissions in $dir..."
    chown -R $UID:$GID $dir
  else
    echo "Permissions in $dir are correct."
  fi
done
echo "Done updating permissions."

echo "Setting up settings"
sed -i 's/"user": "",/"user": "'$USERNAME'",/' /opt/Floatplane-Downloader/settings.json
sed -i 's/"password": ""/"password": "'$PASSWORD'"/' /opt/Floatplane-Downloader/settings.json
sed -i 's/"videoFolder": "./videos/",/"videoFolder": "'$MEDIA_PATH'",/' /opt/Floatplane-Downloader/settings.json
echo "Done setting up settings"

su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
