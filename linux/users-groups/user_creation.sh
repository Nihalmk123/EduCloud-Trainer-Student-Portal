#!/bin/bash
# EduCloud User Creation Script
# Creates Linux users and groups as per project requirements

echo "Starting EduCloud user setup..."

# 1. CREATE GROUPS
echo "Creating groups..."
sudo groupadd -r trainers
sudo groupadd -r students  
sudo groupadd -r support

echo "Groups created: trainers, students, support"

# 2. CREATE TRAINER USERS
echo "Creating trainer users..."
sudo useradd -m -G trainers -s /bin/bash -c "Trainer 1" trainer1
sudo useradd -m -G trainers -s /bin/bash -c "Trainer 2" trainer2

# 3. CREATE STUDENT USERS
echo "Creating student users..."
sudo useradd -m -G students -s /bin/bash -c "Student 1" student1
sudo useradd -m -G students -s /bin/bash -c "Student 2" student2
sudo useradd -m -G students -s /bin/bash -c "Student 3" student3

# 4. CREATE SUPPORT USER
echo "Creating support user..."
sudo useradd -m -G support -s /bin/bash -c "Support Staff" support1

# 5. DISPLAY RESULTS
echo ""
echo "USER CREATION COMPLETE!"
echo ""
echo "Groups:"
getent group trainers
getent group students  
getent group support
echo ""
echo "Trainer users:"
id trainer1
id trainer2
echo ""
echo "Student users:"
id student1
id student2
id student3
echo ""
echo "Support user:"
id support1
echo ""
echo "NEXT STEPS:"
echo "1. Set passwords: sudo passwd trainer1, etc."
echo "2. Apply password policy (see password_policy.txt)"
echo "3. Create directories and set ACLs"
