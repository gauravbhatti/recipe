class CommentsController < ApplicationController
  before_filter :require_user
  
  def new
    @comment = Comment.new
  end
  
  def create
    @comment = current_user.comments.new(params[:comment])
    if @comment.save
      render :update do |page|
        page.insert_html "bottom","source_comments", :partial => "/comments/comment", :locals => {:comment => @comment}
      end
    else
      render :update do |page|
        page.alert @comment.errors.full_messages.map {|m| m + " "}
      end
    end
  end
  
  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy
    if request.xhr?
      render :update do |page|
        page.remove "comment_#{params[:id]}"
      end
    end
  end
  
end
