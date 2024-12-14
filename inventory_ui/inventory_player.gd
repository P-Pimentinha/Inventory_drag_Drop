extends PanelContainer

const SLOT = preload("res://inventory_ui/Slot.tscn")
@onready var grid_container: GridContainer = $GridContainer

func _ready() -> void:
	const PLAYER_INVENTORY = preload("res://inventory_data/inventories/player_inventory/player_inventory.tres")
	var data_slots = PLAYER_INVENTORY.slot_datas
	populate_grid(data_slots)
	
	
func populate_grid(slot_datas: Array[SlotData]) -> void:
	clear_item_grid()
		
	for slot_data in slot_datas:
		var slot = SLOT.instantiate()
		grid_container.add_child(slot)
		
	
		if slot_data:
			slot.set_slot_data(slot_data)
		#if slot_data:
			#slot.set_slot_data(slot_data)
		
		
	
func clear_item_grid() -> void:
	for child in grid_container.get_children():
		child.queue_free()

func add_slot_to_grid(slot_data: SlotData) -> void:
	print(slot_data)
	#var slot = SLOT.instantiate()
	#grid_container.add_child(slot)
	#
	## Set the slot data if it exists
	#if slot_data:
		#slot.set_slot_data(slot_data)
