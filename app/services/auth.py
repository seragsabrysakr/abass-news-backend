import os
import jwt
import bcrypt
import secrets
from datetime import datetime, timedelta
from sqlalchemy.orm import Session
from app.models.user import User
from app.models.password_reset import PasswordReset
from app.services.database import DatabaseService

class AuthService:
    JWT_SECRET = os.getenv('JWT_SECRET', 'your-secret-key-change-this')
    
    @classmethod
    def hash_password(cls, password: str) -> str:
        """Hash password using bcrypt"""
        return bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
    
    @classmethod
    def verify_password(cls, password: str, hashed: str) -> bool:
        """Verify password against hash"""
        return bcrypt.checkpw(password.encode('utf-8'), hashed.encode('utf-8'))
    
    @classmethod
    def create_jwt_token(cls, user_id: int, email: str, role: str) -> str:
        """Create JWT token"""
        payload = {
            'user_id': user_id,
            'email': email,
            'role': role,
            'exp': datetime.utcnow() + timedelta(days=7)
        }
        return jwt.encode(payload, cls.JWT_SECRET, algorithm='HS256')
    
    @classmethod
    def verify_jwt_token(cls, token: str) -> dict:
        """Verify JWT token"""
        try:
            payload = jwt.decode(token, cls.JWT_SECRET, algorithms=['HS256'])
            return payload
        except jwt.ExpiredSignatureError:
            return None
        except jwt.InvalidTokenError:
            return None
    
    @classmethod
    def register_user(cls, email: str, username: str, password: str) -> dict:
        """Register a new user"""
        session = DatabaseService.get_session()
        try:
            # Check if user already exists
            existing_user = session.query(User).filter(
                (User.email == email) | (User.username == username)
            ).first()
            
            if existing_user:
                raise ValueError("User already exists")
            
            # Hash password
            password_hash = cls.hash_password(password)
            
            # Create user
            user = User(
                email=email,
                username=username,
                password_hash=password_hash
            )
            
            session.add(user)
            session.commit()
            session.refresh(user)
            
            # Create token
            token = cls.create_jwt_token(user.id, user.email, user.role)
            
            return {
                'user': user.to_dict(),
                'token': token
            }
            
        finally:
            session.close()
    
    @classmethod
    def login_user(cls, email: str, password: str) -> dict:
        """Login user"""
        session = DatabaseService.get_session()
        try:
            # Get user
            user = session.query(User).filter(User.email == email).first()
            
            if not user:
                raise ValueError("Invalid credentials")
            
            # Verify password
            if not cls.verify_password(password, user.password_hash):
                raise ValueError("Invalid credentials")
            
            # Create token
            token = cls.create_jwt_token(user.id, user.email, user.role)
            
            return {
                'user': user.to_dict(),
                'token': token
            }
            
        finally:
            session.close()
    
    @classmethod
    def create_password_reset_token(cls, email: str) -> str:
        """Create password reset token"""
        session = DatabaseService.get_session()
        try:
            # Check if user exists
            user = session.query(User).filter(User.email == email).first()
            
            if not user:
                raise ValueError("User not found")
            
            # Generate reset token
            reset_token = secrets.token_urlsafe(32)
            
            # Store reset token
            password_reset = PasswordReset(
                user_id=user.id,
                token=reset_token
            )
            
            session.add(password_reset)
            session.commit()
            
            return reset_token
            
        finally:
            session.close()
    
    @classmethod
    def reset_password(cls, token: str, new_password: str) -> bool:
        """Reset password using token"""
        session = DatabaseService.get_session()
        try:
            # Find valid reset token
            password_reset = session.query(PasswordReset).filter(
                PasswordReset.token == token,
                PasswordReset.used == False,
                PasswordReset.created_at > datetime.utcnow() - timedelta(hours=1)
            ).first()
            
            if not password_reset:
                return False
            
            # Hash new password
            password_hash = cls.hash_password(new_password)
            
            # Update password
            user = session.query(User).filter(User.id == password_reset.user_id).first()
            user.password_hash = password_hash
            user.updated_at = datetime.utcnow()
            
            # Mark token as used
            password_reset.used = True
            
            session.commit()
            return True
            
        finally:
            session.close()
    
    @classmethod
    def delete_user(cls, user_id: int) -> bool:
        """Delete user account"""
        session = DatabaseService.get_session()
        try:
            user = session.query(User).filter(User.id == user_id).first()
            
            if not user:
                return False
            
            session.delete(user)
            session.commit()
            return True
            
        finally:
            session.close() 