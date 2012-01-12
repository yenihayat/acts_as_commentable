Rails.application.routes.draw do

  # Rails 2.x
  #map.commentable "admin/comments/:action/:id", :controller => "comment_admin", :action => :action, :id => :id

  # Rails 3.x
  match 'admin/comments/index/:id', :to => 'admin/comments#index'
  match 'admin/comments/approve/:id', :to => 'admin/comments#approve'
  match 'admin/comments/set_comment_table/:id', :to => 'admin/comments#set_comment_table', :via => [:post]
  match 'admin/comments/delete/:id', :to => 'admin/comments#delete', :via => :post
  match 'admin/comments/edit/:id', :to => 'admin/comments#approve', :via => [:get, :put]

  match 'comment/create/:id', :to => 'comment#create', :via => :post
end
