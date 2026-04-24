# Variables
DATE=$(date +%F)
DB_NAME="kodekloud_db01"
DB_USER="kodekloud_roy"
DB_PASS="asdfgdsd"
DUMP_FILE="db_${DATE}.sql"

# Run dump on app server
ssh tony@stapp01 "mysqldump -u ${DB_USER} -p${DB_PASS} ${DB_NAME}" > /tmp/${DUMP_FILE}

# Copy to storage server
scp /tmp/${DUMP_FILE} natasha@ststor01:/home/natasha/db_backups/