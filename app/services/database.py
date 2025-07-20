import os
from sqlalchemy import create_engine
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
    def initialize(cls):
        """Initialize database connection"""
        try:
            # Database configuration - Railway specific
            db_host = os.getenv('DB_HOST', os.getenv('PGHOST', 'localhost'))
            db_port = os.getenv('DB_PORT', os.getenv('PGPORT', '5432'))
            db_name = os.getenv('DB_NAME', os.getenv('PGDATABASE', 'abass_news'))
            db_user = os.getenv('DB_USER', os.getenv('PGUSER', 'postgres'))
            db_password = os.getenv('DB_PASSWORD', os.getenv('PGPASSWORD', 'password'))
            
            # Log connection details (without password)
            print(f"🔌 Database connection details:")
            print(f"   Host: {db_host}")
            print(f"   Port: {db_port}")
            print(f"   Database: {db_name}")
            print(f"   User: {db_user}")
            
            # Create database URL
            database_url = f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"
            
            print(f"🔌 Connecting to database: {db_host}:{db_port}/{db_name}")
            
            # Create engine with connection pooling
            cls._engine = create_engine(
                database_url,
                pool_pre_ping=True,
                pool_recycle=300,
                echo=False  # Set to True for SQL debugging
            )
            
            # Create session factory
            cls._SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=cls._engine)
            
            # Test connection
            with cls._engine.connect() as conn:
                conn.execute("SELECT 1")
            
            # Create tables
            cls._create_tables()
            
            print("✅ Database connected successfully")
            return True
            
        except Exception as e:
            print(f"❌ Database connection failed: {e}")
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