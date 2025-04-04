extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.fade_in_bgs("Whispers",2.0)
	fade_tween_in($Backgrounds)
	await get_tree().create_timer(2).timeout
	fade_tween($VineMossLogo)
	await get_tree().create_timer(7).timeout
	fade_tween($Intro)
	await get_tree().create_timer(7).timeout
	SoundManager.fade_out("Whispers",3.0)
	SoundManager.fade_in_bgm("BG_Main",2.0)
	fade_tween_in($Banner)
	await get_tree().create_timer(1.0).timeout
	fade_tween_in($Subtitles)
	await get_tree().create_timer(2.0).timeout
	$Button.disabled = false
	fade_tween_in($Button)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fade_tween(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 1.0), 2)
	fadeTween.tween_interval(3)
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 0.0), 2)

func fade_tween_in(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 1.0), 2)

func fade_tween_out(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 0.0), 2)

func _on_button_pressed() -> void:
	$Button.disabled = true
	await get_tree().create_timer(2.0).timeout
	fade_tween_out($Button)
	fade_tween_out($Subtitles)
	fade_tween_out($Banner)
	fade_tween_out($Backgrounds)
	SoundManager.fade_out("BG_Main",2.0)
	SoundManager.fade_in_bgs("Noise",2.0)
	await get_tree().create_timer(7.0).timeout
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
