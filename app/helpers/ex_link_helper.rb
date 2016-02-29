module ExLinkHelper
  # instead of boring true/false for booleans renders appropriate symbols
  def bool2icon(boolval)
    if boolval
      res = fa_icon('check')
    else
      res = fa_icon('times')
    end
    res
  end

  # print tags nicely in labels
  def tags2labs(tagnames)
    res = ''
    tagnames.each do |tag|
      res += "<span class='label rounded label-warning'>#{tag}</span>\n"
    end
    res.html_safe
  end
end
