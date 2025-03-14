extends Node

# for the JSON file
var finish 

func readJSON(json_file_path):
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	finish = json.parse_string(content)
	return finish

@onready var text_box_scene = preload("res://Scenes/text_box.tscn")

var dialogue_lines
var current_line_index = 0

var text_box
var text_box_position: Vector2
var text_box_tween : Tween

var is_dialogue_active = false
var can_advance_line = false


# for the card flips
# put card flip signals here
signal machine_flipped
signal femme_flipped
signal suave_flipped
signal offoff_flipped
signal primitive_flipped

# for the characters talking
signal amari_talking
signal machine_talking
signal femme_talking
signal suave_talking
signal offoff_talking
signal primitive_talking


# stop all talking
signal stop_talking


# signals for extra camera affects
signal camera_zoom_signaled
signal camera_reset_signaled
signal endzoom_signaled

# which story chapter we're in
var chapter : String
# list chapters here


var character_path : String



func _ready() -> void:
	pass

# Create a new dialogue start function that takes a specific set of dialogue lines
func dialogue_player(line_key):
	if is_dialogue_active:
		return
	
	# change the chapter variable to the line key title 
	chapter = line_key
	
	dialogue_lines = finish[line_key]
	
	# if this is a regular dialogue line
	_show_text_box()
	is_dialogue_active = true

