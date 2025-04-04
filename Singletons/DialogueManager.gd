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
var text_box_position : Vector2
var text_box_tween : Tween

var is_dialogue_active = false
var can_advance_line = false


# for the card flips
# A card flip signal that carries the specific argument for which card to flip
signal card_flipped

# welcome anatomy
signal welcome_signaled

# for the characters talking
signal talking_signaled
signal amari_talking
signal machine_talking
signal femme_talking
signal suave_talking
signal offoff_talking
signal primitive_talking

# for Amari closing his eyes
signal amari_eyes_closed
signal amari_eyes_opened

# stop all talking
signal stop_talking


# signals for extra camera affects
signal camera_zoom_signaled
signal camera_reset_signaled
signal endzoom_signaled

# which story chapter we're in
var chapter : String
# list chapters here
signal weird_start
signal opening_over
var phase_one: bool = false
var phase_two: bool = false
signal callher_signaled
signal endgame_signaled
signal end_signaled

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
		stop_talking.emit()
		var timeNum = int(dialogue_lines[current_line_index].to_int())
		print(timeNum)
		can_advance_line = false
		# use it to create a timer based on that int num
		await get_tree().create_timer(timeNum).timeout 
		await get_tree().create_timer(1).timeout
		current_line_index += 1
		_show_text_box()
		return
		
	if dialogue_lines[current_line_index].begins_with("AEyeClose"):
		print("eyes closed")
		# send a signal to change the animation to close his eyes
		amari_eyes_closed.emit()
		can_advance_line = false
		await get_tree().create_timer(0.2).timeout
		current_line_index += 1 
		_show_text_box()
		return
	
	if dialogue_lines[current_line_index].begins_with("AEyeOpen"):
		print("eyes open")
		# send a signal to change the animation to close his eyes
		amari_eyes_opened.emit()
		can_advance_line = false
		await get_tree().create_timer(0.2).timeout
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
		card_flipped.emit("machine")
		can_advance_line = false
		await get_tree().create_timer(0.6).timeout
		current_line_index += 1 
		_show_text_box()
		return
	
	if dialogue_lines[current_line_index].begins_with("FFemme"):
		print("flip femme compatisante card")
		# send a signal to flip card
		card_flipped.emit("femme")
		can_advance_line = false
		await get_tree().create_timer(0.6).timeout
		current_line_index += 1 
		_show_text_box()
		return
	
	if dialogue_lines[current_line_index].begins_with("FSuave"):
		print("flip alter ego suave card")
		# send a signal to flip card
		card_flipped.emit("suave")
		can_advance_line = false
		await get_tree().create_timer(0.6).timeout
		current_line_index += 1 
		_show_text_box()
		return
	
	if dialogue_lines[current_line_index].begins_with("FOff"):
		print("flip off off broadway card")
		# send a signal to flip card
		card_flipped.emit("offoff")
		can_advance_line = false
		await get_tree().create_timer(0.6).timeout
		current_line_index += 1 
		_show_text_box()
		return
	
	if dialogue_lines[current_line_index].begins_with("FPrim"):
		print("flip primitive ant card")
		# send a signal to flip card
		card_flipped.emit("primitive")
		can_advance_line = false
		await get_tree().create_timer(0.6).timeout
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
		
	if dialogue_lines[current_line_index].begins_with("Welcome"):
		print("play bg sound")
		# Sound Manager play bg reg
		welcome_signaled.emit()
		SoundManager.fade_in_bgm("BG_Reg",2.0)
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
		if chapter == "CallHer":
			text_box.global_position = Vector2(-436, 360)
			talking_signaled.emit("Amari")
		else:
			text_box.global_position = Vector2(430, 360)
			talking_signaled.emit("Amari")
	
	elif dialogue_lines[current_line_index].begins_with("M:"):
		# Play the machine sound
		var machine = ["Machine1","Machine2","Machine3"].pick_random()
		SoundManager.play_sfx(machine)
		text_box.machine.visible = true 
		text_box.global_position = Vector2(-436, -160)
		talking_signaled.emit("Machine")
	
	elif dialogue_lines[current_line_index].begins_with("F:"):
		# Play femme compasitante sound
		var femme = ["Femme1","Femme2","Femme3"].pick_random()
		SoundManager.play_sfx(femme)
		text_box.femme.visible = true 
		# change position depending on what a name of a variable is
		text_box.global_position = Vector2(-436, 360)
		talking_signaled.emit("Femme")
	
	elif dialogue_lines[current_line_index].begins_with("S:"):
		# Play alter ego suave sound
		var suave = ["Suave1","Suave2","Suave3"].pick_random()
		SoundManager.play_sfx(suave)
		text_box.suave.visible = true 
		# change position depending on what a name of a variable is
		text_box.global_position = Vector2(450, 100)
		talking_signaled.emit("Suave")
	
	elif dialogue_lines[current_line_index].begins_with("P:"):
		# Play primitive ant sound
		var primitive = ["Primitive1","Primitive2","Primitive3"].pick_random()
		SoundManager.play_sfx(primitive)
		text_box.primitive.visible = true 
		# change position depending on what a name of a variable is
		text_box.global_position = Vector2(-656, 100)
		talking_signaled.emit("Primitive")
	
	elif dialogue_lines[current_line_index].begins_with("O:"):
		# Play off off broadway sound
		var offoff = ["Offoff1","Offoff2","Offoff3"].pick_random()
		SoundManager.play_sfx(offoff)
		text_box.offoff.visible = true 
		# change position depending on what a name of a variable is
		text_box.global_position = Vector2(680, -160)
		talking_signaled.emit("Offoff")
	
	elif dialogue_lines[current_line_index].begins_with("J:"):
		# Play femme compasitante sound
		text_box.jeanne.visible = true
		# change position depending on what a name of a variable is
		text_box.global_position = Vector2(430, 360)
		talking_signaled.emit("Jeanne")
	
	text_box_tween = get_tree().create_tween().set_loops()
	# tween animation
	text_box_tween.tween_property(text_box, "scale",Vector2(1.01,1.01),0.2)
	text_box_tween.tween_interval(1.6)
	text_box_tween.tween_property(text_box, "scale",Vector2(.99,.99),0.2)
	
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
			if chapter == "Weird":
				weird_start.emit()
			elif chapter == "Opening":
				opening_over.emit()
			elif chapter == "Connector_1":
				opening_over.emit()
			elif  chapter == "BrainOverride":
				callher_signaled.emit()
			elif  chapter == "CallHer":
				endgame_signaled.emit()
			elif chapter == "End":
				end_signaled.emit()
			elif phase_two == true:
				dialogue_player("BrainOverride")
			elif phase_one == true:
				dialogue_player("Connector_1")
			return
		
		_show_text_box()


func skip_dialogue():
	current_line_index = int(dialogue_lines.size())
	#text_box.queue_free()
	#text_box_tween.kill()
	# have their mouths stop moving
	stop_talking.emit()
	# send a signal saying that this line is over and a new action must occur?
	#choice_make.emit()
	return
