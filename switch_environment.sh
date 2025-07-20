#!/bin/bash

# Script to switch Flutter app environment between development and production

ENV_FILE="abass_news_app/lib/core/constants/environment_config.dart"

if [ "$1" = "dev" ] || [ "$1" = "development" ]; then
    echo "🔄 Switching to DEVELOPMENT environment..."
    sed -i '' 's/currentEnvironment = production/currentEnvironment = development/' "$ENV_FILE"
    echo "✅ Switched to DEVELOPMENT (localhost:8080)"
    echo "📱 Run: cd abass_news_app && flutter run"
    
elif [ "$1" = "prod" ] || [ "$1" = "production" ]; then
    echo "🔄 Switching to PRODUCTION environment..."
    sed -i '' 's/currentEnvironment = development/currentEnvironment = production/' "$ENV_FILE"
    echo "✅ Switched to PRODUCTION (Railway deployed backend)"
    echo "⚠️  Make sure to update the Railway URL in environment_config.dart"
    echo "📱 Run: cd abass_news_app && flutter run"
    
else
    echo "❌ Usage: $0 [dev|prod]"
    echo "   dev  - Switch to development (localhost)"
    echo "   prod - Switch to production (Railway)"
    exit 1
fi 