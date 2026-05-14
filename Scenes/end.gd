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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
