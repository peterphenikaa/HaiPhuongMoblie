# Docker Setup for Thanh Binh Mobile

## Yêu cầu

-   Docker Desktop (Windows/Mac) hoặc Docker + Docker Compose (Linux)
-   Git

## Cài đặt nhanh

### Windows (PowerShell)

```powershell
.\docker-setup.ps1
```

### Linux/Mac (Bash)

```bash
chmod +x docker-setup.sh
./docker-setup.sh
```

## Cài đặt thủ công

### 1. Tạo file .env

```bash
cp .env.docker .env
```

### 2. Build và khởi động containers

```bash
docker-compose up -d --build
```

### 3. Cài đặt dependencies

```bash
docker-compose exec app composer install
```

### 4. Generate application key

```bash
docker-compose exec app php artisan key:generate
```

### 5. Chạy migrations

```bash
docker-compose exec app php artisan migrate
```

### 6. (Tùy chọn) Chạy seeders

```bash
docker-compose exec app php artisan db:seed
```

### 7. Tạo storage link

```bash
docker-compose exec app php artisan storage:link
```

## Truy cập ứng dụng

-   **Website**: http://localhost:8000
-   **PhpMyAdmin**: http://localhost:8080
    -   Server: `db`
    -   Username: `thanhbinh`
    -   Password: `secret`

## Các lệnh Docker hữu ích

### Xem containers đang chạy

```bash
docker-compose ps
```

### Xem logs

```bash
docker-compose logs -f
# Hoặc xem log của container cụ thể
docker-compose logs -f app
docker-compose logs -f nginx
docker-compose logs -f db
```

### Truy cập vào container

```bash
docker-compose exec app bash
```

### Chạy artisan commands

```bash
docker-compose exec app php artisan migrate
docker-compose exec app php artisan db:seed
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan route:list
```

### Chạy composer commands

```bash
docker-compose exec app composer install
docker-compose exec app composer update
docker-compose exec app composer require package-name
```

### Chạy npm commands

```bash
docker-compose exec app npm install
docker-compose exec app npm run dev
docker-compose exec app npm run build
```

### Dừng containers

```bash
docker-compose down
```

### Dừng và xóa volumes (xóa database)

```bash
docker-compose down -v
```

### Rebuild containers

```bash
docker-compose up -d --build
```

### Restart containers

```bash
docker-compose restart
```

## Troubleshooting

### Lỗi permission

```bash
docker-compose exec app chown -R www-data:www-data /var/www/storage
docker-compose exec app chmod -R 775 /var/www/storage
```

### Clear cache

```bash
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan view:clear
```

### Reset database

```bash
docker-compose exec app php artisan migrate:fresh --seed
```

### Xem MySQL logs

```bash
docker-compose logs -f db
```

### Truy cập MySQL trực tiếp

```bash
docker-compose exec db mysql -u thanhbinh -psecret thanhbinh
```

## Cấu trúc Docker

-   **app**: Container chứa PHP-FPM và Laravel application
-   **nginx**: Web server
-   **db**: MySQL database
-   **phpmyadmin**: Giao diện quản lý database

## Ports

-   `8000`: Nginx (Website)
-   `8080`: PhpMyAdmin
-   `3307`: MySQL (mapped từ 3306 trong container)

## Volumes

-   Database data được lưu trong Docker volume `dbdata`
-   Source code được mount từ host vào container để development

## Production Notes

Để deploy lên production:

1. Sửa `APP_ENV=production` trong `.env`
2. Sửa `APP_DEBUG=false`
3. Remove PhpMyAdmin service từ `docker-compose.yml`
4. Sử dụng secrets management thay vì hardcode passwords
5. Cấu hình SSL/HTTPS
6. Sử dụng managed database service thay vì container
