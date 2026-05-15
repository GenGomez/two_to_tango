extends Node2D

@onready var basic_buttons: CenterContainer = $basicButtons
@onready var song_selector_buttons: CenterContainer = $songSelectorButtons
@onready var song_settings_buttons: Panel = $songSettingsButtons

func _ready():
	basic_buttons.visible = true
	song_selector_buttons.visible = true
	song_settings_buttons.visible = false

	var bus := AudioServer.get_bus_index("Master")
	var db := AudioServer.get_bus_volume_db(bus)
	$songSettingsButtons/HSlider.value = db_to_linear(db)

func _input(event):
	if event.is_action_pressed("esc"):
		get_tree().quit()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_settings_pressed() -> void:
	basic_buttons.visible = false
	song_selector_buttons.visible = false
	song_settings_buttons.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	basic_buttons.visible = true
	song_selector_buttons.visible = true
	song_settings_buttons.visible = false

func _on_h_slider_value_changed(value: float) -> void:
	var bus := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
