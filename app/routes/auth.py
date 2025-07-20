from flask import Blueprint, request, jsonify
from app.services.auth import AuthService
from app.middleware.auth import require_auth

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/register', methods=['POST'])
def register():
    """Register a new user"""
    try:
        data = request.get_json()
        email = data.get('email')
        username = data.get('username')
        password = data.get('password')
        
        if not all([email, username, password]):
            return jsonify({'error': 'Email, username, and password are required'}), 400
        
        result = AuthService.register_user(email, username, password)
        
        return jsonify({
            'message': 'User registered successfully',
            'token': result['token'],
            'user': result['user']
        }), 201
        
    except ValueError as e:
        return jsonify({'error': str(e)}), 409
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@auth_bp.route('/login', methods=['POST'])
def login():
    """Login user"""
    try:
        data = request.get_json()
        email = data.get('email')
        password = data.get('password')
        
        if not all([email, password]):
            return jsonify({'error': 'Email and password are required'}), 400
        
        result = AuthService.login_user(email, password)
        
        return jsonify({
            'message': 'Login successful',
            'token': result['token'],
            'user': result['user']
        })
        
    except ValueError as e:
        return jsonify({'error': str(e)}), 401
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@auth_bp.route('/forgot-password', methods=['POST'])
def forgot_password():
    """Send password reset token"""
    try:
        data = request.get_json()
        email = data.get('email')
        
        if not email:
            return jsonify({'error': 'Email is required'}), 400
        
        reset_token = AuthService.create_password_reset_token(email)
        
        return jsonify({
            'message': 'Password reset token generated',
            'resetToken': reset_token
        })
        
    except ValueError as e:
        return jsonify({'error': str(e)}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@auth_bp.route('/reset-password', methods=['POST'])
def reset_password():
    """Reset password using token"""
    try:
        data = request.get_json()
        token = data.get('token')
        new_password = data.get('newPassword')
        
        if not all([token, new_password]):
            return jsonify({'error': 'Token and newPassword are required'}), 400
        
        if len(new_password) < 6:
            return jsonify({'error': 'Password must be at least 6 characters long'}), 400
        
        success = AuthService.reset_password(token, new_password)
        
        if not success:
            return jsonify({'error': 'Invalid or expired token'}), 400
        
        return jsonify({'message': 'Password reset successful'})
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@auth_bp.route('/delete', methods=['DELETE'])
@require_auth
def delete_account():
    """Delete user account"""
    try:
        success = AuthService.delete_user(request.user['user_id'])
        
        if not success:
            return jsonify({'error': 'User not found'}), 404
        
        return jsonify({'message': 'Account deleted successfully'})
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500 