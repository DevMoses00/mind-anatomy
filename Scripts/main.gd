extends Node2D

@export_group("Character Cards")
@export var machine : AnimatedSprite2D
@export var femme : AnimatedSprite2D
@export var suave : AnimatedSprite2D
@export var offoff : AnimatedSprite2D
@export var primitive : AnimatedSprite2D

@export_group("Eye Cards")
@export var right_eye : AnimatedSprite2D
@export var left_eye : AnimatedSprite2D

@export_group("Mouth Cards")
@export var right_mouth : AnimatedSprite2D
@export var left_mouth : AnimatedSprite2D

@export_group("Choice Cards")
@export var choice_one : AnimatedSprite2D
@export var choice_two : AnimatedSprite2D
@export var choice_three : AnimatedSprite2D

@export_group("End Cards")
@export var card_one : AnimatedSprite2D
@export var card_two : AnimatedSprite2D
@export var card_three : AnimatedSprite2D
@export var card_four : AnimatedSprite2D
@export var card_five : AnimatedSprite2D
@export var card_six : AnimatedSprite2D

@export_group("Dialogue")
@export var dialogue_key : String

#for the collision choices
@onready var collisions =  get_tree().get_nodes_in_group("collisions")
# audio specific variable
var card_audio : String

# used for the choices in the game
var pick
# used to remove a specific pick from the next round of choices 
var delete_pick

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# read the dialogue JSON file
	DialogueManager.readJSON("res://Dialogue/MA_dialogue.json")
	# connect signals that'll be used in the game
	signals_connected()
	SoundManager.fade_out("Noise",1.0)
	await get_tree().create_timer(5).timeout
	SoundManager.fade_in_bgs("Whispers",5.0)
	# access the direct key
	await get_tree().create_timer(6).timeout
	SoundManager.fade_in_bgs("Ramp",2.0,0,10)
	$Whole.stop()
	await get_tree().create_timer(6).timeout
	$Whole.play()
	dialogue_go(dialogue_key)
	SoundManager.stop("Whispers")
	SoundManager.stop("Ramp")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# remember to remove this, this is to skip dialogue
	if Input.is_action_pressed("ui_down"):
		DialogueManager.skip_dialogue()

func signals_connected():
	# All the signals used will be connected here
	DialogueManager.amari_eyes_closed.connect(eyes_closed)
	DialogueManager.amari_eyes_opened.connect(eyes_opened)
	DialogueManager.talking_signaled.connect(talking)
	DialogueManager.stop_talking.connect(stop_talking)
	# signal for the card flip
	DialogueManager.card_flipped.connect(tween_flip)
	# starting the dialogue
	DialogueManager.weird_start.connect(opening_set)
	
	# welcome anatomy
	DialogueManager.welcome_signaled.connect(welcome)
	#OpeningOver
	DialogueManager.opening_over.connect(flip_choices)
	
	#Chapter1Signals
	
	#Chapter2Signals
	
	#Chapter3Signals
	
	#BrainOverride
	DialogueManager.callher_signaled.connect(call_set)
	#FacetimeHer
	DialogueManager.endgame_signaled.connect(endgame)
	#End the game
	DialogueManager.end_signaled.connect(endit)
	pass

func opening_set():
	# turn of mouth
	left_mouth.stop()
	right_mouth.stop()
	# create sound 
	SoundManager.fade_in_bgm("BG_Main",1.0)
	await get_tree().create_timer(2).timeout
	# fade out whole image
	fade_tween_out($Whole)
	# brighten background
	fade_tween_in($Backgrounds)
	# fade in splitanim
	fade_tween_in($Splitanim)
	# await
	await get_tree().create_timer(4).timeout
	# play animation
	$Backgrounds.speed = 0.9
	$Splitanim.play()
	SoundManager.play_sfx("Card1")
	await get_tree().create_timer(.3).timeout
	SoundManager.play_sfx("Card2")
	await get_tree().create_timer(.3).timeout
	SoundManager.play_sfx("Card3")
	await get_tree().create_timer(4.0).timeout
	# animation finished, fade out split anim
	fade_tween_out($Splitanim)
	# fade in cards
	fade_tween_in($Cards)
	# await and fade out music
	await get_tree().create_timer(4).timeout
	SoundManager.fade_out("BG_Main",2.0)
	# dialogue(opening)
	dialogue_go("Opening")

