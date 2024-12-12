#extends TextureRect
#
#func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	#return true
	#return false
#
#func _drop_data(at_position: Vector2, data: Variant) -> void:
	#data.get_parent().remove_child(data)
	#add_child(data)
extends PanelContainer

@export var resource: Pickup_Inventory_Resource
@onready var texture_rect: TextureRect = $TextureRect

func _ready() -> void:
	if resource:
		texture_rect.texture = resource.texture

func _get_drag_data(at_position: Vector2) -> Variant:
	if resource:
		var prev = TextureRect.new()
		prev.texture = resource.texture
		set_drag_preview(prev)
		return {"resource": resource, "source_node": self}
	return null

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true
	return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var reset_slot: bool = true
	var resource_dropped = data["resource"]
	var source_node = data["source_node"]
	
#	swap data
	if resource:
		reset_slot = false
		source_node.resource = resource
		source_node.update_if_swap()
	
	resource = resource_dropped
	texture_rect.texture = resource.texture

	if source_node and source_node != self and reset_slot:
		source_node.clear_resource()
	

func clear_resource() -> void:
	resource = null
	texture_rect.texture = null

func update_if_swap():
	texture_rect.texture = resource.texture
#func swap_resources(origin_slot) -> void:
	#origin_slot.resource = resource
	#origin_slot.texture_rect.texture = texture_rect.texture
