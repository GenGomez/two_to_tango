extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if modulate.a > 0:
		modulate.a -= 1 * delta
	
