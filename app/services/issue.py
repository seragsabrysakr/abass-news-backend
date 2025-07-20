from datetime import datetime
from sqlalchemy.orm import Session
from app.models.issue import Issue
from app.services.database import DatabaseService

class IssueService:
    
    @classmethod
    def get_all_issues(cls) -> list:
        """Get all issues (admin only)"""
        session = DatabaseService.get_session()
        try:
            issues = session.query(Issue).order_by(Issue.created_at.desc()).all()
            return [issue.to_dict() for issue in issues]
            
        finally:
            session.close()
    
    @classmethod
    def get_user_issues(cls, user_id: int) -> list:
        """Get issues for specific user"""
        session = DatabaseService.get_session()
        try:
            issues = session.query(Issue).filter(
                Issue.user_id == user_id
            ).order_by(Issue.created_at.desc()).all()
            
            return [issue.to_dict() for issue in issues]
            
        finally:
            session.close()
    
    @classmethod
    def create_issue(cls, user_id: int, title: str, description: str,
                    image_url: str = None, attachments: list = None) -> dict:
        """Create new issue"""
        session = DatabaseService.get_session()
        try:
            issue = Issue(
                title=title,
                description=description,
                user_id=user_id,
                image_url=image_url,
                attachments=attachments or []
            )
            
            session.add(issue)
            session.commit()
            session.refresh(issue)
            
            return issue.to_dict()
            
        finally:
            session.close()
    
    @classmethod
    def update_issue_status(cls, issue_id: int, status: str, admin_notes: str = None) -> dict:
        """Update issue status (admin only)"""
        session = DatabaseService.get_session()
        try:
            issue = session.query(Issue).filter(Issue.id == issue_id).first()
            
            if not issue:
                return None
            
            issue.status = status
            issue.admin_notes = admin_notes
            issue.updated_at = datetime.utcnow()
            
            # Set resolved_at if status is resolved
            if status in ['resolved', 'closed']:
                issue.resolved_at = datetime.utcnow()
            
            session.commit()
            session.refresh(issue)
            
            return issue.to_dict()
            
        finally:
            session.close()
    
    @classmethod
    def delete_issue(cls, issue_id: int) -> bool:
        """Delete issue"""
        session = DatabaseService.get_session()
        try:
            issue = session.query(Issue).filter(Issue.id == issue_id).first()
            
            if not issue:
                return False
            
            session.delete(issue)
            session.commit()
            return True
            
        finally:
            session.close() 