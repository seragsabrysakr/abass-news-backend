# Abass News - Python Flask Backend

A modern news application backend built with Python Flask, featuring user authentication, article management, and issue tracking.

## 🚀 Features

- **User Authentication**: Register, login, password reset, and account deletion
- **Article Management**: Create, read, update, and delete articles (admin only)
- **Issue Tracking**: Submit and track user issues
- **JWT Authentication**: Secure token-based authentication
- **PostgreSQL Database**: Robust data storage
- **CORS Support**: Cross-origin resource sharing enabled

## 🛠️ Tech Stack

- **Backend**: Python Flask
- **Database**: PostgreSQL
- **Authentication**: JWT tokens
- **Password Hashing**: bcrypt
- **Deployment**: Railway

## 📋 API Endpoints

### Authentication
- `POST /auth/register` - Register a new user
- `POST /auth/login` - Login user
- `POST /auth/forgot-password` - Send password reset token
- `POST /auth/reset-password` - Reset password using token
- `DELETE /auth/delete` - Delete user account (authenticated)

### Articles
- `GET /articles` - Get all published articles
- `GET /articles/<id>` - Get article by ID
- `POST /articles` - Create new article (admin only)
- `PUT /articles/<id>` - Update article (admin only)
- `DELETE /articles/<id>` - Delete article (admin only)

### Issues
- `GET /issues` - Get all issues (admin only)
- `GET /issues/user` - Get user issues (authenticated)
- `POST /issues` - Create new issue (authenticated)
- `PUT /issues/<id>/status` - Update issue status (admin only)

## 🚀 Quick Start

### Local Development

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Set environment variables:**
   ```bash
   export DB_HOST=localhost
   export DB_PORT=5432
   export DB_NAME=abass_news
   export DB_USER=postgres
   export DB_PASSWORD=password
   export JWT_SECRET=your-secret-key
   ```

3. **Run the application:**
   ```bash
   python app.py
   ```

4. **Test the API:**
   ```bash
   curl http://localhost:8080/
   ```

### Railway Deployment

1. **Push to GitHub**
2. **Connect to Railway**
3. **Set environment variables in Railway dashboard**
4. **Deploy automatically**

## 🔧 Environment Variables

- `DB_HOST` - PostgreSQL host
- `DB_PORT` - PostgreSQL port (default: 5432)
- `DB_NAME` - Database name
- `DB_USER` - Database username
- `DB_PASSWORD` - Database password
- `JWT_SECRET` - Secret key for JWT tokens
- `PORT` - Server port (default: 8080)

## 📱 Frontend

The Flutter frontend is located in the `abass_news_app/` directory.

## 🔒 Security

- Passwords are hashed using bcrypt
- JWT tokens for authentication
- Input validation on all endpoints
- SQL injection protection with parameterized queries

## 📊 Database Schema

The application automatically creates the following tables:
- `users` - User accounts and authentication
- `articles` - News articles and content
- `issues` - User-submitted issues
- `password_resets` - Password reset tokens

## 🧪 Testing

Test the API endpoints using curl or Postman:

```bash
# Health check
curl http://localhost:8080/

# Register user
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","username":"testuser","password":"password123"}'

# Login
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

## 📄 License

This project is licensed under the MIT License.