func fade_tween_in(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 1.0), 2)

func fade_tween_out(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 0.0), 2)


func dialogue_go(dialogue_key):
	DialogueManager.dialogue_player(dialogue_key)

func eyes_closed():
	# used to stop the eye animation to show a different emotion for Amari
	if right_eye.animation == "1":
		right_eye.play("close")
	
	left_eye.play("close")

func eyes_opened():
	# used to play the eye animation for Amari to blink on occasion
	left_eye.play("1")
	if DialogueManager.chapter == "CallHer":
		left_eye.play("1")
		return
	if right_eye.animation != "2":
		right_eye.play("1")

func tween_flip(card):
	# flips the card over with a tween
	card = get(card)
	get_card_sound()
	SoundManager.play_sfx(card_audio, 0)
	var tween = get_tree().create_tween()
	tween.tween_property(card,"scale:x",0,0.2).set_ease(Tween.EASE_IN_OUT)
	await get_tree().create_timer(0.3).timeout
	# when card face isn't visible, change the anim name
	if card.animation == "1":
		card.play("2")
	elif card.animation =="close":
		card.play("2")
	elif card.animation == "2":
		card.play("1")
	
	SoundManager.play_sfx(card_audio, 0)
	var tweenback = get_tree().create_tween()
	tweenback.tween_property(card,"scale:x",0.25,0.2).set_ease(Tween.EASE_IN_OUT)

func welcome():
	var tween = get_tree().create_tween()
	tween.tween_property($FadeNames,"modulate:a",0.39,3)
	await get_tree().create_timer(4.6).timeout
	$Names.visible = true

func flip_choices():
	# rewrite this to make this easier so I don't have to copy paste this 4 times
	if DialogueManager.chapter == "Opening":
		var array = [choice_one,choice_two,choice_three]
		var choices = ["Instagram","Videos","Internet","Lamentations"]
		DialogueManager.phase_one = true
		for card in array:
			get_card_sound()
			SoundManager.play_sfx(card_audio, 0)
			var tween = get_tree().create_tween()
			tween.tween_property(card,"scale:x",0,0.2).set_ease(Tween.EASE_IN_OUT)
			await get_tree().create_timer(0.3).timeout
			
			pick = choices.pick_random()
			print(pick)
			choices.erase(pick)
			print(choices)
			card.play(str(pick))
			
			SoundManager.play_sfx(card_audio, 0)
			var tweenback = get_tree().create_tween()
			tweenback.tween_property(card,"scale:x",0.25,0.2).set_ease(Tween.EASE_IN_OUT)
			# allow for the buttons to be selected
			for i in collisions:
				i.disabled = false
	
	if DialogueManager.chapter == "Connector_1":
		DialogueManager.phase_two = true
		var array = [choice_one,choice_two,choice_three]
		var choices = ["Instagram","Videos","Internet","Lamentations"]
		choices.erase(delete_pick)
		for card in array:
			get_card_sound()
			SoundManager.play_sfx(card_audio, 0)
			var tween = get_tree().create_tween()
			tween.tween_property(card,"scale:x",0,0.2).set_ease(Tween.EASE_IN_OUT)
			await get_tree().create_timer(0.3).timeout
			
			pick = choices.pick_random()
			print(pick)
			choices.erase(pick)
			print(choices)
			card.play(str(pick))
			
			SoundManager.play_sfx(card_audio, 0)
			var tweenback = get_tree().create_tween()
			tweenback.tween_property(card,"scale:x",0.25,0.2).set_ease(Tween.EASE_IN_OUT)
			# allow for the buttons to be selected
			for i in collisions:
				i.disabled = false

