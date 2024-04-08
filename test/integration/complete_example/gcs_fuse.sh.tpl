#!/bin/bash
RAWDATA_BUCKET="${gcs_bucket}"
MLUSER="jupyter"
echo "Checking if gcsfuse is install"
if [ -f "/usr/bin/gcsfuse" ]
then
    if ! mount | grep "\b/home/$MLUSER/$RAWDATA_BUCKET\b>" > /dev/null
    then
      echo "Mounting the GCS Bucket"
      mkdir -p /home/$MLUSER/$RAWDATA_BUCKET
      chown $MLUSER /home/$MLUSER/$RAWDATA_BUCKET
      sudo -u $MLUSER /usr/bin/gcsfuse --implicit-dirs \
                       --dir-mode 777 \
                       --rename-dir-limit=100 \
                       --max-conns-per-host=100 \
                       $RAWDATA_BUCKET /home/$MLUSER/$RAWDATA_BUCKET
      else
        echo "skipping setup: gcsfuse already exists as a mount /home/$MLUSER/$RAWDATA_BUCKET"
      fi
else
    echo "gcsfuse missing, please install it"
fi
