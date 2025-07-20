from flask import Flask
from flask_cors import CORS
from app.services.database import DatabaseService
from app.routes.auth import auth_bp
from app.routes.articles import articles_bp
from app.routes.issues import issues_bp

def create_app():
    """Application factory"""
    app = Flask(__name__)
    
    # Enable CORS
    CORS(app)
    
    # Initialize database
    DatabaseService.initialize()
    
    # Register blueprints
    app.register_blueprint(auth_bp, url_prefix='/auth')
    app.register_blueprint(articles_bp, url_prefix='/articles')
    app.register_blueprint(issues_bp, url_prefix='/issues')
    
    # Health check route
    @app.route('/', methods=['GET'])
    def health_check():
        """Health check endpoint"""
        try:
            # Test database connection
            session = DatabaseService.get_session()
            session.execute("SELECT 1")
            session.close()
            db_status = "connected"
        except Exception as e:
            db_status = f"error: {str(e)}"
        
        return {
            'status': 'healthy',
            'message': 'Welcome to Abass News API',
            'version': '1.0.0',
            'database': db_status,
            'endpoints': {
                'auth': {
                    'POST /auth/register': 'Register a new user',
                    'POST /auth/login': 'Login user',
                    'POST /auth/forgot-password': 'Send password reset token',
                    'POST /auth/reset-password': 'Reset password using token',
                    'DELETE /auth/delete': 'Delete user account (Authenticated)'
                },
                'articles': {
                    'GET /articles': 'Get all published articles',
                    'GET /articles/<id>': 'Get article by ID',
                    'POST /articles': 'Create new article (Admin only)',
                    'PUT /articles/<id>': 'Update article (Admin only)',
                    'DELETE /articles/<id>': 'Delete article (Admin only)'
                },
                'issues': {
                    'GET /issues': 'Get all issues (Admin only)',
                    'GET /issues/user': 'Get user issues (Authenticated)',
                    'POST /issues': 'Create new issue (Authenticated)',
                    'PUT /issues/<id>/status': 'Update issue status (Admin only)'
                }
            }
        }
    
    return app 