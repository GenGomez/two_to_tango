extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.victory:
		$Victory.text = "you win!"
	else:
		$Victory.text = "you lose"
		
	$NoteCount.text = str("Missed: " , Global.missed , "\nOkay: " , Global.okay , "\nGood: " , Global.good , "\nGreat: " , Global.great)
	$MaxCombo.text = str(Global.combo)
	$FinalScore.text = str(Global.score)

func _input(event):
	if event.is_action_pressed("esc"):
		get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_play_again_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
