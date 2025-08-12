# Inception

A Docker-based infrastructure project that sets up a complete web stack using Docker Compose. This project demonstrates containerization principles by creating a WordPress website with NGINX reverse proxy and MariaDB database.

## 📋 Overview

The Inception project creates a fully containerized development environment with:
- **NGINX**: Web server with SSL/TLS (HTTPS only)
- **WordPress**: Content management system with PHP-FPM
- **MariaDB**: Database server for WordPress

All services run in separate Docker containers connected through a custom network.

## 🏗️ Architecture

```
[Internet] → [NGINX:443] → [WordPress:9000] → [MariaDB:3306]
                ↓              ↓               ↓
           [SSL/HTTPS]    [PHP-FPM]      [Database]
```

## 📁 Project Structure

```
inception/
├── Makefile
├── README.md
└── srcs/
    ├── docker-compose.yml
    ├── .env
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/nginx.conf
        │   └── tools/script.sh
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/script.sh
        └── mariadb/
            ├── Dockerfile
            ├── conf/
            └── tools/script.sh
```

## 🚀 Quick Start

### Prerequisites
- Docker Engine 20.10+
- Docker Compose 2.0+
- Linux/macOS system

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/ahmedelqori/Inception.git
   cd Inception
   ```

2. **Configure environment**
   ```bash
   cp srcs/.env.example srcs/.env
   # Edit .env file with your configurations
   ```

3. **Create data directories**
   ```bash
   mkdir -p ~/data/wordpress ~/data/mariadb
   ```

4. **Build and run**
   ```bash
   make
   ```

5. **Access the website**
   - Open your browser and go to `https://localhost`
   - Accept the self-signed certificate warning

## 🔧 Configuration

### Environment Variables (.env)
```bash
# Domain
DOMAIN_NAME=localhost

# Database
MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD=your_password

# WordPress
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=admin_password
WP_ADMIN_EMAIL=admin@example.com
```

### Make Commands
```bash
make        # Build and start all services
make up     # Start services
make down   # Stop services
make clean  # Remove containers and images
make fclean # Complete cleanup including volumes
make re     # Rebuild everything
```

## 📦 Services

### NGINX
- **Port**: 443 (HTTPS only)
- **Features**: SSL/TLS 1.2+, reverse proxy to WordPress
- **Base Image**: Alpine Linux

### WordPress
- **Port**: 9000 (internal)
- **Features**: PHP-FPM, WP-CLI, automatic setup
- **Base Image**: Alpine Linux with PHP 8.2

### MariaDB
- **Port**: 3306 (internal)
- **Features**: Persistent data storage, user management
- **Base Image**: Alpine Linux

## 🔒 Security Features

- HTTPS-only access (HTTP redirects to HTTPS)
- Self-signed SSL certificates
- Network isolation between containers
- Non-root container execution
- Secure database user privileges

## 📂 Data Persistence

- **WordPress files**: `~/data/wordpress`
- **Database data**: `~/data/mariadb`

Data is preserved between container restarts and rebuilds.

## 🛠️ Troubleshooting

### Common Issues

**Port 443 already in use:**
```bash
sudo lsof -i :443
sudo systemctl stop nginx  # if system nginx is running
```

**Permission denied:**
```bash
sudo chown -R $USER:$USER ~/data/
```

**SSL certificate errors:**
- Accept the self-signed certificate in your browser
- Or replace with your own certificates in the nginx configuration

**Container won't start:**
```bash
docker logs <container_name>
make logs  # if available
```

## 🔍 Useful Commands

```bash
# View running containers
docker ps

# Check container logs
docker logs nginx
docker logs wordpress
docker logs mariadb

# Execute commands in containers
docker exec -it nginx sh
docker exec -it wordpress sh
docker exec -it mariadb sh

# View docker-compose logs
docker-compose -f srcs/docker-compose.yml logs
```

## 📝 Notes

- This project uses custom Docker images built from Alpine Linux
- All containers restart automatically on failure
- The setup includes WordPress admin user creation
- Database is automatically initialized with WordPress tables

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is part of the 42 School curriculum and is for educational purposes.