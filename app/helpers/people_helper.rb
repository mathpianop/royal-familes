module PeopleHelper
  


  
  def show_attr(attr_name, subject, attribute, options = {})
    # Display content only if subject and its attribute exist
     attr_tag(attr_name, subject, attribute, options) if (subject && subject[attribute])
  end

  def attr_tag(attr_name, subject, attribute, options = {})
    if options[:link]
      formatted_attribute = link_to subject[attribute], person_path(subject)
    else
      formatted_attribute = subject[attribute]
    end
    tag.p(sanitize("#{attr_name}: #{formatted_attribute}"))
  end

  def show_relationship_collection(relationship, collection)
    if (!collection.empty?)
      collection_links = collection.map do |person|
        link_to person.name, person_path(person)
      end
      content_tag(:p, sanitize("#{relationship}: #{collection_links.join(", ")}"))
    end
  end

end
