extends Control


const Response := preload("res://input/Response.tscn")
const InputResponse := preload("res://input/InputResponse.tscn")

export(int) var max_lines_remembered := 30

var max_scroll_length := 0.0

onready var command_processor := $CommandProcessor
onready var history_rows := $Background/MarginContainer/Rows/GameInfo/Scroll/HistoryRows
onready var scroll := $Background/MarginContainer/Rows/GameInfo/Scroll
onready var scrollbar: VScrollBar = scroll.get_v_scrollbar()
onready var room_manager: Node = $RoomManager
onready var player = $Player


func _ready() -> void:
	scrollbar.connect("changed", self, "handle_scrollbar_changed")
	max_scroll_length = scrollbar.max_value
	create_response("Welcome to the retro text adventure! You can type 'help' to see the available commands.")
	var starting_room_response: String = command_processor.initialize(room_manager.get_child(0), player) # move player to starting room
	create_response(starting_room_response)


func handle_scrollbar_changed() -> void:
	if max_scroll_length != scrollbar.max_value:  # only scroll on new user input, not when user manually scrolls
		max_scroll_length = scrollbar.max_value
		scroll.scroll_vertical = max_scroll_length # scroll the vertical scrollbar to the bottom whenever user enters input


func _on_Input_text_entered(new_text: String) -> void:
	if new_text.empty():
		return

	var input_response := InputResponse.instance()
	var response = command_processor.process_command(new_text)
	input_response.set_text(new_text, response)
	add_response(input_response)


func create_response(reponse_text: String) -> void:
	var response := Response.instance()
	response.text = reponse_text
	add_response(response)


func add_response(response: Control) -> void:
	history_rows.add_child(response)
	delete_history_beyond_limit()


func delete_history_beyond_limit() -> void:
	if history_rows.get_child_count() > max_lines_remembered:
		var rows_to_delete: int = history_rows.get_child_count() - max_lines_remembered
		for i in range(rows_to_delete):
			history_rows.get_child(i).queue_free()
