# Self-Hosted n8n Setup

This repository contains configuration and scripts for setting up a self-hosted n8n instance with:
- PostgreSQL database
- Qdrant vector database
- Nginx reverse proxy with SSL
- Automated backups
- Monitoring tools

## Quick Start

1. Clone this repository:
```bash
git clone https://github.com/dericyee/n8n-self-host.git
cd n8n-self-host
```

2. Copy and configure environment variables:
```bash
cp .env.example .env
# Edit .env with your settings
```

3. Start the services:
```bash
docker-compose up -d
```

4. Access n8n at `https://your.domain.com`

## Features

- SSL/HTTPS support via Let's Encrypt
- Automated backups with retention policy
- System monitoring tools
- Email notifications
- Vector database for AI features

## Scripts

- `scripts/backup.sh`: Automated backup of workflows and credentials
- `scripts/restore.sh`: Restore from backups
- `scripts/monitor.sh`: System monitoring and health checks

## Documentation

See [DOCUMENTATION.md](DOCUMENTATION.md) for detailed setup and maintenance instructions.

## Security

- SSL certificates managed by Let's Encrypt
- Secure credentials storage
- Regular security updates
- Encrypted database connections

## Maintenance

- Regular backups
- Log monitoring
- Resource usage tracking
- SSL certificate renewal

## License

MIT License
