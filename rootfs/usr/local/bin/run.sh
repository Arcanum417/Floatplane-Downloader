#!/bin/sh

echo "Starting"

echo "Updating permissions..."
for dir in /opt/Floatplane-Downloader /etc/s6.d /media; do
  if $(find $dir ! -user $UID -o ! -group $GID|egrep '.' -q); then
    echo "Updating permissions in $dir..."
    chown -R $UID:$GID $dir
  else
    echo "Permissions in $dir are correct."
  fi
done
echo "Done updating permissions."

su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
