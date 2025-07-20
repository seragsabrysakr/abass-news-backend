# 📱 Flutter App Deployment Guide

## 🔗 Connecting Flutter App to Deployed Backend

### Step 1: Deploy Your Backend

First, deploy your backend to Railway:

1. **Go to Railway Dashboard:**
   - Visit: https://railway.app/project/2efc5441-1a8e-4f86-9208-f07de98bdc94

2. **Add a new service for your API:**
   - Click "New Service" → "GitHub Repo"
   - Connect your GitHub repository
   - Or use "Deploy from GitHub" option

3. **Set environment variables in Railway dashboard:**
   ```
   DB_HOST=postgres.railway.internal
   DB_PORT=5432
   DB_NAME=railway
   DB_USER=postgres
   DB_PASSWORD=DBvdIgatcAwFYtecjvXrnXBCCatWQFKI
   JWT_SECRET=your-super-secret-key-change-this-in-production
   ```

4. **Get your Railway URL:**
   - After deployment, copy the URL (e.g., `https://your-app-name.railway.app`)

### Step 2: Update Flutter App Configuration

1. **Update the production URL:**
   - Open: `abass_news_app/lib/core/constants/environment_config.dart`
   - Replace `'https://your-railway-app-name.railway.app'` with your actual Railway URL

2. **Switch to production environment:**
   ```dart
   // Change this line in environment_config.dart
   static const String currentEnvironment = production; // Change from development to production
   ```

### Step 3: Test the Connection

1. **Test your deployed API:**
   ```bash
   # Test health endpoint
   curl https://your-railway-app-name.railway.app/
   
   # Test registration
   curl -X POST https://your-railway-app-name.railway.app/auth/register \
     -H "Content-Type: application/json" \
     -d '{
       "email": "test@example.com",
       "username": "testuser",
       "password": "password123"
     }'
   ```

2. **Run your Flutter app:**
   ```bash
   cd abass_news_app
   flutter run
   ```

### Step 4: Build for Production

1. **Build Android APK:**
   ```bash
   cd abass_news_app
   flutter build apk --release
   ```

2. **Build iOS (requires macOS and Xcode):**
   ```bash
   flutter build ios --release
   ```

3. **Build Web:**
   ```bash
   flutter build web --release
   ```

## 🔧 Environment Management

### Development (Local Backend)
```dart
// In environment_config.dart
static const String currentEnvironment = development;
```

### Production (Deployed Backend)
```dart
// In environment_config.dart
static const String currentEnvironment = production;
```

## 🧪 Testing Checklist

- [ ] Backend deployed and accessible
- [ ] Flutter app connects to deployed backend
- [ ] Authentication works (login/register)
- [ ] Articles API works
- [ ] Issues API works
- [ ] Error handling works properly

## 🚀 Quick Commands

```bash
# Switch to production
# Edit: abass_news_app/lib/core/constants/environment_config.dart
# Change: currentEnvironment = production

# Run Flutter app
cd abass_news_app
flutter run

# Build for release
flutter build apk --release
```

## 🔍 Troubleshooting

### Common Issues:

1. **Connection Timeout**
   - Check if Railway URL is correct
   - Verify backend is running
   - Check network connectivity

2. **CORS Issues (Web)**
   - Add CORS headers to your backend
   - Update Railway environment variables

3. **Authentication Fails**
   - Check JWT secret is set correctly
   - Verify token storage in Flutter app

4. **API Endpoints Not Found**
   - Verify API routes are correct
   - Check Railway deployment logs

## 📊 Monitoring

- **Railway Logs:** Check Railway dashboard for backend logs
- **Flutter Debug:** Use `flutter logs` for app logs
- **Network Inspector:** Use browser dev tools for web debugging 