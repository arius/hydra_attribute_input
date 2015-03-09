module ActionView::Helpers::FormTagHelper
  def hydra_attribute_input_tag(hydra_attribute, value = nil, options = {})
    if hydra_attribute.valid_values.present?
      select_tag(hydra_attribute.name, [nil] + options_for_select(hydra_attribute.valid_values_to_array), options.except("method_for_name"))
    elsif HydraAttributeInput::BASIC_DATATYPE_TO_INPUT_MAPPING.include?(hydra_attribute.backend_type.to_sym)
      send("#{HydraAttributeInput::BASIC_DATATYPE_TO_INPUT_MAPPING[hydra_attribute.backend_type.to_sym]}_tag", hydra_attribute.name, value, options )
    elsif hydra_attribute.backend_type == "boolean"
      check_box_tag hydra_attribute.name, true, (value == true), options
    elsif hydra_attribute.backend_type == "polymorphic_association"
      select_tag("#{hydra_attribute.name}_id", options_for_select([nil] + options[:collection].map{|c| [c.send(options[:method_for_name]), c.id]}), options.except("method_for_name").except("collection")) <<
      hidden_field_tag("#{hydra_attribute.name}_type", (options[:class_name] || options[:collection].first.try(:class).try(:to_s)))
    else
      "#{hydra_attribute.name} - #{hydra_attribute.backend_type}"
    end
    
  end
end


class ActionView::Helpers::FormBuilder
  def hydra_attribute_input(hydra_attribute, options = {})
    
    if hydra_attribute.valid_values.present?
      select(hydra_attribute.name, [nil] + hydra_attribute.valid_values_to_array, options.except("method_for_name"))
    elsif HydraAttributeInput::BASIC_DATATYPE_TO_INPUT_MAPPING.include?(hydra_attribute.backend_type.to_sym)
      send("#{HydraAttributeInput::BASIC_DATATYPE_TO_INPUT_MAPPING[hydra_attribute.backend_type.to_sym]}", hydra_attribute.name, options )
    elsif hydra_attribute.backend_type == "boolean"
      check_box(hydra_attribute.name, options)
    elsif hydra_attribute.backend_type == "polymorphic_association"
      select("#{hydra_attribute.name}_id", [nil] + options[:collection].map{|c| [c.send(options[:method_for_name]), c.id]}, options.except("method_for_name").except("collection")) <<
      hidden_field("#{hydra_attribute.name}_type", value: (options[:class_name] || options[:collection].first.try(:class).try(:to_s)))
    else
      "#{hydra_attribute.name} - #{hydra_attribute.backend_type}"
    end
    
  end
end
