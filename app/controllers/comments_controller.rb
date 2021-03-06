class CommentsController < ApplicationController
  before_action :find_commentable
  respond_to :html, :json

  def new
    @comment = Comment.new
  end

  def create
    response = Comment.save_comment(@commentable, comment_params)
    redirect_to :back, notice: response
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update_attributes(body: params[:comment][:body])
    respond_with @comment
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to :back
  end

  def upvote
    @comment = Comment.find(params[:id])
    @comment.vote_by voter: current_user
    redirect_to :back
  end

  def unupvote
    @comment = Comment.find(params[:id])
    @comment.unliked_by current_user
    redirect_to :back
  end

  def downvote
    @comment = Comment.find(params[:id])
    @comment.downvote_from current_user
    redirect_to :back
  end

  def undownvote
    @comment = Comment.find(params[:id])
    @comment.undisliked_by current_user
    redirect_to :back
  end

  private

  def comment_params
    params.require(:comment).permit(:email, :username, :body)
  end

  def find_commentable
    @commentable = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
    @commentable = Article.find_by_id(params[:article_id]) if params[:article_id]
  end
end
