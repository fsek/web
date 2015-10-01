module ExLinkHelper
  # instead of boring true/false for booleans renders appropriate symbols
  def bool2icon(boolval)
    if boolval
      res = "<i class='fa fa-check'>"
    else
      res = "<i class='fa fa-times'>"
    end
    res.html_safe
  end
end
