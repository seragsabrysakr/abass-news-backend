from datetime import datetime
from sqlalchemy.orm import Session
from app.models.article import Article
from app.models.user import User
from app.services.database import DatabaseService

class ArticleService:
    
    @classmethod
    def get_published_articles(cls) -> list:
        """Get all published articles"""
        session = DatabaseService.get_session()
        try:
            articles = session.query(Article).filter(
                Article.is_published == True
            ).order_by(Article.published_at.desc()).all()
            
            return [article.to_dict() for article in articles]
            
        finally:
            session.close()
    
    @classmethod
    def get_article_by_id(cls, article_id: int) -> dict:
        """Get article by ID"""
        session = DatabaseService.get_session()
        try:
            article = session.query(Article).filter(
                Article.id == article_id,
                Article.is_published == True
            ).first()
            
            return article.to_dict() if article else None
            
        finally:
            session.close()
    
    @classmethod
    def create_article(cls, author_id: int, title: str, content: str, 
                      summary: str = None, image_url: str = None, 
                      tags: list = None, is_published: bool = False) -> dict:
        """Create new article"""
        session = DatabaseService.get_session()
        try:
            article = Article(
                title=title,
                content=content,
                author_id=author_id,
                summary=summary,
                image_url=image_url,
                tags=tags or [],
                is_published=is_published,
                published_at=datetime.utcnow() if is_published else None
            )
            
            session.add(article)
            session.commit()
            session.refresh(article)
            
            return article.to_dict()
            
        finally:
            session.close()
    
    @classmethod
    def update_article(cls, article_id: int, title: str = None, content: str = None,
                      summary: str = None, image_url: str = None, 
                      tags: list = None, is_published: bool = None) -> dict:
        """Update article"""
        session = DatabaseService.get_session()
        try:
            article = session.query(Article).filter(Article.id == article_id).first()
            
            if not article:
                return None
            
            # Update fields
            if title is not None:
                article.title = title
            if content is not None:
                article.content = content
            if summary is not None:
                article.summary = summary
            if image_url is not None:
                article.image_url = image_url
            if tags is not None:
                article.tags = tags
            if is_published is not None:
                article.is_published = is_published
                if is_published and not article.published_at:
                    article.published_at = datetime.utcnow()
            
            article.updated_at = datetime.utcnow()
            session.commit()
            session.refresh(article)
            
            return article.to_dict()
            
        finally:
            session.close()
    
    @classmethod
    def delete_article(cls, article_id: int) -> bool:
        """Delete article"""
        session = DatabaseService.get_session()
        try:
            article = session.query(Article).filter(Article.id == article_id).first()
            
            if not article:
                return False
            
            session.delete(article)
            session.commit()
            return True
            
        finally:
            session.close() 