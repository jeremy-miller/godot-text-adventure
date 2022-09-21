extends Node
class_name Player


var inventory: Array = []


func take_item(item: Item) -> void:
	inventory.append(item)


func drop_item(item: Item) -> void:
	inventory.erase(item)


func get_inventory_list() -> String:
	if inventory.size() == 0:
		return "You don't currently have anything."
	var inventory_string := ""
	for item in inventory:
		inventory_string += " " + item.item_name
	return "Inventory: " + inventory_string
