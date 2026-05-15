extends Button

@export var song: AudioStream
@export var player: AudioStreamPlayer

func _pressed():
	player.stream = song
	player.play()
