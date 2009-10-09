class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true

  validates_presence_of :name, :email, :comment
  validates_format_of   :email, :with => /^\S+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})(\]?)$/ix

  default_scope :order => 'created_at ASC'

  def before_save
    self.website = "http://" + self.website unless self.website.start_with?("http://") if self.website
  end

end
