#!/bin/bash

echo "🚀 Deploying Abass News Backend to Railway..."

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: pubspec.yaml not found. Make sure you're in the project root."
    exit 1
fi

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI not found. Please install it first:"
    echo "npm install -g @railway/cli"
    exit 1
fi

echo "📦 Building the application..."
dart pub get

echo "🔧 Setting environment variables..."
railway variables --set "DB_HOST=postgres.railway.internal" \
                 --set "DB_PORT=5432" \
                 --set "DB_NAME=railway" \
                 --set "DB_USER=postgres" \
                 --set "DB_PASSWORD=DBvdIgatcAwFYtecjvXrnXBCCatWQFKI" \
                 --set "JWT_SECRET=your-super-secret-key-change-this-in-production"

echo "🚀 Deploying to Railway..."
railway up

echo "✅ Deployment complete!"
echo "🌐 Your API should be available at: https://your-app-name.railway.app"
echo "📊 Check logs with: railway logs" 