# Abass News Backend

A comprehensive backend API for a news application built with Dart Frog and Isar database.

## Features

- **User Management**: Registration, login, and role-based access control
- **Articles CRUD**: Full CRUD operations for news articles (Admin only)
- **Issue Management**: Users can upload issues, admins can manage them
- **Authentication**: JWT-based authentication with role-based authorization
- **Database**: Isar database for fast local storage

## User Roles

### User
- Read published articles
- Upload issues
- View their own issues

### Admin
- All user permissions
- Create, update, delete articles
- Manage all issues
- Approve/reject user issues

## API Endpoints

### Authentication
- `POST /auth/register` - Register a new user
- `POST /auth/login` - Login user

### Articles
- `GET /articles` - Get all published articles
- `GET /articles/{id}` - Get article by ID
- `POST /articles` - Create new article (Admin only)
- `PUT /articles/{id}` - Update article (Admin only)
- `DELETE /articles/{id}` - Delete article (Admin only)

### Issues
- `GET /issues` - Get all issues (Admin only)
- `GET /issues/user` - Get user issues (Authenticated)
- `POST /issues` - Create new issue (Authenticated)
- `PUT /issues/{id}/status` - Update issue status (Admin only)

## Setup

1. Install dependencies:
```bash
dart pub get
```

2. Generate code (after installing dependencies):
```bash
dart run build_runner build
```

3. Run the development server:
```bash
dart_frog dev
```

The server will start at `http://localhost:8080`

## API Usage Examples

### Register a User
```bash
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "username": "user123",
    "password": "password123"
  }'
```

### Login
```bash
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

### Create Article (Admin)
```bash
curl -X POST http://localhost:8080/articles \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "title": "Breaking News",
    "content": "This is the article content...",
    "summary": "Brief summary",
    "isPublished": true
  }'
```

### Upload Issue (User)
```bash
curl -X POST http://localhost:8080/issues \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "title": "Bug Report",
    "description": "Found a bug in the app...",
    "imageUrl": "https://example.com/image.jpg"
  }'
```

## Database Models

### User
- `id`: Unique identifier
- `email`: User email
- `username`: Display name
- `passwordHash`: Hashed password
- `role`: User role (user/admin)
- `createdAt`: Account creation date
- `updatedAt`: Last update date

### Article
- `id`: Unique identifier
- `title`: Article title
- `content`: Article content
- `authorId`: Author user ID
- `summary`: Article summary
- `imageUrl`: Featured image URL
- `tags`: Article tags
- `isPublished`: Publication status
- `createdAt`: Creation date
- `updatedAt`: Last update date
- `publishedAt`: Publication date

### Issue
- `id`: Unique identifier
- `title`: Issue title
- `description`: Issue description
- `userId`: Reporter user ID
- `imageUrl`: Issue image URL
- `attachments`: Additional files
- `status`: Issue status (pending/approved/rejected)
- `adminNotes`: Admin comments
- `createdAt`: Creation date
- `updatedAt`: Last update date
- `resolvedAt`: Resolution date

## Security

- Passwords are hashed using SHA-256
- JWT tokens for authentication
- Role-based access control
- Input validation on all endpoints

## Development

To create an admin user, you can modify the registration endpoint or directly create a user with admin role in the database.

For production deployment:
1. Change the JWT secret key in `lib/services/auth_service.dart`
2. Configure proper environment variables
3. Set up proper logging and monitoring
4. Implement rate limiting and additional security measures