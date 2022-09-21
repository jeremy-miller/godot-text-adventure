extends Node


func _ready() -> void:
	$HouseRoom.connect_exit_unlocked("east", $OutsideRoom)

	var key := Item.new()
	key.initialize("key", Types.ItemTypes.KEY)
	key.use_value = $ShedRoom
	$OutsideRoom.add_item(key)
	$OutsideRoom.connect_exit_locked("north", $ShedRoom)
