#!/usr/bin/env python3
"""
Railway Database Connection Debug Script
Run this to test database connection on Railway
"""

import os
import psycopg2
from sqlalchemy import create_engine

def test_direct_connection():
    """Test direct psycopg2 connection"""
    print("🔍 Testing direct psycopg2 connection...")
    
    # Get environment variables
    db_host = os.getenv('DB_HOST', os.getenv('PGHOST', 'localhost'))
    db_port = os.getenv('DB_PORT', os.getenv('PGPORT', '5432'))
    db_name = os.getenv('DB_NAME', os.getenv('PGDATABASE', 'abass_news'))
    db_user = os.getenv('DB_USER', os.getenv('PGUSER', 'postgres'))
    db_password = os.getenv('DB_PASSWORD', os.getenv('PGPASSWORD', 'password'))
    
    print(f"🔍 Connection details:")
    print(f"   Host: {db_host}")
    print(f"   Port: {db_port}")
    print(f"   Database: {db_name}")
    print(f"   User: {db_user}")
    print(f"   Password: {'Set' if db_password else 'Not set'}")
    
    try:
        # Test direct connection
        conn = psycopg2.connect(
            host=db_host,
            port=db_port,
            database=db_name,
            user=db_user,
            password=db_password,
            connect_timeout=10
        )
        
        cur = conn.cursor()
        cur.execute("SELECT version()")
        version = cur.fetchone()
        print(f"✅ Direct connection successful: {version[0]}")
        
        cur.close()
        conn.close()
        return True
        
    except Exception as e:
        print(f"❌ Direct connection failed: {e}")
        return False

def test_sqlalchemy_connection():
    """Test SQLAlchemy connection"""
    print("\n🔍 Testing SQLAlchemy connection...")
    
    # Get environment variables
    db_host = os.getenv('DB_HOST', os.getenv('PGHOST', 'localhost'))
    db_port = os.getenv('DB_PORT', os.getenv('PGPORT', '5432'))
    db_name = os.getenv('DB_NAME', os.getenv('PGDATABASE', 'abass_news'))
    db_user = os.getenv('DB_USER', os.getenv('PGUSER', 'postgres'))
    db_password = os.getenv('DB_PASSWORD', os.getenv('PGPASSWORD', 'password'))
    
    try:
        # Create database URL
        database_url = f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"
        
        # Create engine
        engine = create_engine(
            database_url,
            pool_pre_ping=True,
            pool_recycle=300,
            connect_args={
                "connect_timeout": 10,
                "application_name": "abass_news_debug"
            }
        )
        
        # Test connection
        with engine.connect() as conn:
            result = conn.execute("SELECT 1 as test")
            print(f"✅ SQLAlchemy connection successful: {result.fetchone()}")
        
        engine.dispose()
        return True
        
    except Exception as e:
        print(f"❌ SQLAlchemy connection failed: {e}")
        return False

def main():
    """Main function"""
    print("🚀 Railway Database Connection Debug")
    print("=" * 50)
    
    # Print all environment variables
    print("🔍 Environment variables:")
    for key, value in os.environ.items():
        if 'PG' in key or 'DB' in key:
            if 'PASSWORD' in key:
                print(f"   {key}: {'Set' if value else 'Not set'}")
            else:
                print(f"   {key}: {value}")
    
    print("\n" + "=" * 50)
    
    # Test connections
    direct_success = test_direct_connection()
    sqlalchemy_success = test_sqlalchemy_connection()
    
    print("\n" + "=" * 50)
    print("📊 Results:")
    print(f"   Direct psycopg2: {'✅ Success' if direct_success else '❌ Failed'}")
    print(f"   SQLAlchemy: {'✅ Success' if sqlalchemy_success else '❌ Failed'}")
    
    if not direct_success and not sqlalchemy_success:
        print("\n❌ Both connection methods failed!")
        print("🔍 Please check:")
        print("   1. You have a PostgreSQL database in your Railway project")
        print("   2. The database service is running")
        print("   3. Environment variables are set correctly")
    elif direct_success and not sqlalchemy_success:
        print("\n⚠️  Direct connection works but SQLAlchemy fails")
        print("🔍 This might be a SQLAlchemy configuration issue")
    else:
        print("\n✅ Database connection is working!")

if __name__ == "__main__":
    main() 