# n8n Self-Hosted Setup Documentation

## Prerequisites
- Ubuntu server (DigitalOcean Droplet)
- Domain name pointing to server (n8n.sigmaschool.co)
- Docker and Docker Compose installed
- SSL certificates from Let's Encrypt

## Current Configuration
- n8n running on port 5678
- PostgreSQL database for data persistence
- Qdrant vector database for AI features
- Nginx as reverse proxy handling SSL
- SMTP configured for email notifications

## Installation Steps

1. Clone the repository:
```bash
git clone https://github.com/dericyee/n8n-self-host.git
cd n8n-self-host
```

2. Create and configure environment file:
```bash
cp .env.example .env
# Edit .env with your settings
```

3. Install Docker and Docker Compose:
```bash
curl -fsSL https://get.docker.com | sh
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

4. Set up SSL certificates:
```bash
apt-get update
apt-get install -y certbot
certbot certonly --standalone -d your.domain.com
```

5. Start the services:
```bash
docker-compose up -d
```

## Backup Procedures

1. Manual backup:
```bash
./scripts/backup.sh
```

2. Automated backups:
- Add to crontab: `0 0 * * * /path/to/backup.sh`
- Backups are stored in `backups/` directory
- Retention policy: 30 days

## Restore Procedures

1. List available backups:
```bash
ls -l backups/
```

2. Restore from backup:
```bash
./scripts/restore.sh TIMESTAMP
# Example: ./scripts/restore.sh 20240126_120000
```

## Security Settings

1. SSL/HTTPS:
- Certificates managed by Let's Encrypt
- Auto-renewal configured
- Strict transport security enabled

2. Authentication:
- User management enabled
- Secure cookie settings
- JWT authentication
- Basic auth disabled

3. File Permissions:
- n8n settings file: 600
- SSL certificates: 600
- Backup files: 600

## Maintenance Tasks

1. Monitor system health:
```bash
./scripts/monitor.sh
```

2. Update services:
```bash
docker-compose pull
docker-compose up -d
```

3. Renew SSL certificates:
```bash
certbot renew
```

4. Check logs:
```bash
docker-compose logs -f
```

## Troubleshooting

1. Container issues:
```bash
docker-compose ps
docker-compose logs [service]
```

2. SSL issues:
```bash
certbot certificates
openssl s_client -connect your.domain.com:443
```

3. Database issues:
```bash
docker-compose exec postgres psql -U n8n_prod
```

4. Backup/restore issues:
- Check file permissions
- Verify backup file integrity
- Check available disk space

## Monitoring

The monitoring script (`monitor.sh`) checks:
- Container status
- Service health
- Disk space
- Backup status
- SSL certificate expiry

## Contact

For support or questions:
- Email: admin@sigmaschool.co
- GitHub: https://github.com/dericyee/n8n-self-host 