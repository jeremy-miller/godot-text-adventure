extends Resource
class_name Item


export(String) var item_name := "Item Name"
export(Types.ItemTypes) var item_type := Types.ItemTypes.KEY

var use_value = null # dynamically-typed variable used by items to convey their use


func initialize(item_name: String, item_type: int) -> void: # can't use "enum" as type hint
	self.item_name = item_name
	self.item_type = item_type
