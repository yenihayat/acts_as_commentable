class CommentController < ActionController::Base

  def create
    comment = Comment.new(params[:comment])
    comment.commentable_id = params[:id]
    comment.commentable_type = params[:type]
    comment.save
    redirect_to :back
  end

end