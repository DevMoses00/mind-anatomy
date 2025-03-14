extends Node2D

@export var speed:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# move the backgrounds consistently
	$BackgroundOne.position.x += speed
	$BackgroundTwo.position.x += speed
	
	# when the backgrounds hit specific locations, reset the position
	if $BackgroundOne.position.x >= 2013:
		$BackgroundOne.position.x = -2195
	
	if $BackgroundTwo.position.x >= 2013:
		$BackgroundTwo.position.x = -2195
