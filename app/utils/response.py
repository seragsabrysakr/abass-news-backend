from flask import jsonify
from typing import Any, Dict, Optional

def success_response(data: Any = None, message: str = "Success", status_code: int = 200) -> tuple:
    """Create a success response matching Flutter app format"""
    response = {
        'status': True,
        'message': message,
        'data': data,
        'statusCode': status_code
    }
    
    return jsonify(response), status_code

def error_response(message: str = "Error", status_code: int = 400, data: Any = None) -> tuple:
    """Create an error response matching Flutter app format"""
    response = {
        'status': False,
        'message': message,
        'data': data,
        'statusCode': status_code
    }
    
    return jsonify(response), status_code

def api_response(data: Any = None, message: str = "Success", status: bool = True, status_code: int = 200) -> tuple:
    """Create a standardized API response matching Flutter app format"""
    response = {
        'status': status,
        'message': message,
        'data': data,
        'statusCode': status_code
    }
    
    return jsonify(response), status_code 