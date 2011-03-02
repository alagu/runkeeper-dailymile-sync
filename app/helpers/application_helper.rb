module ApplicationHelper
  def notice(text)
    content_tag(:div, :class => 'flash notice') do
      content_tag(:p, text)
    end
  end
end
