module ApplicationHelper

  def page_title
    if ['show', 'new', 'edit'].include?(params[:action])
      "#{@page_title} | #{params[:controller].capitalize}"
    else
      @page_title
    end
  end

  def urls_to_images(s)
    unless s.nil?
      s.gsub! /\s(http:\/\/.*?(png|jpg))/,
          '<p><img src="\1"/></p>'
      s.html_safe
    end
  end

  def urls_to_links(s)
    unless s.nil?
      s.gsub! /\s(http:\/\/.*?)\s/,
              '<a href="\1"/>\1</a>'
      s.html_safe
    end
  end

end
