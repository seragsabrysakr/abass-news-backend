#!/bin/bash

echo "🚀 Deploying Python Flask Backend..."

# Install Python dependencies
echo "📦 Installing Python dependencies..."
pip install -r requirements.txt

# Start the Flask application
echo "🚀 Starting Flask application..."
python app.py 