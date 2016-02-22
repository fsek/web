module PostUserService
  def self.create(post_user)
    post_user.validate

    if post_user.post.try(:limited?)
      post_user.errors.add(:post, I18n.t('post.limited'))
      return false
    end

    post_user.save
  end
end
