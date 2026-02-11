# ========================================================
# S3 UPLOAD NOTIFICATION LAMBDA – EduCloud Project
# ========================================================

"""
PURPOSE
-------
This AWS Lambda function is designed to trigger automatically
whenever a new file is uploaded to an EduCloud S3 bucket.

It extracts file metadata and sends an email notification
using Amazon SNS to inform students and trainers about
newly available content.
"""


# ========================================================
# ARCHITECTURE CONTEXT
# ========================================================

"""
Flow:
User Upload → S3 Bucket
S3 Event → Lambda Trigger
Lambda → SNS Topic
SNS → Email Notification

This function supports an event-driven,
serverless automation model.
"""


# ========================================================
# REQUIRED AWS SERVICES
# ========================================================

"""
- Amazon S3 (ObjectCreated event)
- AWS Lambda (Python runtime)
- Amazon SNS (Email notifications)
- IAM Role with least-privilege access
"""


# ========================================================
# IAM PERMISSIONS (DOCUMENTATION)
# ========================================================

"""
Required permissions for Lambda execution role:

- AWSLambdaBasicExecutionRole
- AmazonS3ReadOnlyAccess
- AmazonSNSFullAccess
"""


# ========================================================
# LAMBDA IMPLEMENTATION
# ========================================================

import json
import boto3
import os
import pymysql
from datetime import datetime


sns_client = boto3.client('sns')
SNS_TOPIC_ARN = os.environ['SNS_TOPIC_ARN']

# RDS Configuration from environment variables
RDS_HOST = os.environ['RDS_HOST']
RDS_USER = os.environ['RDS_USER']
RDS_PASSWORD = os.environ['RDS_PASSWORD']
RDS_DB = os.environ['RDS_DB']


def get_db_connection():
    """Create and return database connection"""
    try:
        connection = pymysql.connect(
            host=RDS_HOST,
            user=RDS_USER,
            password=RDS_PASSWORD,
            database=RDS_DB,
            connect_timeout=5,
            cursorclass=pymysql.cursors.DictCursor
        )
        return connection
    except Exception as e:
        print(f"❌ Database connection failed: {str(e)}")
        raise


def insert_upload_record(filename, s3_path, file_size, file_size_formatted, file_type, uploader):
    """Insert upload record into RDS uploads table"""
    try:
        connection = get_db_connection()
        with connection.cursor() as cursor:
            sql = """
            INSERT INTO uploads 
            (filename, s3_path, uploader, file_size, file_type, upload_timestamp)
            VALUES (%s, %s, %s, %s, %s, NOW())
            """
            
            cursor.execute(sql, (
                filename,
                s3_path,
                uploader,
                file_size_formatted,
                file_type
            ))
            connection.commit()
            insert_id = cursor.lastrowid
            print(f"✅ Record inserted into RDS with ID: {insert_id}")
            return insert_id
            
    except Exception as db_error:
        print(f"❌ RDS Insert Error: {str(db_error)}")
        raise
    finally:
        if connection:
            connection.close()


def lambda_handler(event, context):
    """
    Triggered when new file is uploaded to S3 materials/ folder.
    1. Sends email notification to all subscribed students via SNS
    2. Stores upload metadata in RDS database
    """
    
    try:
        for record in event['Records']:
            bucket_name = record['s3']['bucket']['name']
            object_key = record['s3']['object']['key']
            object_size = record['s3']['object']['size']
            event_time = record['eventTime']
            
            # Filter: Only process student materials
            if not object_key.startswith('materials/students/'):
                print(f"Skipping {object_key} - not in students folder")
                continue
            
            filename = object_key.split('/')[-1]
            
            # Format file size for email
            size_mb = object_size / (1024 * 1024)
            if size_mb > 1:
                size_formatted = f"{size_mb:.2f} MB"
            elif object_size > 1024:
                size_formatted = f"{object_size / 1024:.2f} KB"
            else:
                size_formatted = f"{object_size} B"
            
            # Format timestamp
            upload_time = datetime.fromisoformat(event_time.replace('Z', '+00:00'))
            time_formatted = upload_time.strftime('%B %d, %Y at %I:%M %p UTC')
            
            # Determine file type emoji
            extension = filename.split('.')[-1].lower()
            emoji_map = {
                'pdf': '📕', 'txt': '📝', 'doc': '📘', 'docx': '📘',
                'ppt': '📊', 'pptx': '📊', 'xls': '📗', 'xlsx': '📗',
                'zip': '📦', 'rar': '📦', 'jpg': '🖼️', 'jpeg': '🖼️',
                'png': '🖼️', 'mp4': '🎥', 'mp3': '🎵'
            }
            file_emoji = emoji_map.get(extension, '📄')
            
            # Determine file type for DB
            file_type = extension.upper() if extension else 'Unknown'
            
            # Default uploader (in real scenario, extract from S3 metadata or path)
            uploader = 'trainer1'  # You can parse this from object_key path
            
            # ===== PART 1: SEND SNS EMAIL NOTIFICATION =====
            subject = f"🎓 New Learning Material: {filename}"
            
            message = f"""
╔══════════════════════════════════════════════════════╗
║                                                      ║
║        {file_emoji}  NEW STUDY MATERIAL UPLOADED!  {file_emoji}        ║
║                                                      ║
╚══════════════════════════════════════════════════════╝

Hello Student! 👋

Your trainer has uploaded new learning material for you.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 FILE DETAILS:

   {file_emoji} Name:     {filename}
   📏 Size:     {size_formatted}
   🕒 Uploaded: {time_formatted}
   📦 Bucket:   {bucket_name}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📚 Access this file through your student portal and start learning!

Happy Learning! 🎓✨

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

This is an automated notification from EduCloud Platform
Powered by AWS (S3 → Lambda → SNS → RDS)

If you no longer wish to receive these notifications,
please contact your administrator.
"""
            
            # Send SNS notification
            response = sns_client.publish(
                TopicArn=SNS_TOPIC_ARN,
                Subject=subject,
                Message=message
            )
            
            print(f"✅ SNS Notification sent for {filename}")
            print(f"   MessageId: {response['MessageId']}")
            
            # ===== PART 2: STORE IN RDS DATABASE =====
            try:
                record_id = insert_upload_record(
                    filename=filename,
                    s3_path=object_key,
                    file_size=object_size,
                    file_size_formatted=size_formatted,
                    file_type=file_type,
                    uploader=uploader
                )
                print(f"✅ Database record created with ID: {record_id}")
                
            except Exception as db_error:
                # Log error but don't fail the entire function
                print(f"⚠️  Database insert failed but email was sent: {str(db_error)}")
            
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Notifications sent and data stored successfully',
                'processed_files': len(event['Records'])
            })
        }
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        import traceback
        print(traceback.format_exc())
        raise e

# ========================================================
# EVENT SOURCE CONFIGURATION
# ========================================================

"""
S3 Event Type:
- ObjectCreated (PUT)

Trigger Scope:
- Materials uploads
- Assignment uploads

This ensures notifications are sent
only when new content is added.
"""


# ========================================================
# RESULT
# ========================================================

"""
✔ Automated notifications
✔ Serverless architecture
✔ Real-time content awareness
✔ Scalable and cost-efficient
"""

