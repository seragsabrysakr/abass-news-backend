#!/bin/bash

echo "🚀 Building Abass News Backend..."

# Install dependencies
echo "📦 Installing dependencies..."
dart pub get

# Compile the test server
echo "🔨 Compiling test server..."
dart compile exe test_server.dart -o test_server

# Make executable
chmod +x test_server

echo "✅ Build complete!"
echo "🚀 Starting test server..."

# Set default port if not provided
export PORT=${PORT:-8080}

echo "🌐 Server will start on port $PORT"
echo "🔍 Environment variables:"
echo "   PORT: $PORT"
echo "   DB_HOST: ${DB_HOST:-'not set'}"
echo "   DB_PORT: ${DB_PORT:-'not set'}"
echo "   DB_NAME: ${DB_NAME:-'not set'}"

# Start the test server
echo "🚀 Executing: ./test_server"
./test_server 