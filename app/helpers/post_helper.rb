module PostHelper
  def print_post_limit(post)
    if post.present?
      if post.rec_limit == 0 && post.limit == 0 || post.rec_limit > post.limit
        '*'
      elsif post.rec_limit == post.limit && post.rec_limit > 0
        %(#{post.limit} (x))
      elsif post.limit > 0 && post.rec_limit == 0
        post.limit
      elsif post.limit > post.rec_limit
        %(#{post.recLimit} - #{post.limit})
      end
    end
  end
end
