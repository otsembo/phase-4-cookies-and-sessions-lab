class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    session[:page_views] ||= 0
    if session[:page_views].to_i < 3
      article = Article.find(params[:id])
      session[:page_views] = session[:page_views].to_i + 1
      render json: article
    else
      render json: {
        status: 401,
        message: "You need to be logged in to view extra pages"
      }, status: :unauthorized
    end

  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
