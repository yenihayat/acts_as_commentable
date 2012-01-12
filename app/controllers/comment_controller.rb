# encoding: UTF-8
class CommentController < ApplicationController

  def create
    comment                   = Comment.new(params[:comment])
    comment.commentable_id    = params[:id]
    comment.commentable_type  = params[:type]
    
    unless comment.commentable.approval
      comment.approved = true
      comment.approve_pending = false
    end
    
    if simple_captcha_valid?
      render :update do |page|
        if comment.save
          comment.move_to_child_of(Comment.find(params[:parent_id])) unless params[:parent_id].blank?
          page.redirect_to :back
        else
          page[comment.commentable.div_id].replace_html :partial => "new_comment", :locals => { :comment => comment, :parent_id => params[:parent_id] }
        end
      end
    else
      render :update do |page|
        page << "$('##{comment.commentable.div_id} .simple_captcha_label').html('<span style=\"color:red\">Resmindeki harf dizisini doğru olarak girmelisiniz.</span>');"        
      end
    end
  end

end
