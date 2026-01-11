# Deploying SISMAKUM to Coolify

This guide explains how to deploy the SISMAKUM application to your VPS using **Coolify**. Since we have successfully containerized the application with `docker-compose.yml`, we will use the **Docker Compose** deployment method.

## Prerequisites
1.  A VPS with [Coolify](https://coolify.io) installed and running.
2.  The GitHub repository is public or you have connected your GitHub account to Coolify.

## Step-by-Step Deployment

### 1. Create a New Project
1.  Open your Coolify Dashboard.
2.  Click **"+ New"**.
3.  Select **"Project"**.
4.  Choose an environment (e.g., "Production").

### 2. Add Resource
1.  Click **"+ New"** inside your environment.
2.  Select **"Git Repository"** (Public or Private).
3.  Select your repository: `armadanpagala88-code/sismakum_docker`.
4.  Branch: `main`.

### 3. Configuration
Coolify will detect the repository. Select **"Docker Compose"** as the **Build Pack**.

#### Docker Compose Configuration
Coolify will load the `docker-compose.yml` file content.
- Ensure the services (`app`, `db`, `phpmyadmin`) are visible.

#### Environment Variables
You need to set the environment variables in the **Environment Variables** tab for the `app` service (or globally if Coolify asks).

Copy these values (adjust for production):

```env
APP_ENV=production
APP_DEBUG=false
APP_URL=https://your-domain.com

DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=sismakum
DB_USERNAME=sismakum
DB_PASSWORD=your_secure_password

# Using the internal db service password
DB_ROOT_PASSWORD=your_secure_root_password
```

**Important**: Make sure `DB_PASSWORD` matches `MYSQL_PASSWORD` and `DB_ROOT_PASSWORD` matches `MYSQL_ROOT_PASSWORD` in your config.

### 4. Domains & Networking
1.  **App Service**:
    - Set the **Domain** (e.g., `https://sismakum.your-vps.com`).
    - Container Port: `80` (This maps to the nginx inside the container).
    - **Note**: The external port mapping in `docker-compose.yml` has been updated to `8100` to avoid conflicts.
2.  **phpMyAdmin Service**:
    - Set the **Domain** (e.g., `https://db.sismakum.your-vps.com`).
    - Container Port: `80`.
    - **Note**: The external port mapping in `docker-compose.yml` has been updated to `8180`.

### 5. Deployment
1.  Click **"Deploy"**.
2.  Watch the "Deployment Logs" to ensure the image builds and services start.

## Post-Deployment
- If you face database connection errors, check that the `DB_HOST=db` matches the service name in Coolify (sometimes Coolify prefixes names). In a single Docker Compose stack, `db` is usually correct.
- **Run Migrations**: 
    - You may need to run migrations manually if the auto-migration script fails or times out.
    - Open the **Terminal** for the `app` container in Coolify.
    - Run: `php artisan migrate --force`

## Troubleshooting

### Port Conflict Error (Bind for 0.0.0.0:8000 failed)
If you see an error like `Bind for 0.0.0.0:8000 failed: port is already allocated`, it means port 8000 is occupied on your VPS.

**Solution**:
1.  Go to the **Environment Variables** tab in Coolify.
2.  Add a new variable: `APP_PORT=8001` (or any other free port).
3.  Redeploy.

Alternatively, if you are using Coolify's Domains features to access the site, you can likely remove the `ports:` section from `docker-compose.yml` entirely, as Coolify communicates via the internal Docker network.

### Networking Error (iptables: No chain/target/match by that name)
If you see an error like `Unable to enable DNAT rule... iptables: No chain/target/match by that name`, it means the Docker networking configuration on your VPS is corrupted (often happens if `ufw` or `firewalld` was reloaded).

**Solution 1 (Recommended if you have SSH access)**:
1.  SSH into your VPS.
2.  Restart the Docker service: `sudo systemctl restart docker`.
3.  Redeploy in Coolify.

**Solution 2 (If you strictly use Domains in Coolify)**:
1.  Remove the `ports:` sections from `docker-compose.yml`.
2.  Commit and push the changes.
3.  Redeploy. (This disables direct IP access and relies solely on Coolify's domain routing).


