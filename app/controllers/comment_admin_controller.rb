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

	# FIXME: Bir yorum silindiğinde birden fazla yorum siliniyor. Yorumlar nested tree yapısında.
	# lft ve rgt değerleri aynı oluyor o yüzden bir yorum silinirken diğer yorumlar da silinebiliyor.
  def delete
		return
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
      flash[:notice] = (params[:state] == 'true') ? I18n.t('comment.was_approved') : @comment.approve_pending ? I18n.t('comment.was_rejected') : I18n.t('comment.was_unapproved')
      @comment.update_attributes(:approved =>  params[:state], :approve_pending => false, :approver => @user)
      redirect_back :action => 'index', :id => @comment.commentable_id, :type => @comment.commentable_type
    else
      failed_permission
    end
  end

  def set_comment_table
		@comments = params[:type].constantize.find(params[:id]).comments.send(params[:comment_type])
    #render :update do |page|
    #  page["comments_table"].replace_html :partial => "table", :locals => { :comments => params[:type].constantize.find(params[:id]).comments.send(params[:comment_type]) }   
    #end
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
