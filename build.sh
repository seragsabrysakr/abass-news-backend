#!/bin/bash

echo "🚀 Building Abass News Backend..."

# Install dependencies
echo "📦 Installing dependencies..."
dart pub get

# Compile the application
echo "🔨 Compiling application..."
dart compile exe bin/server.dart -o bin/server

# Make executable
chmod +x bin/server

echo "✅ Build complete!"
echo "🚀 Starting server..."

# Set default port if not provided
export PORT=${PORT:-8080}

echo "🌐 Server will start on port $PORT"

# Start the server
./bin/server 