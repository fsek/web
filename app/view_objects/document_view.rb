class DocumentView
  attr_accessor :grid, :categories, :current_category

  def initialize(grid:, categories:, current_category: '')
    @grid = grid
    @categories = categories
    @current_category = current_category
  end
end
