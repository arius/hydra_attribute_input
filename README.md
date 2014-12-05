hydra_attribute_input
=====================

Dynamic input field for hydra attribute

Example
```ruby    
<% @object.class.hydra_attributes.each do |attribute| %>
    <tr>
      <td class="label-cell"><%= attribute.name %></td>
      <td class="content-cell"><%= f.hydra_attribute_input attribute %></td>
    </tr>
<% end %>
end
```
