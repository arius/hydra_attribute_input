module ActionView::Helpers::FormTagHelper
  def hydra_attribute_input_tag(hydra_attribute, value = nil, options = {})
    
    if HydraAttributeInput::BASIC_DATATYPE_TO_INPUT_MAPPING.include?(hydra_attribute.backend_type.to_sym)
      send("#{HydraAttributeInput::BASIC_DATATYPE_TO_INPUT_MAPPING[hydra_attribute.backend_type.to_sym]}_tag", hydra_attribute.name, value, options )
    elsif hydra_attribute.backend_type == "boolean"
      check_box_tag hydra_attribute.name, true, (value == true), options
    else
      "#{hydra_attribute.name} - #{hydra_attribute.backend_type}"
    end
    
  end
end


class ActionView::Helpers::FormBuilder
  def hydra_attribute_input(hydra_attribute, options = {})
    
    if HydraAttributeInput::BASIC_DATATYPE_TO_INPUT_MAPPING.include?(hydra_attribute.backend_type.to_sym)
      send("#{HydraAttributeInput::BASIC_DATATYPE_TO_INPUT_MAPPING[hydra_attribute.backend_type.to_sym]}", hydra_attribute.name, options )
    elsif hydra_attribute.backend_type == "boolean"
      check_box(hydra_attribute.name, options)
    else
      "#{hydra_attribute.name} - #{hydra_attribute.backend_type}"
    end
    
  end
end
