#!/bin/bash

echo "🚀 Setting up Thanh Binh Mobile with Docker..."

# Copy environment file
if [ ! -f .env ]; then
    echo "📄 Creating .env file..."
    cp .env.docker .env
fi

# Build and start containers
echo "🐳 Building Docker containers..."
docker-compose up -d --build

# Wait for MySQL to be ready
echo "⏳ Waiting for MySQL to be ready..."
sleep 10

# Install dependencies
echo "📦 Installing Composer dependencies..."
docker-compose exec app composer install

# Generate application key
echo "🔑 Generating application key..."
docker-compose exec app php artisan key:generate

# Run migrations
echo "🗄️ Running database migrations..."
docker-compose exec app php artisan migrate --force

# Run seeders (optional)
read -p "❓ Do you want to run database seeders? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "🌱 Running database seeders..."
    docker-compose exec app php artisan db:seed
fi

# Create storage link
echo "🔗 Creating storage link..."
docker-compose exec app php artisan storage:link

# Set permissions
echo "🔐 Setting permissions..."
docker-compose exec app chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
docker-compose exec app chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Clear cache
echo "🧹 Clearing cache..."
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan view:clear

echo "✅ Setup complete!"
echo "🌐 Application: http://localhost:8000"
echo "🗄️ PhpMyAdmin: http://localhost:8080"
echo ""
echo "Useful commands:"
echo "  docker-compose ps                    # View running containers"
echo "  docker-compose logs -f               # View logs"
echo "  docker-compose exec app bash         # Access app container"
echo "  docker-compose exec app php artisan  # Run artisan commands"
echo "  docker-compose down                  # Stop containers"
echo "  docker-compose down -v               # Stop and remove volumes"
