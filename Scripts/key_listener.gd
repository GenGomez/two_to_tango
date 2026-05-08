extends Sprite2D

@export var key_name: String = ""

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _process(delta: float) -> void:
	
	if !is_multiplayer_authority():
		return
	
	if Input.is_action_just_pressed(key_name):
		print(key_name)
