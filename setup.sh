#!/bin/bash

# Create necessary directories
mkdir -p nginx/conf
mkdir -p nginx/ssl

# Check if SSL certificates exist, if not create self-signed certs
if [ ! -f "nginx/ssl/cert.pem" ] || [ ! -f "nginx/ssl/key.pem" ]; then
    echo "Generating self-signed SSL certificates..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
      -keyout nginx/ssl/key.pem -out nginx/ssl/cert.pem \
      -subj "/C=US/ST=State/L=City/O=Organization/CN=streaming.example.com"
    
    echo "Self-signed certificates created. Replace with real certificates for production."
fi

# Make setup script executable
chmod +x setup.sh

echo "Setup complete. Run 'docker-compose up -d' to start the services."
echo "IMPORTANT: Change the default Owncast admin password in docker-compose.yml!"
echo "IMPORTANT: Update the server_name in nginx/conf/default.conf to your domain!"