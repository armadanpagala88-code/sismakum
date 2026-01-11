# Docker Implementation Walkthrough

The SISMAKUM application has been successfully configured to run with Docker.

## Changes Created

- **Configured `docker-compose.yml`**:
  - Added `db` service (MySQL 8.0).
  - Added `phpmyadmin` service.
  - Configured `app` service to connect to the database.
  - Defined volume persistence for database (`db_data`) and storage (`storage_data`).

## How to Run

1. **Start the application**:
   ```bash
   docker-compose up -d --build
   ```

2. **Access the Application**:
   - **Frontend/Backend**: [http://localhost:8000](http://localhost:8000)
   - **phpMyAdmin**: [http://localhost:8080](http://localhost:8080)

## Service Details

| Service | Internal Port | External Port | Credentials (Default) |
|Ref | --- | --- | --- |
| **App** | 80 | 8000 | - |
| **Database** | 3306 | - | User: `sismakum`, Pass: `sismakum` |
| **phpMyAdmin** | 80 | 8080 | Server: `db`, User: `sismakum`, Pass: `sismakum` |

> [!NOTE]
> - The application takes a few seconds to become healthy after starting. 
> - If `phpmyadmin` warns about platform mismatch (on Apple Silicon), it generally works fine via emulation.
