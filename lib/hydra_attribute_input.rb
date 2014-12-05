module HydraAttributeInput
  BASIC_DATATYPE_TO_INPUT_MAPPING = {
    text: :text_area,
    string: :text_field,
    integer: :number_field,
    float: :number_field,
    decimal: :number_field,
    datetime: :text_field
  }.freeze
  
end

require 'action_view/helpers/hydra_attribute_input.rb'

