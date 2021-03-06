mongo_backup_script
===================

A mongo backup script

This backup script is for a simple backup of MongoDB. It backs up the files directly, and does not use mongodump.
The advantage of using the files directly is that you can use them to restore a node or when starting a new node in a replica set.
Also, I have found this method to be very reliable/predictable and easy to maintain.

Use this on one of your replicas in a mongo replica set.

It backs up the mongo files daily (pick a slow time of day is best!)
It zips the backup (mongodb files are by default highly compressable because they are stored uncompressed (with full field names) in the file system!) -- thanks to file mapping architecture.
It copies and keeps 3 most recent daily backups, and deletes older daily backups.
And once a week it stores the end-of-week daily  backup for long term storage and does not delete.

Configure the shared folder (nas) where to store the backups.

1. It will stop the mongo instance
2. Backup and compress the mongo files
3. Copy them to a shared folder
4. Keep a weekly backup
5. Keep 3 daily backups
6. Restarts mongo

Mongo will automatically resync and catch up to the master (er, primary), which is usually pretty quick dependening on your data insert rate. I've found that it can catch up an hour of data in less than a minute, with several :wq
Typically this is run with a > 3 node replica set.



