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
  include ActionView::Helpers::FormTagHelper
  
  def hydra_attribute_input(hydra_attribute, options = {})


    options_for_input = options.except(:method_for_name).except(:collection).except(:multiple).except(:with_add)
    options_for_select = options.except(:method_for_name).except(:collection).except(:with_add)
    

    if hydra_attribute.valid_values.present?

      select(hydra_attribute.name, [nil] + hydra_attribute.valid_values_to_array, {}, options_for_select)
    elsif HydraAttributeInput::BASIC_DATATYPE_TO_INPUT_MAPPING.include?(hydra_attribute.backend_type.to_sym)
     
      send("#{HydraAttributeInput::BASIC_DATATYPE_TO_INPUT_MAPPING[hydra_attribute.backend_type.to_sym]}", hydra_attribute.name, options_for_input )
    elsif hydra_attribute.backend_type == "boolean"
      check_box(hydra_attribute.name, options_for_input)
    elsif hydra_attribute.backend_type == "datetime"
      calendar_date_select hydra_attribute.name, options_for_input.merge(value: object.send(hydra_attribute.name).nil? ? "" : I18n.l(object.send(hydra_attribute.name)))
    elsif hydra_attribute.backend_type == "polymorphic_association"
      select("#{hydra_attribute.name}_id", [nil] + options[:collection].map{|c| [c.send(options[:method_for_name]), c.id]}, options.except("method_for_name").except("collection")) <<
      hidden_field("#{hydra_attribute.name}_type", value: (options[:class_name] || options[:collection].first.try(:class).try(:to_s)))
    elsif hydra_attribute.backend_type == "enum"
      
      if object.is_a?(NodeBoxLibrary)
        select_values = object.class.all.map{|c| c.send(hydra_attribute.name)}.flatten.uniq || []
      else
        select_values = NodeBoxLibrary.find(object.node_box_library_id).send(hydra_attribute.name) || []
      end
      select_values = [select_values] unless select_values.is_a?(Array)

      r = ""
      if options[:with_add]
        r << button_tag(I18n.t("txt.add"), id: "#{hydra_attribute.name.parameterize}_button", type: :button, style: "float: right") <<
        text_field_tag("#{hydra_attribute.name}_new_value", "", style: "float: right") <<
        "
          <script>
          $(function(){
            $('##{hydra_attribute.name.parameterize}_button').click(function() {
                var $select = $('##{"#{hydra_attribute.name.parameterize}_select_id"}'),
                    $input = $('##{hydra_attribute.name.parameterize}_new_value'),
                    value = $.trim($input.val()),
                    $opt = $('<option />', {
                        value: value,
                        text: value
                    });
                if (!value) {
                    $input.focus();
                    return;
                }
                $opt.prop('selected', true);
                $input.val('');
                $select.append($opt).multipleSelect('refresh');
            });
            })
          
        </script>
        ".html_safe
      end
      r << select(hydra_attribute.name, select_values, options.except("method_for_name").except("collection"), {style: "width: 60%", multiple: options[:multiple], id: "#{hydra_attribute.name.parameterize}_select_id"})
      r.html_safe
    else
      "#{hydra_attribute.name} - #{hydra_attribute.backend_type}"
    end
    
  end
end
