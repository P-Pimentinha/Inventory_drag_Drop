
extends PanelContainer

#resource slot will save the data of the object that was picked up
@export var resource_data: PickupInventoryResource
#resource slot will save the SLOT data of object that was picked up
@export var resource_slot: SlotData

#node references
@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var quantity_label: Label = $Label


#region Setup Slot when first created
func set_slot_data(slot_data: SlotData):
	resource_data = slot_data.item_data
	resource_slot = slot_data
	updata_slot_display()
	
#endregion
	

#region Drag and Drop Logic

func _get_drag_data(at_position: Vector2) -> Variant:
	if resource_data:
		var drag_preview = TextureRect.new()
		drag_preview.texture = resource_data.texture
		set_drag_preview(drag_preview)
		return {
			"resource_data": resource_data, 
			"resource_slot": resource_slot, 
			"source_node": self
			}
	return null
#
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data.has("resource_data") and data.has("resource_slot")
#
func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data.has("resource_data") and data.has("resource_slot"):
		var source_node = data.get("source_node")
		swap_or_assign_resources(data["resource_data"], data["resource_slot"], source_node)
	
# Handle swapping or assigning resources during a drop
func swap_or_assign_resources(new_data: PickupInventoryResource, new_slot: SlotData, source_node: Node) -> void:
	var reset_source = true

	# Swap resources if this slot already has data
	if resource_data and resource_slot:
		reset_source = false
		source_node.assign_resource(resource_data, resource_slot)
	
	# Assign new resources to this slot
	assign_resource(new_data, new_slot)

	# Clear the source slot if necessary
	if source_node and source_node != self and reset_source:
		source_node.clear_resource()

# Assign resources to the slot and update the display
func assign_resource(new_data: PickupInventoryResource, new_slot: SlotData) -> void:
	resource_data = new_data
	resource_slot = new_slot
	updata_slot_display()



#endregion
#region helper functions

func updata_slot_display() -> void:
	if resource_data:
		texture_rect.texture = resource_data.texture
		tooltip_text = "%s\n%s" % [resource_data.name, resource_data.description]
	else:
		texture_rect.texture = null
		tooltip_text = ""

	if resource_slot and resource_slot.quantity > 1:
		quantity_label.text = "x%s" % resource_slot.quantity
		quantity_label.show()
	else:
		quantity_label.hide()

func clear_resource() -> void:
	resource_data = null
	resource_slot = null
	updata_slot_display()
	#texture_rect.texture = null
	#quantity_label = null

func update_if_swap():
	texture_rect.texture = resource_data.texture
	quantity_label.text = "x%s" % resource_slot.quantity
	quantity_label.show()
#endregion
