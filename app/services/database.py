import os
import sys
from urllib.parse import urlparse
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from app.models.user import Base as UserBase
from app.models.article import Article
from app.models.issue import Issue
from app.models.password_reset import PasswordReset

class DatabaseService:
    _engine = None
    _SessionLocal = None
    
    @classmethod
    def _parse_railway_url(cls, db_host):
        """Parse Railway's PostgreSQL URL format"""
        try:
            if db_host.startswith('postgresql://'):
                # Parse the full URL
                parsed = urlparse(db_host)
                host = parsed.hostname
                port = parsed.port or 5432
                username = parsed.username
                password = parsed.password
                database = parsed.path.lstrip('/')
                
                return {
                    'host': host,
                    'port': port,
                    'user': username,
                    'password': password,
                    'database': database
                }
            else:
                # Fallback to individual environment variables
                return None
        except Exception as e:
            print(f"❌ Failed to parse Railway URL: {e}")
            return None
    
    @classmethod
    def initialize(cls):
        """Initialize database connection"""
        try:
            # Get the DB_HOST which might be a full PostgreSQL URL
            db_host_env = os.getenv('DB_HOST', '')
            
            # Try to parse as Railway URL first
            railway_config = cls._parse_railway_url(db_host_env)
            
            if railway_config:
                # Use Railway URL configuration
                db_host = railway_config['host']
                db_port = railway_config['port']
                db_name = railway_config['database']
                db_user = railway_config['user']
                db_password = railway_config['password']
                
                print(f"🔍 Using Railway PostgreSQL URL configuration")
            else:
                # Fallback to individual environment variables
                db_host = os.getenv('DB_HOST', os.getenv('PGHOST', 'localhost'))
                db_port = os.getenv('DB_PORT', os.getenv('PGPORT', '5432'))
                db_name = os.getenv('DB_NAME', os.getenv('PGDATABASE', 'abass_news'))
                db_user = os.getenv('DB_USER', os.getenv('PGUSER', 'postgres'))
                db_password = os.getenv('DB_PASSWORD', os.getenv('PGPASSWORD', 'password'))
                
                print(f"🔍 Using individual environment variables")
            
            # Log connection details (without password)
            print(f"🔌 Database connection details:")
            print(f"   Host: {db_host}")
            print(f"   Port: {db_port}")
            print(f"   Database: {db_name}")
            print(f"   User: {db_user}")
            print(f"   Password: {'Set' if db_password else 'Not set'}")
            
            # Check if we have all required variables
            if not all([db_host, db_port, db_name, db_user, db_password]):
                print("❌ Missing required database environment variables")
                print("🔍 Please ensure you have a PostgreSQL database in your Railway project")
                return False
            
            # Create database URL
            database_url = f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"
            
            print(f"🔌 Connecting to database: {db_host}:{db_port}/{db_name}")
            
            # Create engine with connection pooling
            cls._engine = create_engine(
                database_url,
                pool_pre_ping=True,
                pool_recycle=300,
                echo=False,  # Set to True for SQL debugging
                connect_args={
                    "connect_timeout": 10,
                    "application_name": "abass_news_app"
                }
            )
            
            # Create session factory
            cls._SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=cls._engine)
            
            # Test connection with SQLAlchemy
            print("🔍 Testing database connection...")
            with cls._engine.connect() as conn:
                result = conn.execute(text("SELECT 1 as test"))
                print(f"✅ Database connection test successful: {result.fetchone()}")
            
            # Create tables
            cls._create_tables()
            
            print("✅ Database connected successfully")
            return True
            
        except Exception as e:
            print(f"❌ Database connection failed: {e}")
            print(f"🔍 Error type: {type(e).__name__}")
            print(f"🔍 Environment variables:")
            print(f"   DB_HOST: {os.getenv('DB_HOST', 'Not set')}")
            print(f"   PGHOST: {os.getenv('PGHOST', 'Not set')}")
            print(f"   DB_PORT: {os.getenv('DB_PORT', 'Not set')}")
            print(f"   PGPORT: {os.getenv('PGPORT', 'Not set')}")
            print(f"   DB_NAME: {os.getenv('DB_NAME', 'Not set')}")
            print(f"   PGDATABASE: {os.getenv('PGDATABASE', 'Not set')}")
            print(f"   DB_USER: {os.getenv('DB_USER', 'Not set')}")
            print(f"   PGUSER: {os.getenv('PGUSER', 'Not set')}")
            print(f"   DB_PASSWORD: {'Set' if os.getenv('DB_PASSWORD') else 'Not set'}")
            print(f"   PGPASSWORD: {'Set' if os.getenv('PGPASSWORD') else 'Not set'}")
            
            # Print all environment variables for debugging
            print("🔍 All environment variables:")
            for key, value in os.environ.items():
                if 'PG' in key or 'DB' in key:
                    if 'PASSWORD' in key:
                        print(f"   {key}: {'Set' if value else 'Not set'}")
                    else:
                        print(f"   {key}: {value}")
            
            return False
    
    @classmethod
    def _create_tables(cls):
        """Create database tables"""
        try:
            # Import all models to register them
            from app.models.user import User
            from app.models.article import Article
            from app.models.issue import Issue
            from app.models.password_reset import PasswordReset
            
            # Create all tables
            UserBase.metadata.create_all(bind=cls._engine)
            print("📋 Database tables created/verified")
            
        except Exception as e:
            print(f"❌ Database table creation failed: {e}")
            print(f"🔍 Error type: {type(e).__name__}")
            raise
    
    @classmethod
    def get_session(cls):
        """Get database session"""
        if cls._SessionLocal is None:
            raise Exception("Database not initialized. Call DatabaseService.initialize() first.")
        return cls._SessionLocal()
    
    @classmethod
    def close(cls):
        """Close database connection"""
        if cls._engine:
            cls._engine.dispose()
            print("🔌 Database connection closed") 