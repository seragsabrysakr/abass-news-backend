from flask import jsonify
from typing import Any, Dict, Optional

def success_response(data: Any = None, message: str = "Success", status_code: int = 200) -> tuple:
    """Create a success response"""
    response = {
        'status': 'success',
        'message': message
    }
    
    if data is not None:
        response['data'] = data
    
    return jsonify(response), status_code

def error_response(message: str = "Error", status_code: int = 400, errors: Optional[Dict] = None) -> tuple:
    """Create an error response"""
    response = {
        'status': 'error',
        'message': message
    }
    
    if errors:
        response['errors'] = errors
    
    return jsonify(response), status_code

def api_response(data: Any = None, message: str = "Success", status: bool = True, status_code: int = 200) -> tuple:
    """Create a standardized API response"""
    response = {
        'status': status,
        'message': message
    }
    
    if data is not None:
        response['data'] = data
    
    return jsonify(response), status_code 