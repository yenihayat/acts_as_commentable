# encoding: UTF-8
class CommentAdminController < Admin::AdminController
  before_filter {|controller| controller.class.layout("admin")}

  def index
    sites = @user.sites_of(@member, PERMISSIONS["see_#{params[:type].underscore}"])
    if !sites.clone.empty?
      @commentable = params[:type].constantize.find(params[:id]) 
      @comments = @commentable.comments
    else
      failed_permission
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    if @user.can_edit?(@comment.commentable)
      update(params) if request.put?
    else
      failed_permission
    end
  end

  def delete
    @comment = Comment.find(params[:id])
    if @user.can_edit?(@comment.commentable)
      @comment.destroy
      flash[:notice] = "Yorum silindi"
      redirect_back :action => 'index', :id => @comment.commentable_id, :type => @comment.commentable_type
    else
      failed_permission
    end
  end

  def approve
    @comment = Comment.find(params[:id])
    if @user.can_edit?(@comment.commentable)
      flash[:notice] = params[:state] ? "Yorum onaylandı" : @comment.approve_pending ? "Yorum reddedildi" : "Yorumdan onay kaldırıldı"
      @comment.update_attributes(:approved =>  params[:state], :approve_pending => false, :approver => @user)
      redirect_back :action => 'index', :id => @comment.commentable_id, :type => @comment.commentable_type
    else
      failed_permission
    end
  end

  def set_comment_table
    render :update do |page|
      page["comments_table"].replace_html :partial => "table", :locals => { :comments => params[:type].constantize.find(params[:id]).comments.send(params[:comment_type]) }   
    end
  end

  #---------------------------------------------------------------------------------------------------
  #PRIVATE

  private

  def update(params)
    if @user.can_edit?(@comment.commentable)

      if @comment.update_attributes(params[:comment])
        flash[:notice] = "Yorum güncellendi"
        redirect_back :action => 'index', :id => @comment.commentable_id, :type => @comment.commentable_type
      end
    else
      failed_permission
    end
  end

end