func _show_text_box():
	# for stage directions
	if dialogue_lines[current_line_index].begins_with("Time:"):
		print("this is working")
		# removes everything but the number in this line
		var timeNum = int(dialogue_lines[current_line_index].to_int())
		print(timeNum)
		# use it to create a timer based on that int num
		await get_tree().create_timer(timeNum).timeout 
		await get_tree().create_timer(1).timeout
		current_line_index += 1
		_show_text_box()
		return
	
	if dialogue_lines[current_line_index].begins_with("Zoom"):
		print("camera zoom")
		# send a signal to tween the camera and zoom closer
		camera_zoom_signaled.emit()
		can_advance_line = false
		await get_tree().create_timer(0.2).timeout
		current_line_index += 1 
		_show_text_box()
		return
	
	if dialogue_lines[current_line_index].begins_with("Reset"):
		print("camera reset")
		# send a signal to tween the camera and zoom closer
		camera_reset_signaled.emit()
		can_advance_line = false
		await get_tree().create_timer(0.2).timeout
		current_line_index += 1 
		_show_text_box()
		return
	
	
	if dialogue_lines[current_line_index].begins_with("Endzoom"):
		print("engage end protocol")
		# send a signal to tween the camera and zoom closer
		endzoom_signaled.emit()
		can_advance_line = false
		await get_tree().create_timer(0.2).timeout
		current_line_index += 1 
		_show_text_box()
		return
		
	
	if dialogue_lines[current_line_index].begins_with("FMachine"):
		print("flip machine card")
		# send a signal to flip card
		machine_flipped.emit()
		can_advance_line = false
		await get_tree().create_timer(0.2).timeout
		current_line_index += 1 
		_show_text_box()
		return
	
	if dialogue_lines[current_line_index].begins_with("FFemme"):
		print("flip femme compatisante card")
		# send a signal to flip card
		femme_flipped.emit()
		can_advance_line = false
		await get_tree().create_timer(0.2).timeout
		current_line_index += 1 
		_show_text_box()
		return
	
	if dialogue_lines[current_line_index].begins_with("FSuave"):
		print("flip alter ego suave card")
		# send a signal to flip card
		suave_flipped.emit()
		can_advance_line = false
		await get_tree().create_timer(0.2).timeout
		current_line_index += 1 
		_show_text_box()
		return
	
	if dialogue_lines[current_line_index].begins_with("FOff"):
		print("flip off off broadway card")
		# send a signal to flip card
		offoff_flipped.emit()
		can_advance_line = false
		await get_tree().create_timer(0.2).timeout
		current_line_index += 1 
		_show_text_box()
		return
	
	if dialogue_lines[current_line_index].begins_with("FPrim"):
		print("flip primitive ant card")
		# send a signal to flip card
		offoff_flipped.emit()
		can_advance_line = false
		await get_tree().create_timer(0.2).timeout
		current_line_index += 1 
		_show_text_box()
		return
	
	# Audio Commands
	if dialogue_lines[current_line_index].begins_with("Stop"):
		print("stop audio")
		# Sound Manager stop 
		# ADD SOUND STUFF HERE
		can_advance_line = false
		await get_tree().create_timer(0.2).timeout
		current_line_index += 1 
		_show_text_box()
		return
	
		
	if dialogue_lines[current_line_index].begins_with("Template"):
		print("play sounds")
		# Sound Manager play lager G
		#SoundManager.fade_in_mfx(" ",2.0)
		#SoundManager.fade_out(" ",22.0)
		can_advance_line = false
		await get_tree().create_timer(0.2).timeout
		current_line_index += 1 
		_show_text_box()
		return
	
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box)
	
	if dialogue_lines[current_line_index].begins_with("A:"):
		# Play an Amari sound
		#SoundManager.play_sfx("Amari")
		text_box.global_position = Vector2(150, -120)
		amari_talking.emit()
	
	elif dialogue_lines[current_line_index].begins_with("M:"):
		# Play the machine sound
		#SoundManager.play_sfx("Machine")
		text_box.global_position = Vector2(-150, -140)
		machine_talking.emit()
	
	elif dialogue_lines[current_line_index].begins_with("F:"):
		# Play femme compasitante sound
		#SoundManager.play_sfx("Femme")
		# change position depending on what a name of a variable is
		text_box.global_position = Vector2(200, 300)
		femme_talking.emit()
	
	elif dialogue_lines[current_line_index].begins_with("S:"):
		# Play alter ego suave sound
		#SoundManager.play_sfx("Suave")
		# change position depending on what a name of a variable is
		text_box.global_position = Vector2(200, 300)
		suave_talking.emit()
	
	elif dialogue_lines[current_line_index].begins_with("P:"):
		# Play primitive ant sound
		#SoundManager.play_sfx("Prim")
		# change position depending on what a name of a variable is
		text_box.global_position = Vector2(200, 300)
		primitive_talking.emit()
	
	elif dialogue_lines[current_line_index].begins_with("O:"):
		# Play off off broadway sound
		#SoundManager.play_sfx("Off")
		# change position depending on what a name of a variable is
		text_box.global_position = Vector2(200, 300)
		offoff_talking.emit()
	
	text_box_tween = get_tree().create_tween().set_loops()
	# tween animation
	text_box_tween.tween_property(text_box, "scale",Vector2(1.01,1.01),2)
	text_box_tween.tween_property(text_box, "scale",Vector2(.98,.98),2)
	
	text_box.display_text(dialogue_lines[current_line_index])
	
	can_advance_line = false

func _on_text_box_finished_displaying():
		can_advance_line = true
		

func _unhandled_input(event: InputEvent) -> void:
	if (
		event.is_action_pressed("advance_dialogue") &&
		is_dialogue_active &&
		can_advance_line
	):
		if is_instance_valid(text_box):
			text_box_tween.kill() # kill the tween loop
			text_box.queue_free()      
		# have their mouths stop moving
		stop_talking.emit()
		
		current_line_index += 1
		
		
		if current_line_index >= dialogue_lines.size():
			is_dialogue_active = false
			current_line_index = 0
			# send a signal saying that this line is over and a new action must occur?
			if chapter == "Opening":
				pass
				#opening_over.emit()
		
		_show_text_box()


func skip_dialogue():
	current_line_index = int(dialogue_lines.size())
	text_box.queue_free()
	text_box_tween.kill()
	# have their mouths stop moving
	stop_talking.emit()
	is_dialogue_active = false
	current_line_index = 0
	# send a signal saying that this line is over and a new action must occur?
	#choice_make.emit()
	return
