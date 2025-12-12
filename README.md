# Thanh Bình Mobile

Website bán điện thoại di động và phụ kiện

## 🚀 Hướng dẫn truy cập

### 🌐 Website chính

**URL:** http://localhost:8000

### � Đăng nhập User (Khách hàng)

**URL:** http://localhost:8000/login

-   **Username/Email:** `thanhbinh` hoặc `thanhbinh@gmail.com`
-   **Password:** `123456`

### �👨‍💼 Trang Admin

**URL:** http://localhost:8000/admin/login

-   **Username:** `thanhbinh`
-   **Password:** `123456`

### 🗄️ PhpMyAdmin (Quản lý Database)

**URL:** http://localhost:8081

-   **Server:** `db`
-   **Username:** `thanhbinh`
-   **Password:** `123456`

## 🐳 Docker Commands

```bash
# Khởi động containers
docker-compose up -d

# Dừng containers
docker-compose down

# Xem logs
docker-compose logs -f

# Restart containers
docker-compose restart

# Chạy artisan commands
docker-compose exec app php artisan [command]
```

## 📝 Thông tin dự án

-   **Framework:** Laravel 12.x
-   **PHP:** 8.2
-   **Database:** MySQL 8.0
-   **Web Server:** Nginx
-   **Frontend:** Tailwind CSS, Vite
