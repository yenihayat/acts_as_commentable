# encoding: UTF-8
class CommentController < ApplicationController

  def create
    @comment                   = Comment.new(params[:comment])
    @comment.commentable_id    = params[:id]
    @comment.commentable_type  = params[:type]
    
    unless @comment.commentable.approval
      @comment.approved = true
      @comment.approve_pending = false
    end
    
    if simple_captcha_valid?
			@simple_captcha_valid = true
        if @comment.save
					@comment_saved = true
          @comment.move_to_child_of(Comment.find(params[:parent_id])) unless params[:parent_id].blank?
        end
    end
  end

end
