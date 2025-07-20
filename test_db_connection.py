#!/usr/bin/env python3
"""
Simple database connection test for Railway
"""

import os
import psycopg2
import time

def test_connection():
    """Test database connection"""
    print("🔍 Testing Railway database connection...")
    
    # Get connection details
    host = os.getenv('DB_HOST', 'postgres.railway.internal')
    port = os.getenv('DB_PORT', '5432')
    database = os.getenv('DB_NAME', 'railway')
    user = os.getenv('DB_USER', 'postgres')
    password = os.getenv('DB_PASSWORD', '')
    
    print(f"🔍 Connection details:")
    print(f"   Host: {host}")
    print(f"   Port: {port}")
    print(f"   Database: {database}")
    print(f"   User: {user}")
    print(f"   Password: {'Set' if password else 'Not set'}")
    
    # Try to connect
    max_attempts = 5
    for attempt in range(max_attempts):
        try:
            print(f"\n🔄 Attempt {attempt + 1}/{max_attempts}")
            
            conn = psycopg2.connect(
                host=host,
                port=port,
                database=database,
                user=user,
                password=password,
                connect_timeout=10
            )
            
            cur = conn.cursor()
            cur.execute("SELECT version()")
            version = cur.fetchone()
            
            print(f"✅ Connection successful!")
            print(f"   PostgreSQL version: {version[0]}")
            
            # Test creating a table
            cur.execute("""
                CREATE TABLE IF NOT EXISTS test_connection (
                    id SERIAL PRIMARY KEY,
                    message TEXT,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            """)
            
            # Insert test data
            cur.execute("""
                INSERT INTO test_connection (message) 
                VALUES ('Connection test successful')
            """)
            
            # Query test data
            cur.execute("SELECT * FROM test_connection ORDER BY created_at DESC LIMIT 1")
            result = cur.fetchone()
            
            print(f"✅ Database operations successful!")
            print(f"   Test record: {result}")
            
            cur.close()
            conn.close()
            
            return True
            
        except Exception as e:
            print(f"❌ Attempt {attempt + 1} failed: {e}")
            
            if attempt < max_attempts - 1:
                print(f"⏳ Waiting 5 seconds before retry...")
                time.sleep(5)
    
    return False

if __name__ == "__main__":
    success = test_connection()
    
    if success:
        print("\n🎉 Database connection is working!")
        print("✅ Your Railway PostgreSQL database is properly configured.")
    else:
        print("\n❌ Database connection failed!")
        print("🔍 Please check:")
        print("   1. You have a PostgreSQL database service in Railway")
        print("   2. The database service is running")
        print("   3. The database service is in the same project as your app")
        print("   4. Wait a few minutes for the database to fully initialize") 