func flip_back():
	# flips all the choices cards back to amari's face
	var array = [choice_one,choice_two,choice_three]
	for card in array:
		get_card_sound()
		SoundManager.play_sfx(card_audio, 0)
		var tween = get_tree().create_tween()
		tween.tween_property(card,"scale:x",0,0.2).set_ease(Tween.EASE_IN_OUT)
		await get_tree().create_timer(0.3).timeout
		
		card.play("1")
		card.stop()
		
		SoundManager.play_sfx(card_audio, 0)
		var tweenback = get_tree().create_tween()
		tweenback.tween_property(card,"scale:x",0.25,0.2).set_ease(Tween.EASE_IN_OUT)
	
func talking(character):
	$Names/Amari.visible = false
	$Names/Machine.visible = false
	$Names/Femme.visible = false
	$Names/Suave.visible = false
	$Names/Primitive.visible = false
	$Names/Offoff.visible = false
	if character == "Amari":
		$Names/Amari.visible = true
		if left_mouth.animation == "1":
				left_mouth.play()
				if DialogueManager.chapter == "CallHer":
					right_mouth.stop()
				else: 
					right_mouth.play()
		else:
			right_mouth.play()
	else:
		left_mouth.stop()
		right_mouth.stop()
	
	if character == "Jeanne":
		right_mouth.play()

	if character == "Machine":
		machine.play("2")
		$Names/Machine.visible = true
	if character == "Femme":
		femme.play("2")
		$Names/Femme.visible = true
	if character == "Suave":
		suave.play("2")
		$Names/Suave.visible = true
	if character == "Primitive":
		primitive.play("2")
		$Names/Primitive.visible = true
	if character == "Offoff":
		offoff.play("2")
		$Names/Offoff.visible = true

func stop_talking():
	left_mouth.stop()
	right_mouth.stop()

# Audio Specific Funtion
func get_card_sound():
	var array = ["Card1","Card2","Card3","Card4","Card5"]
	card_audio = str(array.pick_random())
	print(card_audio)

# FOR CHOICE ONE
func _on_choice_area_mouse_entered() -> void:
	var card = choice_one
	var tween = get_tree().create_tween()
	tween.tween_property(card,"scale",Vector2(0.27,0.27),0.2)
func _on_choice_area_mouse_exited() -> void:
	var card = choice_one
	var tween = get_tree().create_tween()
	tween.tween_property(card,"scale",Vector2(0.25,0.25),0.2)
func _on_choice_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_pressed("select"):
		for i in collisions:
			i.disabled = true
		if choice_one.animation == "Instagram":
			dialogue_go("Instagram")
		elif choice_one.animation == "Videos":
			dialogue_go("Videos")
		elif choice_one.animation == "Lamentations":
			dialogue_go("Lamentations")
		elif choice_one.animation == "Internet":
			dialogue_go("Internet")
		await get_tree().create_timer(1).timeout
		flip_back()
		delete_pick = DialogueManager.chapter 

# FOR CHOICE TWO
func _on_choice_area_2_mouse_entered() -> void:
	var card = choice_two
	var tween = get_tree().create_tween()
	tween.tween_property(card,"scale",Vector2(0.27,0.27),0.2)
func _on_choice_area_2_mouse_exited() -> void:
	var card = choice_two
	var tween = get_tree().create_tween()
	tween.tween_property(card,"scale",Vector2(0.25,0.25),0.2)
func _on_choice_area_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_pressed("select"):
		for i in collisions:
			i.disabled = true
		if choice_two.animation == "Instagram":
			dialogue_go("Instagram")
		elif choice_two.animation == "Videos":
			dialogue_go("Videos")
		elif choice_two.animation == "Lamentations":
			dialogue_go("Lamentations")
		elif choice_two.animation == "Internet":
			dialogue_go("Internet")
		await get_tree().create_timer(1).timeout
		flip_back()
		delete_pick = DialogueManager.chapter 

# FOR CHOICE THREE
func _on_choice_area_3_mouse_entered() -> void:
	var card = choice_three
	var tween = get_tree().create_tween()
	tween.tween_property(card,"scale",Vector2(0.27,0.27),0.2)
func _on_choice_area_3_mouse_exited() -> void:
	var card = choice_three
	var tween = get_tree().create_tween()
	tween.tween_property(card,"scale",Vector2(0.25,0.25),0.2)
