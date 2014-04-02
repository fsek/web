module PhrasingHelper
  # You must implement the can_edit_phrases? method.
  # Example:
  #
  # def can_edit_phrases?
  #  current_user.is_admin?
  # end
  def can_edit_phrases_sanning?
    current_user.role == Role.with_name(:sanningsspridare) 
  end
  def can_edit_phrases?
    current_user.admin?
  end
end
