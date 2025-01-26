#!/bin/bash

# Set timestamp for backup files
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Create backup directories if they don't exist
mkdir -p backups shared

# Export workflows and credentials
docker-compose exec -T n8n n8n export:workflow --all --output=/data/shared/workflows-$TIMESTAMP.json
docker-compose exec -T n8n n8n export:credentials --all --output=/data/shared/credentials-$TIMESTAMP.json

# Copy files to backup directory
cp shared/workflows-$TIMESTAMP.json backups/
cp shared/credentials-$TIMESTAMP.json backups/

# Clean up backups older than 30 days
find backups -name "*.json" -type f -mtime +30 -delete

echo "Backup completed successfully at $TIMESTAMP" 