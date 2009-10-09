module CommentHelper

  def comments(commentable, opts={})
    default_opts = { :new_comment => true }
    opts = default_opts.merge(opts)

    out = "<div class=\"comments\">"
    out << "<div class=\"count\">#{commentable.comments.size} Yorum</div>"
    out << "<ul>"
    commentable.comments.each do |c|
      out << "<li>"
      out << "<div class=\"author\">#{c.website ? link_to(c.name, c.website, :target => "_blank", :rel => "external nofollow") : c.name}</div>"
      out << "<div class=\"date\">#{c.created_at}</div>"
      out << "<div class=\"content\">#{c.comment}</div>"
      out << "</li>"
    end
    out << "</ul>"

    if opts[:new_comment]
      out << "<div class=\"form\">#{new_comment(commentable)}</div>" 
    end

    out
  end

  def new_comment(commentable)
    render :partial => "comment/new_comment", :locals => {:comment => Comment.new, :commentable => commentable}
  end

end