module PostUserService
  def self.create(post_user)
    post_user.validate

    if post_user.post.try(:limited?)
      post_user.errors.add(:post, I18n.t('posts.limited'))
      return false
    end

    post_user.save
  end

  def self.destroy(post_user)
    post_user.destroy!
  end
end
