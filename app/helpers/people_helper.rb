module PeopleHelper
  


  
  def show_attr(attr_string, subject, attribute, options = {})
    # Display content only if subject and its attribute exist
     attr_string if (subject && subject[attribute])
  end

  
  def show_dates_years(person)
    if !person.death_date
      "b. #{person.birth_date.year}"
    else
      "#{person.birth_date.year}-#{person.death_date.year}"
    end
  end



  def show_relationship_collection(relationship, collection)
    if (!collection.empty?)
      collection_links = collection.map do |person|
        link_to person.name, person_path(person)
      end
      content_tag(:p, sanitize("#{relationship}: #{collection_links.join(", ")}"))
    end
  end

  def subject_level_people(subject, siblings)
    siblings.to_a.push(subject).sort_by(&:birth_date)
  end

  


end
