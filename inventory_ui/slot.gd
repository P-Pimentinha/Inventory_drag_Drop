
extends PanelContainer

#resource slot will save the data of the object that was picked up
@export var resource_data: PickupInventoryResource
#resource slot will save the SLOT data of object that was picked up
@export var resource_slot: SlotData
@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var quantity_label: Label = $Label


func _ready() -> void:
	#if resource:
		#texture_rect.texture = resource.texture
	pass

func set_slot_data(slot_data: SlotData):
	resource_data = slot_data.item_data
	resource_slot = slot_data
	texture_rect.texture = resource_data.texture
	tooltip_text = "%s\n%s" % [resource_data.name, resource_data.description]
	
	if resource_slot.quantity > 1:
		quantity_label.text = "x%s" % resource_slot.quantity
		quantity_label.show()
	else:
		quantity_label.hide() 
	
	

#region Drag and Drop Logic

func _get_drag_data(at_position: Vector2) -> Variant:
	print("You got me")
	if resource_data:
		var prev = TextureRect.new()
		prev.texture = resource_data.texture
		set_drag_preview(prev)
		return {"resource_data": resource_data, "resource_slot": resource_slot, "source_node": self}
	return null
#
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true
	return false
#
func _drop_data(at_position: Vector2, data: Variant) -> void:
	var reset_slot: bool = true
	var resource_data_dropped = data["resource_data"]
	var resource_slot_dropped = data["resource_slot"]
	var source_node = data["source_node"]
	
#	swap data
	if resource_data and resource_slot:
		reset_slot = false
		source_node.resource_data = resource_data
		source_node.resource_slot = resource_slot
		source_node.update_if_swap()
	
	resource_data = resource_data_dropped
	resource_slot = resource_slot_dropped
	texture_rect.texture = resource_data.texture

	if source_node and source_node != self and reset_slot:
		source_node.clear_resource()
	

func clear_resource() -> void:
	print("Reset")
	resource_data = null
	resource_slot = null
	texture_rect.texture = null
	quantity_label = null

func update_if_swap():
	texture_rect.texture = resource_data.texture
	



#func swap_resources(origin_slot) -> void:
	#origin_slot.resource = resource
	#origin_slot.texture_rect.texture = texture_rect.texture

#endregion
