#!/bin/bash
mkdir -p $BACKUP_DIR_PATH
backup_file="$BACKUP_DIR_PATH/db_$(date -u +"%FT%H:%M:%SZ").dump"

echo "Starting backup into $backup_file"
if [[ -z "${MONGO_URI}" ]];
then
  mongodump --archive --host $MONGO_HOST -u $MONGO_USERNAME -p $MONGO_PASSWORD > $backup_file
else
  mongodump --archive --uri=$MONGO_URI > $backup_file
fi

echo "Backup complete"

if [[ -z "${SSH_SERVER_IP}" ]];
then
  echo "SSH SSH_SERVER_IP IS EMPTY, SAVE ONLY LOCAL"
else
  echo "Found SSH_SERVER_IP starting uploading"

  mkdir -p /root/.ssh && \
      chmod 0700 /root/.ssh && \
      ssh-keyscan $SSH_SERVER_IP > /root/.ssh/known_hosts

  echo "$SSH_KEY" > /root/.ssh/id_rsa && \
      chmod 600 /root/.ssh/id_rsa
  ssh $SSH_USER@$SSH_SERVER_IP "mkdir -p $SSH_DESTINATION;"
  echo "Uploading backup to $SSH_SERVER_IP:$SSH_DESTINATION"
  scp $backup_file $SSH_USER@$SSH_SERVER_IP:$SSH_DESTINATION
  echo "Uploading finished"
fi
