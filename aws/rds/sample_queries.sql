-- ========================================================
-- EduCloud RDS Sample Queries
-- Database : educloud_db
-- Purpose  : Demonstration, Reporting, and Verification
-- ========================================================


-- =========================
-- 1. LIST ALL STUDENTS
-- =========================
SELECT id, name, email, student_group, created_at
FROM students
ORDER BY created_at DESC;


-- =========================
-- 2. LIST ALL TRAINERS
-- =========================
SELECT id, name, email, subject, created_at
FROM trainers
ORDER BY created_at DESC;


-- =========================
-- 3. VIEW ALL UPLOADED FILES
-- =========================
SELECT id, filename, uploader, upload_timestamp, file_size, file_type
FROM uploads
ORDER BY upload_timestamp DESC;


-- =========================
-- 4. VIEW STUDENT UPLOAD REPORT
-- (Using database VIEW)
-- =========================
SELECT student_name, email, filename, upload_timestamp
FROM student_uploads_view
ORDER BY upload_timestamp DESC;


-- =========================
-- 5. COUNT TOTAL STUDENTS
-- =========================
SELECT COUNT(*) AS total_students
FROM students;


-- =========================
-- 6. COUNT TOTAL TRAINERS
-- =========================
SELECT COUNT(*) AS total_trainers
FROM trainers;


-- =========================
-- 7. COUNT TOTAL UPLOADS
-- =========================
SELECT COUNT(*) AS total_uploads
FROM uploads;


-- =========================
-- 8. UPLOAD COUNT PER STUDENT
-- =========================
SELECT uploader, COUNT(*) AS upload_count
FROM uploads
WHERE uploader LIKE 'student%'
GROUP BY uploader
ORDER BY upload_count DESC;


-- =========================
-- 9. RECENT UPLOADS (LAST 7 DAYS)
-- =========================
SELECT filename, uploader, upload_timestamp
FROM uploads
WHERE upload_timestamp >= NOW() - INTERVAL 7 DAY
ORDER BY upload_timestamp DESC;


-- =========================
-- 10. FIND STUDENT BY EMAIL
-- =========================
SELECT id, name, email, student_group
FROM students
WHERE email = 'student1@educloud.com';


-- ========================================================
-- END OF SAMPLE QUERIES
-- ========================================================
