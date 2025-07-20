from flask import Blueprint, request, jsonify
from app.services.article import ArticleService
from app.middleware.auth import require_auth, require_admin
from app.utils.response import success_response, error_response

articles_bp = Blueprint('articles', __name__)

@articles_bp.route('/', methods=['GET'])
def get_articles():
    """Get all published articles"""
    try:
        articles = ArticleService.get_published_articles()
        return success_response(
            data={'articles': articles},
            message="Articles retrieved successfully"
        )
        
    except Exception as e:
        return error_response("Internal server error", 500)

@articles_bp.route('/<int:article_id>', methods=['GET'])
def get_article(article_id):
    """Get article by ID"""
    try:
        article = ArticleService.get_article_by_id(article_id)
        
        if not article:
            return error_response("Article not found", 404)
        
        return success_response(
            data=article,
            message="Article retrieved successfully"
        )
        
    except Exception as e:
        return error_response("Internal server error", 500)

@articles_bp.route('/', methods=['POST'])
@require_admin
def create_article():
    """Create new article (Admin only)"""
    try:
        data = request.get_json()
        title = data.get('title')
        content = data.get('content')
        summary = data.get('summary')
        image_url = data.get('image_url')
        tags = data.get('tags', [])
        is_published = data.get('is_published', False)
        
        if not all([title, content]):
            return error_response("Title and content are required", 400)
        
        article = ArticleService.create_article(
            author_id=request.user['user_id'],
            title=title,
            content=content,
            summary=summary,
            image_url=image_url,
            tags=tags,
            is_published=is_published
        )
        
        return success_response(
            data={'article': article},
            message="Article created successfully",
            status_code=201
        )
        
    except Exception as e:
        return error_response("Internal server error", 500)

@articles_bp.route('/<int:article_id>', methods=['PUT'])
@require_admin
def update_article(article_id):
    """Update article (Admin only)"""
    try:
        data = request.get_json()
        title = data.get('title')
        content = data.get('content')
        summary = data.get('summary')
        image_url = data.get('image_url')
        tags = data.get('tags')
        is_published = data.get('is_published')
        
        if not any([title, content, summary, image_url, tags, is_published is not None]):
            return error_response("At least one field must be provided", 400)
        
        article = ArticleService.update_article(
            article_id=article_id,
            title=title,
            content=content,
            summary=summary,
            image_url=image_url,
            tags=tags,
            is_published=is_published
        )
        
        if not article:
            return error_response("Article not found", 404)
        
        return success_response(
            data={'article': article},
            message="Article updated successfully"
        )
        
    except Exception as e:
        return error_response("Internal server error", 500)

@articles_bp.route('/<int:article_id>', methods=['DELETE'])
@require_admin
def delete_article(article_id):
    """Delete article (Admin only)"""
    try:
        success = ArticleService.delete_article(article_id)
        
        if not success:
            return error_response("Article not found", 404)
        
        return success_response(message="Article deleted successfully")
        
    except Exception as e:
        return error_response("Internal server error", 500) 