# encoding: UTF-8
module CommentHelper

  def comments(commentable, opts={})
    opts = { :new_comment => true }.merge(opts)

    out = "<div class=\"comments\">"
    out << "<div class=\"count\">#{t 'comment.total'} : #{comment_number(commentable.comments.base)}</div>"
    out << comment(commentable.comments.base.accepted, opts)

    if opts[:new_comment]
      out << "<div id=\"#{commentable.div_id}_container\">"
      out << "<div id=\"#{commentable.div_id}\" class=\"form\">#{new_comment(commentable)}</div>"
      out << "</div>"
    end

    out << render(:partial => "comment/reply_comment", :locals => { :div_id => commentable.div_id, :reply_function => commentable.reply_function })
    out << "</div>"
  end

  def new_comment(commentable)
    render :partial => "comment/new_comment", :locals => { :comment => commentable.comments.build, :parent_id => nil }
  end

  def comment(comments, opts)
    unless comments.empty?
      avatar = comments.first.commentable.avatar
      reply_function = comments.first.commentable.reply_function
      out = "<ul>"
      comments.each do |c|
        out << "<li>"
        out << "<div class=\"avatar\">#{image_tag c.gravatar_url}</div>" if avatar
				if c.website?
          website_url = (c.website =~ /^http/i) ? c.website : 'http://'.concat(c.website)
				else
				  website_url = "/"
				end
        out << "<div class=\"author\">#{c.website ? link_to(c.try(:name), website_url, :target => "_blank", :rel => "external nofollow") : h(c.name || '')}</div>"
        out << "<div class=\"date\">#{c.created_at}</div>"
        out << "<div class=\"content\">#{h(c.comment || '')}</div>"
        if opts[:new_comment]
          out << "<div class=\"reply\">"
          out << "<div class=\"reply_link\">#{link_to_function(t('comment.reply.reply'), "#{reply_function}(this, #{c.id})")}</div>"
          out << "</div>"
        end
        accepted_children = c.accepted_children
        out << comment(accepted_children, opts) unless accepted_children.empty?
        out << "</li>"
      end
      out << "</ul>"
    else
      ""
    end
  end

  def comment_number(comments)
    total = 0
    comments.accepted.each do |c|
      total += c.accepted_children_count unless c.accepted_children.empty?
    end
    (total + comments.accepted.size).to_s
  end

end
