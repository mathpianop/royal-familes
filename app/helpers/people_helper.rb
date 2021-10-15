module PeopleHelper
  

  def show_data(data_name, data_value)
    # If test_value is supplied, display content if test_value is truthy
    # Otherwise, display content if data_value is truthy
      content_tag(:p, "#{data_name}: #{data_value}") if data_value
  end

  def attribute(model, attribute)
    model.attribute if model
  end

end
