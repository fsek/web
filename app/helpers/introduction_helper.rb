module IntroductionHelper
  def display_matrix_class(cookies)
    hide = cookies.fetch(:hide_matrix, false)
    if hide == 'true'
      'hide-matrix'
    end
  end
end
