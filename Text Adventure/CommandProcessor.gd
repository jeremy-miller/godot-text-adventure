extends Node


var current_room: GameRoom
var player: Player


func initialize(starting_room: GameRoom, player: Player) -> String:
	self.player = player
	return change_room(starting_room)


func process_command(input: String) -> String:
	var words: Array = input.split(" ", false)
	var first_word: String = words[0].to_lower()
	var second_word: String = ""
	if words.size() > 1:
		second_word = words[1].to_lower()
	match first_word:
		"help":
			return help()
		"go":
			return go(second_word)
		"take":
			return take(second_word)
		"drop":
			return drop(second_word)
		"inventory":
			return inventory()
		"use":
			return use(second_word)
		_:
			return "Unrecognized command - please try again"


func help() -> String:
	return "You can use these commands: go [location], take [item], drop [item], inventory, use [item], help"


func go(direction: String) -> String:
	if direction.empty():
		return "Go where?"
	if current_room.exits.keys().has(direction):
		var exit: Exit = current_room.exits[direction]
		if exit.is_door_locked(current_room):
			return "That exit is currently locked!"
		else:
			var change_response: String = change_room(exit.get_other_room(current_room))
			return PoolStringArray(["You go %s." % direction, change_response]).join("\n")
	else:
		return "This room has no exit in that direction!"


func take(item: String) -> String:
	if item.empty():
		return "Take what?"
	for i in current_room.items:
		if item.to_lower() == i.item_name.to_lower():
			current_room.remove_item(i)
			player.take_item(i)
			return "You take the " + item
	return "There is no item like that in this room."


func drop(item: String) -> String:
	if item.empty():
		return "Drop what?"
	for i in player.inventory:
		if item.to_lower() == i.item_name.to_lower():
			player.drop_item(i)
			current_room.add_item(i)
			return "Your drop the " + item
	return "You don't have that item."


func inventory() -> String:
	return player.get_inventory_list()


func use(item: String) -> String:
	if item.empty():
		return "Use what?"
	for i in player.inventory:
		if item.to_lower() == i.item_name.to_lower():
			match i.item_type:
				Types.ItemTypes.KEY:
					for exit in current_room.exits.values():
						if exit.room_1 == i.use_value or exit.room_2 == i.use_value:
							exit.is_locked = false
							player.drop_item(i)
							return "You used %s to unlock a door to %s" % [item, exit.room_2.room_name]
					return "That item does not unlock any doors in this room."
				_:
					return "Error - tried to use an item with an invalid type."
	return "You don't have that item."


func change_room(new_room: GameRoom) -> String:
	current_room = new_room
	return new_room.get_full_description()