func _on_choice_area_3_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_pressed("select"):
		for i in collisions:
			i.disabled = true
		if choice_three.animation == "Instagram":
			dialogue_go("Instagram")
		elif choice_three.animation == "Videos":
			dialogue_go("Videos")
		elif choice_three.animation == "Lamentations":
			dialogue_go("Lamentations")
		elif choice_three.animation == "Internet":
			dialogue_go("Internet")
		await get_tree().create_timer(1).timeout
		flip_back()
		delete_pick = DialogueManager.chapter 


func call_set():
	# get rid of the MND names
	fade_tween_out($Names)
	fade_tween_out($FadeNames)
	machine.play("1")
	femme.play("1")
	femme.stop()
	suave.play("1")
	offoff.play("1")
	primitive.play("1")
	# play a ring call sound
	SoundManager.stop("BG_Reg")
	SoundManager.fade_in_bgm("BG_Main",2.0)
	SoundManager.play_sfx("Cell_Ring")
	#tween in all of Jeanne's cards
	await get_tree().create_timer(4).timeout
	SoundManager.stop("Cell_Ring")
	flip_jeanne()
	await get_tree().create_timer(7).timeout
	SoundManager.fade_out("BG_Main",2.0)
	dialogue_go("CallHer")
	
func flip_jeanne():
	var array = [card_one,card_two,card_three,card_four,card_five,card_six]
	for card in array:
		get_card_sound()
		SoundManager.play_sfx(card_audio, 0)
		var tween = get_tree().create_tween()
		tween.tween_property(card,"scale:x",0,0.2).set_ease(Tween.EASE_IN_OUT)
		await get_tree().create_timer(0.3).timeout
		
		card.play("Jeanne")
		if card == card_six:
			card.stop()
		
		SoundManager.play_sfx(card_audio, 0)
		var tweenback = get_tree().create_tween()
		tweenback.tween_property(card,"scale:x",0.25,0.2).set_ease(Tween.EASE_IN_OUT)

func endgame():
	left_mouth.stop()
	right_mouth.stop()
	# play phone end sound
	SoundManager.play_sfx("EndCall")
	# flip all the cards back to Amari
	var array = [card_one,card_two,card_three,card_four,card_five,card_six]
	for card in array:
		get_card_sound()
		SoundManager.play_sfx(card_audio, 0)
		var tween = get_tree().create_tween()
		tween.tween_property(card,"scale:x",0,0.2).set_ease(Tween.EASE_IN_OUT)
		await get_tree().create_timer(0.3).timeout
		
		card.play("1")
		if card == card_six:
			card.stop()
		
		SoundManager.play_sfx(card_audio, 0)
		var tweenback = get_tree().create_tween()
		tweenback.tween_property(card,"scale:x",0.25,0.2).set_ease(Tween.EASE_IN_OUT)
	
	await get_tree().create_timer(3).timeout
	
	# start main sound
	
	# create sound 
	SoundManager.fade_in_bgm("BG_Main",1.0)
	await get_tree().create_timer(2).timeout
	# fade out the cards
	fade_tween_out($Cards)
	# fade in the split anim
	fade_tween_in($Splitanim)
	# wait and play it backwards
	await get_tree().create_timer(4).timeout
	$Splitanim.play_backwards("default")
	# Fade out the split anim
	SoundManager.play_sfx("Card1")
	await get_tree().create_timer(.3).timeout
	SoundManager.play_sfx("Card2")
	await get_tree().create_timer(.3).timeout
	SoundManager.play_sfx("Card3")
	await get_tree().create_timer(4.0).timeout
	# animation finished, fade out split anim
	fade_tween_out($Splitanim)
	# Fade in the Whole image
	fade_tween_in($Whole)
	# Fade the background to 0.62 alpha 
	var tween2 = get_tree().create_tween()
	$Backgrounds.speed = 0
	tween2.tween_property($Backgrounds,"modulate:a",0.62,2.0)
	# wait and call the final key
	await get_tree().create_timer(4).timeout
	SoundManager.fade_out("BG_Main",2.0)
	await get_tree().create_timer(6).timeout
	# dialogue(opening)
	dialogue_go("End")

func endit():
	await get_tree().create_timer(2).timeout
	$Backgrounds.visible = false
	$Whole.visible = false
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/end.tscn")
