#!/usr/bin/env python3
"""
Abass News API - Main Application Entry Point
A modular Flask application with SQLAlchemy ORM
"""

import os
from app import create_app

def main():
    """Main application entry point"""
    # Create Flask app
    app = create_app()
    
    # Get port from environment or default to 8080
    port = int(os.getenv('PORT', 8080))
    
    print(f"🚀 Starting Flask app on port {port}")
    
    # Run the application
    app.run(
        host='0.0.0.0',
        port=port,
        debug=False
    )

if __name__ == '__main__':
    main() 