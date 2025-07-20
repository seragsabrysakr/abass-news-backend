# 📮 Postman Collection Guide - Abass News API

This guide will help you import and use the Postman collection for testing the Abass News API.

## 📁 Files Included

1. **`Abass_News_API.postman_collection.json`** - Main API collection
2. **`Abass_News_Environment.postman_environment.json`** - Environment variables
3. **`POSTMAN_GUIDE.md`** - This guide

## 🚀 How to Import

### Step 1: Import Collection
1. Open Postman
2. Click **Import** button
3. Select **`Abass_News_API.postman_collection.json`**
4. Click **Import**

### Step 2: Import Environment
1. Click **Import** button again
2. Select **`Abass_News_Environment.postman_environment.json`**
3. Click **Import**

### Step 3: Set Environment
1. In the top-right corner, select **"Abass News Local"** environment
2. Make sure your server is running on `http://localhost:8080`

## 🔧 Environment Variables

| Variable | Description | Default Value |
|----------|-------------|---------------|
| `baseUrl` | API server URL | `http://localhost:8080` |
| `authToken` | JWT token (auto-set after login) | Empty |

## 📋 Available Endpoints

### 🏥 Health Check
- **GET** `/` - Check if server is running

### 🔐 Authentication
- **POST** `/auth/register` - Register new user
- **POST** `/auth/login` - Login user (auto-saves token)
- **POST** `/auth/forgot_password` - Request password reset
- **POST** `/auth/reset_password` - Reset password with token
- **DELETE** `/auth/delete` - Delete user account

### 📰 Articles
- **GET** `/articles` - Get all published articles
- **GET** `/articles/{id}` - Get specific article
- **POST** `/articles` - Create article (Admin only)
- **PUT** `/articles/{id}` - Update article (Admin only)
- **DELETE** `/articles/{id}` - Delete article (Admin only)

### 🐛 Issues
- **GET** `/issues` - Get all issues (Admin only)
- **GET** `/issues/user` - Get current user's issues
- **POST** `/issues` - Create new issue
- **PUT** `/issues/{id}/status` - Update issue status (Admin only)

## 🔑 Authentication Flow

### For Regular Users:
1. **Register**: Use "Register User" endpoint
2. **Login**: Use "Login User" (token auto-saved)
3. **Use Protected Endpoints**: Token automatically included

### For Admin Users:
1. **Register with Admin Role**: Use "Register Admin User" endpoint with `"role": "admin"`
2. **Login**: Use "Login User" (admin token auto-saved)
3. **Access Admin Endpoints**: Token automatically included

## 📝 Sample Data

### Register User
```json
{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "password123",
  "role": "user"
}
```

### Register Admin User
```json
{
  "username": "admin_user",
  "email": "admin@example.com",
  "password": "admin123",
  "role": "admin"
}
```

### Create Article (Admin)
```json
{
  "title": "Breaking News: Important Update",
  "content": "Full article content here...",
  "summary": "Brief summary",
  "imageUrl": "https://example.com/image.jpg",
  "tags": ["news", "breaking"],
  "isPublished": true
}
```

### Create Issue
```json
{
  "title": "Bug Report: App Crashes",
  "description": "Detailed description of the issue...",
  "imageUrl": "https://example.com/screenshot.png",
  "attachments": ["https://example.com/log.txt"]
}
```

## 🎯 Testing Workflow

### Basic Testing:
1. ✅ Health check
2. ✅ Register user
3. ✅ Login user
4. ✅ Get articles
5. ✅ Create issue

### Admin Testing:
1. ✅ Register admin user
2. ✅ Login as admin
3. ✅ Create article
4. ✅ Get all issues
5. ✅ Update issue status

## 🔍 Response Formats

### Success Response
```json
{
  "status": true,
  "message": "Success message",
  "data": { /* response data */ },
  "statusCode": 200
}
```

### Error Response
```json
{
  "status": false,
  "message": "Error message",
  "data": null,
  "statusCode": 400
}
```

## 🐞 Troubleshooting

### Common Issues:

1. **Connection Error**
   - ✅ Ensure server is running: `dart_frog dev`
   - ✅ Check baseUrl in environment

2. **401 Unauthorized**
   - ✅ Login first to get token
   - ✅ Check if token is saved in environment

3. **403 Forbidden**
   - ✅ Endpoint requires admin role
   - ✅ Update user role in database

4. **404 Not Found**
   - ✅ Check endpoint URL
   - ✅ Verify route exists

### Server Commands:
```bash
# Start server
dart_frog dev

# Check if running
curl http://localhost:8080/

# View database
psql -d abass_news -c "\dt"
```

## 📊 Database Admin

To make a user admin, connect to PostgreSQL:

```sql
-- Connect to database
psql -d abass_news

-- Update user role
UPDATE users SET role = 'admin' WHERE email = 'your-email@example.com';

-- Verify change
SELECT id, email, username, role FROM users;
```

Happy testing! 🚀 