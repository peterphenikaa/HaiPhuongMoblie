# PowerShell script for Windows
Write-Host "🚀 Setting up Thanh Binh Mobile with Docker..." -ForegroundColor Green

# Copy environment file
if (!(Test-Path .env)) {
    Write-Host "📄 Creating .env file..." -ForegroundColor Yellow
    Copy-Item .env.docker .env
}

# Build and start containers
Write-Host "🐳 Building Docker containers..." -ForegroundColor Cyan
docker-compose up -d --build

# Wait for MySQL to be ready
Write-Host "⏳ Waiting for MySQL to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Install dependencies
Write-Host "📦 Installing Composer dependencies..." -ForegroundColor Cyan
docker-compose exec app composer install

# Generate application key
Write-Host "🔑 Generating application key..." -ForegroundColor Cyan
docker-compose exec app php artisan key:generate

# Run migrations
Write-Host "🗄️ Running database migrations..." -ForegroundColor Cyan
docker-compose exec app php artisan migrate --force

# Run seeders (optional)
$response = Read-Host "❓ Do you want to run database seeders? (y/n)"
if ($response -eq 'y' -or $response -eq 'Y') {
    Write-Host "🌱 Running database seeders..." -ForegroundColor Cyan
    docker-compose exec app php artisan db:seed
}

# Create storage link
Write-Host "🔗 Creating storage link..." -ForegroundColor Cyan
docker-compose exec app php artisan storage:link

# Set permissions
Write-Host "🔐 Setting permissions..." -ForegroundColor Cyan
docker-compose exec app chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
docker-compose exec app chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Clear cache
Write-Host "🧹 Clearing cache..." -ForegroundColor Cyan
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan view:clear

Write-Host ""
Write-Host "✅ Setup complete!" -ForegroundColor Green
Write-Host "🌐 Application: http://localhost:8000" -ForegroundColor Yellow
Write-Host "🗄️ PhpMyAdmin: http://localhost:8080" -ForegroundColor Yellow
Write-Host ""
Write-Host "Useful commands:" -ForegroundColor Cyan
Write-Host "  docker-compose ps                    # View running containers"
Write-Host "  docker-compose logs -f               # View logs"
Write-Host "  docker-compose exec app bash         # Access app container"
Write-Host "  docker-compose exec app php artisan  # Run artisan commands"
Write-Host "  docker-compose down                  # Stop containers"
Write-Host "  docker-compose down -v               # Stop and remove volumes"
