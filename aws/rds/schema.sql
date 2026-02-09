-- ========================================================
-- EduCloud RDS Database Schema
-- Database Engine : Amazon RDS (MySQL 8.x)
-- Database Name   : educloud_db
-- Purpose         : Trainer–Student Content Platform
-- ========================================================


-- =========================
-- TABLE: students
-- =========================
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    student_group VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_student_email (email)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_0900_ai_ci;


-- =========================
-- TABLE: trainers
-- =========================
CREATE TABLE IF NOT EXISTS trainers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    subject VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_trainer_email (email)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_0900_ai_ci;


-- =========================
-- TABLE: uploads
-- =========================
CREATE TABLE IF NOT EXISTS uploads (
    id INT AUTO_INCREMENT PRIMARY KEY,
    filename VARCHAR(255) NOT NULL,
    uploader VARCHAR(100) NOT NULL,
    upload_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    file_size VARCHAR(20),
    file_type VARCHAR(50),
    INDEX idx_uploader (uploader)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_0900_ai_ci;


-- =========================
-- VIEW: student_uploads_view
-- =========================
-- Purpose:
-- Shows uploaded files mapped to student accounts
-- Used for reporting and audit purposes

CREATE OR REPLACE VIEW student_uploads_view AS
SELECT
    s.name AS student_name,
    s.email AS email,
    u.filename AS filename,
    u.upload_timestamp AS upload_timestamp
FROM students s
LEFT JOIN uploads u
    ON u.uploader = CONCAT('student', s.id)
WHERE u.uploader LIKE 'student%';


-- ========================================================
-- END OF SCHEMA
-- ========================================================
