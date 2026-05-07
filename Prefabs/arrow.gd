extends Node2D

enum dirs{
	LEFT,
	UP,
	RIGHT
}

var leftTexture = preload("res://Sprites/game/arrow_button/left/arrow_button_left1.png")
var upTexture = preload("res://Sprites/game/arrow_button/up/arrow_button_up1.png")
var rightTexture = preload("res://Sprites/game/arrow_button/right/arrow_button_right1.png")

var direction = dirs.LEFT;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if direction == dirs.LEFT:
		get_node("Sprite2D").set_texture(leftTexture)
	elif direction == dirs.UP:
		get_node("Sprite2D").set_texture(upTexture)
	elif direction == dirs.UP:
		get_node("Sprite2D").set_texture(rightTexture)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
