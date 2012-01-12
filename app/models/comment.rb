class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true
  belongs_to :approver, :class_name => User.name

  validates_presence_of :name, :email, :comment
  validates_format_of   :email, :with => /^\S+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})(\]?)$/ix
  validates_format_of   :website, :with => /^(http:\/\/|https:\/\/)?([a-z0-9]([-a-z0-9]*[a-z0-9])?\.)+((a[cdefgilmnoqrstuwxz]|aero|arpa)|(b[abdefghijmnorstvwyz]|biz)|(c[acdfghiklmnorsuvxyz]|cat|com|coop)|d[ejkmoz]|(e[ceghrstu]|edu)|f[ijkmor]|(g[abdefghilmnpqrstuwy]|gov)|h[kmnrtu]|(i[delmnoqrst]|info|int)|(j[emop]|jobs)|k[eghimnprwyz]|l[abcikrstuvy]|(m[acdghklmnopqrstuvwxyz]|mil|mobi|museum)|(n[acefgilopruz]|name|net)|(om|org)|(p[aefghklmnrstwy]|pro)|qa|r[eouw]|s[abcdeghijklmnortvyz]|(t[cdfghjklmnoprtvwz]|travel)|u[agkmsyz]|v[aceginu]|w[fs]|y[etu]|z[amw])$/i, :unless => Proc.new {|model| model.website.blank?}

  scope :base, where(:parent_id => nil)

  default_scope :order => 'created_at ASC'
  acts_as_nested_set :dependent => :destroy, :text_column => 'title'

  scope :accepted, where(:approved => true, :approve_pending => false)
  scope :denied, where(:approved => false, :approve_pending => false)
  scope :pending, where(:approve_pending => true)

  #require 'gravtastic'
  include Gravtastic
  is_gravtastic!
  
  def before_save
    self.website = nil if self.website.blank?
    self.website = "http://" + self.website if self.website and !self.website.start_with?("http://")
  end

  def accepted_children
    children.map{ |c| c if c.approved and !c.approve_pending }.compact
  end

  def accepted_children_count
    total = 0
    accepted_children.each do |c|
      total += c.accepted_children_count unless c.accepted_children.empty?
    end
    total + accepted_children.size
  end

end
