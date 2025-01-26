#!/bin/bash

# Check if backup timestamp is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <backup_timestamp>"
    echo "Example: $0 20240126_120000"
    exit 1
fi

TIMESTAMP=$1

# Check if backup files exist
if [ ! -f "backups/workflows-$TIMESTAMP.json" ] || [ ! -f "backups/credentials-$TIMESTAMP.json" ]; then
    echo "Error: Backup files for timestamp $TIMESTAMP not found"
    echo "Please check the backups directory for available backups"
    ls -l backups/
    exit 1
fi

# Copy backup files to shared directory
cp backups/workflows-$TIMESTAMP.json shared/
cp backups/credentials-$TIMESTAMP.json shared/

# Import workflows and credentials
docker-compose exec -T n8n n8n import:workflow --input=/data/shared/workflows-$TIMESTAMP.json
docker-compose exec -T n8n n8n import:credentials --input=/data/shared/credentials-$TIMESTAMP.json

echo "Restore completed successfully from backup $TIMESTAMP" 