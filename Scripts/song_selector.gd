extends Button

@export var song_path: String

func _pressed():
	var stream = load(song_path)
	get_parent().get_node("AudioStreamPlayer").stream = stream
	get_parent().get_node("AudioStreamPlayer").play()
