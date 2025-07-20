from flask import Blueprint, request, jsonify
from app.services.auth import AuthService
from app.middleware.auth import require_auth
from app.utils.response import success_response, error_response

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/register', methods=['POST'])
def register():
    """Register a new user"""
    try:
        print("🔍 /auth/register endpoint called")
        
        data = request.get_json()
        if not data:
            print("❌ No JSON data received")
            return error_response("No JSON data provided", 400)
        
        email = data.get('email')
        username = data.get('username')
        password = data.get('password')
        
        print(f"🔍 Registration data: email={email}, username={username}")
        
        if not all([email, username, password]):
            print("❌ Missing required fields")
            return error_response("Email, username, and password are required", 400)
        
        result = AuthService.register_user(email, username, password)
        
        print("✅ Registration successful")
        return success_response(
            data={
                'token': result['token'],
                'user': result['user']
            },
            message="User registered successfully",
            status_code=201
        )
        
    except ValueError as e:
        print(f"❌ Validation error: {e}")
        return error_response(str(e), 409)
    except Exception as e:
        print(f"❌ Registration error: {e}")
        print(f"🔍 Error type: {type(e).__name__}")
        return error_response("Internal server error", 500)

@auth_bp.route('/login', methods=['POST'])
def login():
    """Login user"""
    try:
        print("🔍 /auth/login endpoint called")
        
        data = request.get_json()
        if not data:
            print("❌ No JSON data received")
            return error_response("No JSON data provided", 400)
        
        email = data.get('email')
        password = data.get('password')
        
        print(f"🔍 Login data: email={email}")
        
        if not all([email, password]):
            print("❌ Missing required fields")
            return error_response("Email and password are required", 400)
        
        result = AuthService.login_user(email, password)
        
        print("✅ Login successful")
        return success_response(
            data={
                'token': result['token'],
                'user': result['user']
            },
            message="Login successful"
        )
        
    except ValueError as e:
        print(f"❌ Validation error: {e}")
        return error_response(str(e), 401)
    except Exception as e:
        print(f"❌ Login error: {e}")
        print(f"🔍 Error type: {type(e).__name__}")
        return error_response("Internal server error", 500)

@auth_bp.route('/forgot-password', methods=['POST'])
def forgot_password():
    """Send password reset token"""
    try:
        print("🔍 /auth/forgot-password endpoint called")
        
        data = request.get_json()
        if not data:
            print("❌ No JSON data received")
            return error_response("No JSON data provided", 400)
        
        email = data.get('email')
        
        print(f"🔍 Forgot password data: email={email}")
        
        if not email:
            print("❌ Missing email")
            return error_response("Email is required", 400)
        
        reset_token = AuthService.create_password_reset_token(email)
        
        print("✅ Password reset token created")
        return success_response(
            data={'resetToken': reset_token},
            message="Password reset token generated"
        )
        
    except ValueError as e:
        print(f"❌ Validation error: {e}")
        return error_response(str(e), 404)
    except Exception as e:
        print(f"❌ Forgot password error: {e}")
        print(f"🔍 Error type: {type(e).__name__}")
        return error_response("Internal server error", 500)

@auth_bp.route('/reset-password', methods=['POST'])
def reset_password():
    """Reset password using token"""
    try:
        print("🔍 /auth/reset-password endpoint called")
        
        data = request.get_json()
        if not data:
            print("❌ No JSON data received")
            return error_response("No JSON data provided", 400)
        
        token = data.get('token')
        new_password = data.get('newPassword')
        
        print(f"🔍 Reset password data: token={'Set' if token else 'Not set'}")
        
        if not all([token, new_password]):
            print("❌ Missing required fields")
            return error_response("Token and newPassword are required", 400)
        
        if len(new_password) < 6:
            print("❌ Password too short")
            return error_response("Password must be at least 6 characters long", 400)
        
        success = AuthService.reset_password(token, new_password)
        
        if not success:
            print("❌ Password reset failed")
            return error_response("Invalid or expired token", 400)
        
        print("✅ Password reset successful")
        return success_response(message="Password reset successful")
        
    except Exception as e:
        print(f"❌ Reset password error: {e}")
        print(f"🔍 Error type: {type(e).__name__}")
        return error_response("Internal server error", 500)

@auth_bp.route('/delete', methods=['DELETE'])
@require_auth
def delete_account():
    """Delete user account"""
    try:
        print("🔍 /auth/delete endpoint called")
        
        success = AuthService.delete_user(request.user['user_id'])
        
        if not success:
            print("❌ User deletion failed")
            return error_response("User not found", 404)
        
        print("✅ Account deletion successful")
        return success_response(message="Account deleted successfully")
        
    except Exception as e:
        print(f"❌ Delete account error: {e}")
        print(f"🔍 Error type: {type(e).__name__}")
        return error_response("Internal server error", 500) 