module PeopleHelper
  

  def show_attr(attr_name, subject, attribute)
    # Display content only if subject and its attribute exist
      content_tag(:p, "#{attr_name}: #{subject[attribute]}") if (subject && subject[attribute])
  end

end
