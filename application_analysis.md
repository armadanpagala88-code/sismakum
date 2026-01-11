# SISMAKUM Application Analysis

## Overview
SISMAKUM (Sistem Pengusulan PERBUB) is a web-based application for managing the proposal and review process of Regent Regulations (Peraturan Bupati). It features a public-facing portal for news and information, and a secure dashboard for proposal submission and verification.

## Architecture

### Stack
- **Backend API**: Laravel 10 (PHP 8.1+)
  - **Auth**: Laravel Sanctum
  - **Database**: MySQL 8.0
- **Frontend**: Vue 3 (Vite)
  - **Styling**: Tailwind CSS, Headless UI
  - **State**: Pinia
  - **Router**: Vue Router

### Core Logic
The application is structured around the **Pengusulan Perbub** (Regulation Proposal) workflow.

#### User Roles & Permissions
- **Admin**: Manages master data (Dinas, Users), content (News, Banners), and system configuration.
- **Verifikator**: Likely reviews proposals (implied by `add_verifikator_to_users_role` migration).
- **Users**: Submit proposals.

## Key Features

### 1. Proposal Management (`PengusulanPerbub`)
- **Submission**: Users can submit new regulation proposals.
- **Workflow**:
  - `ajukan` (Submit)
  - `review` (Review)
  - `update-revisi` (Submit Revision)
  - `update-status` (Change Status)
- **Tracking**:
  - `status-history`: Audit trail of status changes.
  - `catatan_revisi`: Feedback and review files.

### 2. Content Management System (CMS)
- **News (`Berita`)**: Headlines, rich text content, slugs.
- **Media**: Slideshows (`Slideshow`) and Banners (`Banner`).
- **Information**: `Infokami` (About Us), `KategoriDokumen`.
- **Website Configuration**: Site identity and official photos (Bupati, Wakil, Sekda).

### 3. Master Data Management
- **Dinas**: Management of Agencies/Departments.
- **Users**: User administration with roles, NIP, and Jabatan.

### 4. Document Security
- Files are stored privately and served via a protected route (`/api/dokumen/{path}`).
- Access control checks usually implemented in the controller (not fully visible here but implied by Sanctum middleware on download route).

## Database Schema Highlights
- **`pengusulan_perbub`**: Central table. Contains status enum and foreign keys to `users`.
- **`catatan_revisi`**: Linked to proposals for revision tracking.
- **`users`**: Extended with `dinas_id`, `role`, `is_active`, `nip`, `jabatan`.

## API Structure
- **Public Routes**: Read-only access to News, Slideshows, Banners, and Website info.
- **Protected Routes (`auth:sanctum`)**:
  - Proposal CRUD and workflow actions.
  - User profile (`/me`).
- **Admin Routes (`middleware: admin`)**:
  - Full CRUD for master data and CMS content.
