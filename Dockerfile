# Stage 1: Build Vue Frontend
FROM node:18-alpine AS frontend-builder
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm ci
COPY frontend/ ./
RUN npm run build

# Stage 2: PHP/Laravel Backend + Nginx
FROM php:8.2-fpm-alpine

# Install dependencies
RUN apk add --no-cache \
    nginx \
    supervisor \
    curl \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    zip \
    unzip \
    git \
    oniguruma-dev \
    libxml2-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd xml

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy backend
COPY backend/ ./backend/

# Install Laravel dependencies
WORKDIR /var/www/html/backend
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Set permissions
RUN chown -R www-data:www-data /var/www/html/backend/storage /var/www/html/backend/bootstrap/cache
RUN chmod -R 775 /var/www/html/backend/storage /var/www/html/backend/bootstrap/cache

# Copy frontend build
WORKDIR /var/www/html
COPY --from=frontend-builder /app/frontend/dist ./frontend/dist

# Copy other root files
COPY index.php ./
COPY .htaccess ./  2>/dev/null || true

# Nginx config
RUN mkdir -p /run/nginx
COPY nginx.conf /etc/nginx/http.d/default.conf

# Supervisor config
COPY supervisord.conf /etc/supervisord.conf

# Expose port
EXPOSE 80

# Start supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
