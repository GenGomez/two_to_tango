extends Button
@export var select : Resource
@export var hover : Resource

func _on_pressed() -> void:
	$Click.play()

func _on_mouse_entered() -> void:
	$Hover.play();
