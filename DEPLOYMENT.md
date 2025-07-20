# 🚀 Deployment Guide - Abass News Backend

This guide will help you deploy your PostgreSQL-based news app backend to various platforms.

## 📋 Prerequisites

1. **PostgreSQL Database** - You'll need a PostgreSQL database
2. **Environment Variables** - Configure database connection
3. **Dart SDK** - For local development

## 🗄️ Database Setup

### Option 1: Local PostgreSQL
```bash
# Install PostgreSQL
brew install postgresql  # macOS
sudo apt-get install postgresql  # Ubuntu

# Start PostgreSQL
brew services start postgresql  # macOS
sudo systemctl start postgresql  # Ubuntu

# Create database
createdb abass_news
```

### Option 2: Cloud PostgreSQL (Recommended)

#### **Railway (Free Tier)**
1. Go to [railway.app](https://railway.app)
2. Create new project
3. Add PostgreSQL service
4. Copy connection details

#### **Supabase (Free Tier)**
1. Go to [supabase.com](https://supabase.com)
2. Create new project
3. Get connection string from Settings > Database

#### **Neon (Free Tier)**
1. Go to [neon.tech](https://neon.tech)
2. Create new project
3. Copy connection string

## 🔧 Environment Variables

Create a `.env` file in your project root:

```env
# Database Configuration
DB_HOST=your-db-host
DB_PORT=5432
DB_NAME=abass_news
DB_USER=your-username
DB_PASSWORD=your-password

# JWT Secret (Change this!)
JWT_SECRET=your-super-secret-key-change-this

# Server Configuration
PORT=8080
```

## 🚀 Deployment Options

### 1. Railway (Recommended - Easy & Free)

Railway is perfect for Dart Frog apps and offers a generous free tier.

#### Setup:
1. **Install Railway CLI:**
```bash
npm install -g @railway/cli
```

2. **Login to Railway:**
```bash
railway login
```

3. **Initialize project:**
```bash
railway init
```

4. **Add environment variables:**
```bash
railway variables set DB_HOST=your-db-host
railway variables set DB_PORT=5432
railway variables set DB_NAME=abass_news
railway variables set DB_USER=your-username
railway variables set DB_PASSWORD=your-password
railway variables set JWT_SECRET=your-secret-key
```

5. **Deploy:**
```bash
railway up
```

### 2. Heroku

#### Setup:
1. **Install Heroku CLI:**
```bash
brew install heroku/brew/heroku  # macOS
```

2. **Login:**
```bash
heroku login
```

3. **Create app:**
```bash
heroku create your-app-name
```

4. **Add PostgreSQL:**
```bash
heroku addons:create heroku-postgresql:mini
```

5. **Set environment variables:**
```bash
heroku config:set DB_HOST=$(heroku config:get DATABASE_URL | cut -d'@' -f2 | cut -d'/' -f1)
heroku config:set DB_NAME=your-db-name
heroku config:set DB_USER=your-username
heroku config:set DB_PASSWORD=your-password
heroku config:set JWT_SECRET=your-secret-key
```

6. **Deploy:**
```bash
git push heroku main
```

### 3. DigitalOcean App Platform

1. Go to [DigitalOcean App Platform](https://cloud.digitalocean.com/apps)
2. Connect your GitHub repository
3. Configure environment variables
4. Deploy

### 4. Google Cloud Run

1. **Install gcloud CLI**
2. **Build and deploy:**
```bash
gcloud run deploy abass-news \
  --source . \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

## 🐳 Docker Deployment

### Build Docker Image:
```bash
docker build -t abass-news .
```

### Run with Docker Compose:
Create `docker-compose.yml`:

```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - DB_HOST=postgres
      - DB_PORT=5432
      - DB_NAME=abass_news
      - DB_USER=postgres
      - DB_PASSWORD=password
      - JWT_SECRET=your-secret-key
    depends_on:
      - postgres

  postgres:
    image: postgres:15
    environment:
      - POSTGRES_DB=abass_news
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  postgres_data:
```

### Run:
```bash
docker-compose up -d
```

## 🔒 Security Checklist

- [ ] Change JWT secret key
- [ ] Use strong database passwords
- [ ] Enable HTTPS in production
- [ ] Set up proper CORS headers
- [ ] Implement rate limiting
- [ ] Add request logging
- [ ] Set up monitoring

## 📊 Monitoring

### Health Check Endpoint
Your app includes a health check at `/` that returns API information.

### Logs
```bash
# Railway
railway logs

# Heroku
heroku logs --tail

# Docker
docker-compose logs -f
```

## 🧪 Testing Your Deployment

### Test API Endpoints:
```bash
# Health check
curl https://your-app-url.railway.app/

# Register user
curl -X POST https://your-app-url.railway.app/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "username": "testuser",
    "password": "password123"
  }'

# Login
curl -X POST https://your-app-url.railway.app/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

## 🚨 Troubleshooting

### Common Issues:

1. **Database Connection Failed**
   - Check environment variables
   - Verify database is running
   - Check firewall settings

2. **Port Already in Use**
   - Change PORT environment variable
   - Kill existing process

3. **Build Failures**
   - Check Dart SDK version
   - Run `dart pub get` locally first

### Debug Commands:
```bash
# Check database connection
dart run bin/server.dart

# View logs
railway logs

# Check environment variables
railway variables
```

## 📈 Scaling

### For High Traffic:
1. **Database**: Upgrade to larger PostgreSQL instance
2. **Caching**: Add Redis for session storage
3. **CDN**: Use Cloudflare for static assets
4. **Load Balancing**: Multiple app instances

### Performance Tips:
- Use database connection pooling
- Implement caching strategies
- Optimize database queries
- Use CDN for images

## 🎯 Next Steps

1. **Set up CI/CD** with GitHub Actions
2. **Add monitoring** with Sentry or similar
3. **Implement backups** for database
4. **Set up staging environment**
5. **Add API documentation** with Swagger

Your news app backend is now ready for production! 🎉 