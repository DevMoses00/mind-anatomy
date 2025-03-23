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

# audio specific variable
var card_audio : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# read the dialogue JSON file
	DialogueManager.readJSON("res://Dialogue/MA_dialogue.json")
	# connect signals that'll be used in the game
	signals_connected()
	# access the direct key
	await get_tree().create_timer(1).timeout
	
	dialogue_go(dialogue_key)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func signals_connected():
	# All the signals used will be connected here
	DialogueManager.amari_eyes_closed.connect(eyes_closed)
	DialogueManager.amari_eyes_opened.connect(eyes_opened)
	# signal for the card flip
	DialogueManager.card_flipped.connect(tween_flip)
	# starting the dialogue
	pass

func dialogue_go(dialogue_key):
	DialogueManager.dialogue_player(dialogue_key)

func eyes_closed():
	# used to stop the eye animation to show a different emotion for Amari
	right_eye.stop()
	left_eye.stop()

func eyes_opened():
	# used to play the eye animation for Amari to blink on occasion
	right_eye.play()
	left_eye.play()

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
	elif card.animation == "2":
		card.play("1")
	
	SoundManager.play_sfx(card_audio, 0)
	var tweenback = get_tree().create_tween()
	tweenback.tween_property(card,"scale:x",0.25,0.2).set_ease(Tween.EASE_IN_OUT)


# Audio Specific Funtion
func get_card_sound():
	var array = ["Card1","Card2","Card3","Card4","Card5"]
	card_audio = str(array.pick_random())
	print(card_audio)
