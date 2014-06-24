mongo_backup_script
===================

a mongo backup script


Use this on one of your replicas in a mongo replica set.

It backs up the mongo files daily (pick a slow time of day is best!)
It zips the backup
It copies and keeps 3 most recent daily backups, and deletes older daily backups.
And once a week it stores the end-of-week daily  backup for long term storage and does not delete.

Configure the shared folder (nas) where to store the backups.

1. It will stop the mongo instance
2. Backup and compress the mongo files
3. Copy them to a shared folder
4. Keep a weekly backup
5. Keep 3 daily backups
6. Restarts mongo

Mongo will automatically resync and catch up to the master. 
Typically this is run with a > 3 node replica set.



