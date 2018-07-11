#!/bin/sh

echo "Starting"

echo "Moving settings file if it doesn't exist..."
if [ ! -f ${CONFIG_PATH}/default.json ]; then
  mv /opt/Floatplane-Downloader/settings.json $CONFIG_PATH
fi

echo "Updating permissions..."
for dir in /opt/Floatplane-Downloader /etc/s6.d /config /media; do
  if $(find $dir ! -user $UID -o ! -group $GID|egrep '.' -q); then
    echo "Updating permissions in $dir..."
    chown -R $UID:$GID $dir
  else
    echo "Permissions in $dir are correct."
  fi
done
echo "Done updating permissions."


sed -i 's/"user": "!",/"user": "'$Username'",/' /opt/Floatplane-Downloader/settings.json
sed -i 's/"password": "!",/"password": "'$Password'",/' /opt/Floatplane-Downloader/settings.json
sed -i 's/"videoFolder": "!",/"videoFolder": "'$Media'",/' /opt/Floatplane-Downloader/settings.json

su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
