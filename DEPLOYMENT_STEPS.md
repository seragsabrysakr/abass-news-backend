# 🚀 Step-by-Step Deployment Guide

## Prerequisites Setup

### 1. Install Required Tools

**Option A: Install Node.js for Railway**
```bash
# Install Homebrew if you don't have it
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Node.js
brew install node

# Install Railway CLI
npm install -g @railway/cli
```

**Option B: Install Docker**
```bash
# Install Docker Desktop for Mac
# Download from: https://www.docker.com/products/docker-desktop/
# Or install via Homebrew:
brew install --cask docker
```

## 🗄️ Database Setup

### Choose a Database Provider:

**Option 1: Railway PostgreSQL (Free)**
1. Go to [railway.app](https://railway.app)
2. Create account and new project
3. Add PostgreSQL service
4. Copy connection details

**Option 2: Supabase (Free)**
1. Go to [supabase.com](https://supabase.com)
2. Create new project
3. Get connection string from Settings > Database

**Option 3: Neon (Free)**
1. Go to [neon.tech](https://neon.tech)
2. Create new project
3. Copy connection string

## 🚀 Deployment Methods

### Method 1: Railway Deployment (Recommended)

1. **Login to Railway:**
```bash
railway login
```

2. **Initialize project:**
```bash
railway init
```

3. **Set environment variables:**
```bash
railway variables set DB_HOST=your-db-host
railway variables set DB_PORT=5432
railway variables set DB_NAME=abass_news
railway variables set DB_USER=your-username
railway variables set DB_PASSWORD=your-password
railway variables set JWT_SECRET=your-super-secret-key-change-this
```

4. **Deploy:**
```bash
railway up
```

5. **Get your URL:**
```bash
railway domain
```

### Method 2: Docker Deployment

1. **Build the Docker image:**
```bash
docker build -t abass-news .
```

2. **Run with Docker Compose:**
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

3. **Run:**
```bash
docker-compose up -d
```

### Method 3: Heroku Deployment

1. **Install Heroku CLI:**
```bash
brew install heroku/brew/heroku
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

## 📊 Monitoring

### View Logs:
```bash
# Railway
railway logs

# Heroku
heroku logs --tail

# Docker
docker-compose logs -f
```

## 🔒 Security Checklist

- [ ] Change JWT secret key
- [ ] Use strong database passwords
- [ ] Enable HTTPS in production
- [ ] Set up proper CORS headers
- [ ] Implement rate limiting
- [ ] Add request logging
- [ ] Set up monitoring

## 🆘 Troubleshooting

### Common Issues:

1. **Database Connection Failed**
   - Check environment variables
   - Verify database is running
   - Test connection string

2. **Port Already in Use**
   - Change PORT environment variable
   - Kill existing process on port

3. **Build Failed**
   - Check Dart SDK version
   - Verify all dependencies in pubspec.yaml
   - Check for syntax errors

### Get Help:
- Railway: [docs.railway.app](https://docs.railway.app)
- Heroku: [devcenter.heroku.com](https://devcenter.heroku.com)
- Dart Frog: [dartfrog.vgv.dev](https://dartfrog.vgv.dev) 