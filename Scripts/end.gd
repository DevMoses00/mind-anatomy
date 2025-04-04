extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1).timeout
	fade_tween_in($Backgrounds)
	SoundManager.fade_in_bgs("BG_Reg",2.0)
	await get_tree().create_timer(2).timeout
	fade_tween_in($Thanks)
	await get_tree().create_timer(1).timeout
	fade_tween_in($Thanks2)
	await get_tree().create_timer(2).timeout
	fade_tween_in($Cards)
	fade_tween_in($VineMossLogo)
	fade_tween_in($Button)
	await get_tree().create_timer(2).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fade_tween_in(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 1.0), 2)


func _on_button_pressed() -> void:
	await get_tree().create_timer(2).timeout
	get_tree().quit()
