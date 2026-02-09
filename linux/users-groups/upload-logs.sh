# trainer2: MONTHLY ASSIGNMENT ARCHIVE
# 1st of every month at 12:30 AM

## CRONTAB ENTRY (for trainer2)
crontab -u trainer2 -e

30 0 1 * * /usr/local/bin/archive-assignments.sh >> /var/log/assignment-archive.log 2>&1


## ARCHIVE SCRIPT (/usr/local/bin/archive-assignments.sh)
#!/bin/bash

Monthly assignment rotation and archiving
MONTH=$(date +%Y%m)
ASSIGN_DIR="/assignments"
ARCHIVE_DIR="/assignments-archive"

echo "$(date): Starting monthly assignment archive..."

mkdir -p ${ARCHIVE_DIR}/${MONTH}
tar -czf ${ARCHIVE_DIR}/${MONTH}/assignments-${MONTH}.tar.gz ${ASSIGN_DIR}/

Sync archive to S3
aws s3 cp ${ARCHIVE_DIR}/${MONTH}/assignments-${MONTH}.tar.gz s3://educloud-materials/backups/assignments/

find ${ASSIGN_DIR} -name "*.tar.gz" -mtime +90 -delete

echo "$(date): Archive completed: assignments-${MONTH}.tar.gz"


## SETUP COMMANDS

sudo mkdir -p /assignments-archive
sudo chown trainer2:trainers /assignments-archive

sudo tee /usr/local/bin/archive-assignments.sh > /dev/null << 'SCRIPT'
#!/bin/bash
MONTH=$(date +%Y%m)
mkdir -p /assignments-archive/${MONTH}
tar -czf /assignments-archive/${MONTH}/assignments-${MONTH}.tar.gz /assignments/
aws s3 cp /assignments-archive/${MONTH}/assignments-${MONTH}.tar.gz s3://educloud-materials/backups/assignments/
SCRIPT

sudo chmod +x /usr/local/bin/archive-assignments.sh
sudo chown trainer2:trainers /usr/local/bin/archive-assignments.sh

#Test
sudo -u trainer2 /usr/local/bin/archive-assignments.sh

#Add to crontab
sudo crontab -u trainer2 -l | { cat; echo "30 0 1 * * /usr/local/bin/archive-assignments.sh >> /var/log/assignment-archive.log 2>&1"; } | sudo crontab -u trainer2 -


## VERIFY
sudo crontab -u trainer2 -l
ls -la /usr/local/bin/archive-assignments.sh
