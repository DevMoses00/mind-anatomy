extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer

@export_group("Text Boxes")
@export var femme : NinePatchRect
@export var machine : NinePatchRect
@export var offoff : NinePatchRect
@export var primitive : NinePatchRect
@export var suave : NinePatchRect
@export var jeanne : NinePatchRect
const MAX_WIDTH = 500

var text = ""
var letter_index = 0

# how many seconds will pass between each letter character displayed
var letter_time = 0.0000000001
var space_time = 0.1
var punctuation_time = 0.2

signal finished_displaying()

func display_text(text_to_display: String):
	
	# dialogue tags
	# for Machine
	if text_to_display.begins_with("M: "):
		text_to_display = text_to_display.trim_prefix("M: ")
	elif text_to_display.begins_with("A: "):
		text_to_display = text_to_display.trim_prefix("A: ")
	# for Jeanne
	elif text_to_display.begins_with("J: "):
		text_to_display = text_to_display.trim_prefix("J: ")
	# for Femme
	elif text_to_display.begins_with("F: "):
		text_to_display = text_to_display.trim_prefix("F: ")
	# for Prim
	elif text_to_display.begins_with("P: "):
		text_to_display = text_to_display.trim_prefix("P: ")
	# for Suave
	elif text_to_display.begins_with("S: "):
		text_to_display = text_to_display.trim_prefix("S: ")
	# for OffOff
	elif text_to_display.begins_with("O: "):
		text_to_display = text_to_display.trim_prefix("O: ")
	
	text = text_to_display
	label.text = text_to_display # label expands to the full width of the text
	
	if text.length() > 3:
		await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	# resizing all the other character text boxes
	machine.custom_minimum_size.x = min(size.x, MAX_WIDTH)
	femme.custom_minimum_size.x = min(size.x, MAX_WIDTH)
	offoff.custom_minimum_size.x = min(size.x, MAX_WIDTH)
	primitive.custom_minimum_size.x = min(size.x, MAX_WIDTH)
	suave.custom_minimum_size.x = min(size.x, MAX_WIDTH)
	jeanne.custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized # wait for x resize
		await resized # wait for y resize
		custom_minimum_size.y = size.y
		
		# resizing all the other character text boxes
		machine.custom_minimum_size.y = size.y
		femme.custom_minimum_size.y = size.y
		offoff.custom_minimum_size.y = size.y
		primitive.custom_minimum_size.y = size.y
		suave.custom_minimum_size.y = size.y
		jeanne.custom_minimum_size.y = size.y
		
	# POSITIONING - NOT SURE I NEED THIS
	global_position.x -= (size.x / 2) 
	global_position.y -= (size.y + 24) 
	
	label.text = ""
	_display_letter()

func _display_letter():
	label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return
	
	# if there are still letter characters to display
	match text[letter_index]:
		"!", ".", ",", "?","-":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
			# play a sound every time there is a space
			var sfx_standard = ["Amari1","Amari2","Amari3"].pick_random()
			SoundManager.play_sfx(sfx_standard,0,-15)
		_:
			timer.start(letter_time)

func _on_letter_display_timer_timeout() -> void:
	_display_letter()
