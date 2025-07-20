from flask import Blueprint, request, jsonify
from app.services.issue import IssueService
from app.middleware.auth import require_auth, require_admin
from app.utils.response import success_response, error_response

issues_bp = Blueprint('issues', __name__)

@issues_bp.route('/', methods=['GET'])
@require_admin
def get_all_issues():
    """Get all issues (Admin only)"""
    try:
        issues = IssueService.get_all_issues()
        return success_response(
            data={'issues': issues},
            message="Issues retrieved successfully"
        )
        
    except Exception as e:
        return error_response("Internal server error", 500)

@issues_bp.route('/user', methods=['GET'])
@require_auth
def get_user_issues():
    """Get user issues (Authenticated)"""
    try:
        issues = IssueService.get_user_issues(request.user['user_id'])
        return success_response(
            data={'issues': issues},
            message="User issues retrieved successfully"
        )
        
    except Exception as e:
        return error_response("Internal server error", 500)

@issues_bp.route('/', methods=['POST'])
@require_auth
def create_issue():
    """Create new issue (Authenticated)"""
    try:
        data = request.get_json()
        title = data.get('title')
        description = data.get('description')
        image_url = data.get('image_url')
        attachments = data.get('attachments', [])
        
        if not all([title, description]):
            return error_response("Title and description are required", 400)
        
        issue = IssueService.create_issue(
            user_id=request.user['user_id'],
            title=title,
            description=description,
            image_url=image_url,
            attachments=attachments
        )
        
        return success_response(
            data={'issue': issue},
            message="Issue created successfully",
            status_code=201
        )
        
    except Exception as e:
        return error_response("Internal server error", 500)

@issues_bp.route('/<int:issue_id>/status', methods=['PUT'])
@require_admin
def update_issue_status(issue_id):
    """Update issue status (Admin only)"""
    try:
        data = request.get_json()
        status = data.get('status')
        admin_notes = data.get('admin_notes')
        
        if not status:
            return error_response("Status is required", 400)
        
        valid_statuses = ['pending', 'in_progress', 'resolved', 'closed', 'rejected']
        if status not in valid_statuses:
            return error_response(f"Status must be one of: {', '.join(valid_statuses)}", 400)
        
        issue = IssueService.update_issue_status(issue_id, status, admin_notes)
        
        if not issue:
            return error_response("Issue not found", 404)
        
        return success_response(
            data={'issue': issue},
            message="Issue status updated successfully"
        )
        
    except Exception as e:
        return error_response("Internal server error", 500) 