#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/X11R6/bin
  TODAY=`date +%Y-%m-%d`
  DATA_DIR=/media/data/
  TMP_BACKUP_DIR=/backup/
  BACKUP_DIR=/mnt/smb/xxx/
  BACKUP_DIR_WEEKLY=/mnt/smb/xxxy/
  BACKUP_FILE=$TODAY.$HOSTNAME.gz
  BACKUP_FILE_ERROR=$TODAY.$HOSTNAME.gz.error

    echo "$TODAY "
    echo "$TODAY  Backup beginning at `date`"
    if [[ $(date +%u) -gt 6 ]] ; then
      BACKUP_DIR=$BACKUP_DIR_WEEKLY
    fi
    if [ -f $BACKUP_DIR$BACKUP_FILE ];
    then
        echo "file exists, exiting"
        exit
    fi
    if [ -f $TMP_BACKUP_DIR$BACKUP_FILE ];
    then
        echo "file exists in local file system, exiting"
        exit
    fi

  echo "$TODAY  Stopping mongodb at `date`"
  service mongodb stop || { echo 'mongodb stop failed' ; exit 1; }
  echo "$TODAY  Creating backup $BACKUP_FILE in $TMP_BACKUP_DIR"
  tar -c $DATA_DIR | pigz -9 > $TMP_BACKUP_DIR$BACKUP_FILE
  service mongodb start || { echo 'mongodb start failed'; exit 1; }
  echo "$TODAY  Starting mongodb at `date`"
  FILESIZE_BEFORE=$(stat -c%s "$TMP_BACKUP_DIR$BACKUP_FILE")

  echo "$TODAY  Copying $TMP_BACKUP_DIR$BACKUP_FILE to $BACKUP_DIR$BACKUP_FILE"
  cp $TMP_BACKUP_DIR$BACKUP_FILE $BACKUP_DIR$BACKUP_FILE
  FILESIZE_AFTER=$(stat -c%s "$BACKUP_DIR$BACKUP_FILE")
  if [ -f $TMP_BACKUP_DIR$BACKUP_FILE ];
  then
      echo "Error: $TMP_BACKUP_DIR$BACKUP_FILE was not moved!"
  fi
  if [ "$FILESIZE_BEFORE" != "$FILESIZE_AFTER" ]; then
      echo "Error: File sizes do not match, rename to error"
      mv $BACKUP_DIR$BACKUP_FILE $BACKUP_DIR$BACKUP_FILE_ERROR
  else
      echo "$TODAY  Removing local copy of backup $TMP_BACKUP_DIR$BACKUP_FILE"
      rm $TMP_BACKUP_DIR$BACKUP_FILE
  fi
  echo "$TODAY  Removing backups older than 3 days from $BACKUP_DIR"
  if [[ $(date +%u) -lt 7 ]] ; then
    find $BACKUP_DIR -mtime +3 -type f -exec rm -rf {} \;
  fi
  echo "$TODAY  Backup complete at `date`"
