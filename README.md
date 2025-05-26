# Nginx + Owncast Docker Setup

This repository contains a Docker Compose configuration for running Nginx as a reverse proxy with SSL termination in front of an Owncast streaming server.

## Security Features

- Owncast admin interface (port 8080) is not directly exposed to the internet
- All web traffic is forced through Nginx with SSL
- RTMP port (1935) is available on the local network for streaming
- Services are isolated using Docker networks

## Prerequisites

- Docker and Docker Compose installed on your host system
- A domain name pointing to your server (for proper SSL)
- Port 80, 443, and 1935 available on your host

## Setup Instructions

1. Clone this repository to your server
2. Run the setup script to create necessary directories and SSL certificates:
   ```bash
   ./setup.sh
   ```
3. Update the configuration:
   - Change the `server_name` in `nginx/conf/default.conf` to your domain
   - Set a secure password for Owncast in `docker-compose.yml`
   - Replace the self-signed SSL certificates with proper ones for production

4. Start the services:
   ```bash
   docker-compose up -d
   ```

5. Access your Owncast instance at https://yourdomain.com

## Configuration

### Nginx
- Configuration files are stored in `./nginx/conf/`
- SSL certificates are stored in `./nginx/ssl/`
- For production, replace the self-signed certificates with proper ones

### Owncast
- All Owncast data is persisted in a Docker volume
- Default admin credentials:
  - Username: admin
  - Password: Set in docker-compose.yml environment variables

## Streaming

To stream to your Owncast server:
- RTMP URL: rtmp://your-server-ip:1935/live
- Stream key: Set in the Owncast admin interface

## Maintenance

- To view logs: `docker-compose logs -f`
- To restart services: `docker-compose restart`
- To stop all services: `docker-compose down`
- To update images: `docker-compose pull && docker-compose up -d`

## Backup

The Owncast data is stored in a Docker volume. To back it up:
```bash
docker run --rm -v owncast_data:/data -v $(pwd):/backup alpine tar -czvf /backup/owncast-backup.tar.gz /data
```

## Restore

To restore from a backup:
```bash
docker run --rm -v owncast_data:/data -v $(pwd):/backup alpine sh -c "rm -rf /data/* && tar -xzvf /backup/owncast-backup.tar.gz -C /"
```