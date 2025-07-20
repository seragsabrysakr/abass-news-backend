from functools import wraps
from flask import request, jsonify
from app.services.auth import AuthService

def require_auth(f):
    """Decorator to require authentication"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        auth_header = request.headers.get('Authorization')
        if not auth_header or not auth_header.startswith('Bearer '):
            return jsonify({'error': 'Authentication required'}), 401
        
        token = auth_header.split(' ')[1]
        payload = AuthService.verify_jwt_token(token)
        if not payload:
            return jsonify({'error': 'Invalid token'}), 401
        
        request.user = payload
        return f(*args, **kwargs)
    return decorated_function

def require_admin(f):
    """Decorator to require admin role"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        auth_header = request.headers.get('Authorization')
        if not auth_header or not auth_header.startswith('Bearer '):
            return jsonify({'error': 'Authentication required'}), 401
        
        token = auth_header.split(' ')[1]
        payload = AuthService.verify_jwt_token(token)
        if not payload or payload.get('role') != 'admin':
            return jsonify({'error': 'Admin access required'}), 403
        
        request.user = payload
        return f(*args, **kwargs)
    return decorated_function 