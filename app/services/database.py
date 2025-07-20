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
            # Database configuration
            db_host = os.getenv('DB_HOST', 'localhost')
            db_port = os.getenv('DB_PORT', '5432')
            db_name = os.getenv('DB_NAME', 'abass_news')
            db_user = os.getenv('DB_USER', 'postgres')
            db_password = os.getenv('DB_PASSWORD', 'password')
            
            # Create database URL
            database_url = f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"
            
            print(f"🔌 Connecting to database: {db_host}:{db_port}/{db_name}")
            
            # Create engine
            cls._engine = create_engine(database_url)
            
            # Create session factory
            cls._SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=cls._engine)
            
            # Create tables
            cls._create_tables()
            
            print("✅ Database connected successfully")
            return True
            
        except Exception as e:
            print(f"❌ Database connection failed: {e}")
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