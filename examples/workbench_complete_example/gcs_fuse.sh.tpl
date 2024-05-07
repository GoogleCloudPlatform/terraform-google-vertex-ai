# Copyright 2023 Google LLC
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#      http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
