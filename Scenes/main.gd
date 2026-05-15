extends Node2D

var score = 0
var combo = 0

var max_combo = 0
var great = 0
var good = 0
var okay = 0
var missed = 0

var bpm = 115

var song_position = 0.0
var song_position_in_beats = 0
var last_spawned_beat = 0
var sec_per_beat = 60.0 / bpm

var spawn_1_beat = 0
var spawn_2_beat = 0
var spawn_3_beat = 1
var spawn_4_beat = 0

var lane = 0
var rand = 0
var note = preload("res://Prefabs/Note.tscn")


func _input(event):
	if event.is_action_pressed("esc"):
		get_tree().quit()


func _ready() -> void:
	randomize()
	#$Conductor.play_with_beat_offset(8)
	$Conductor.play_from_beat(360,0)
	$Meter.value = $Meter.max_value + 8



func _on_Conductor_measure(position):
	if position == 1:
		_spawn_notes(spawn_1_beat)
	elif position == 2:
		_spawn_notes(spawn_2_beat)
	elif position == 3:
		_spawn_notes(spawn_3_beat)
	elif position == 4:
		_spawn_notes(spawn_4_beat)

func _on_Conductor_beat(position):
	song_position_in_beats = position
	if song_position_in_beats > 8:
		$Meter.value -= 1
		if $Meter.value <= 0:
			_goEnd(false)
	if song_position_in_beats > 20:
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
	if song_position_in_beats > 98:
		spawn_1_beat = 2
		spawn_2_beat = 0
		spawn_3_beat = 1
		spawn_4_beat = 0
	if song_position_in_beats > 132:
		spawn_1_beat = 0
		spawn_2_beat = 2
		spawn_3_beat = 0
		spawn_4_beat = 2
	if song_position_in_beats > 162:
		spawn_1_beat = 2
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 194:
		spawn_1_beat = 2
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 2
	if song_position_in_beats > 228:
		spawn_1_beat = 0
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 2
	if song_position_in_beats > 258:
		spawn_1_beat = 1
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 2
	if song_position_in_beats > 288:
		spawn_1_beat = 0
		spawn_2_beat = 2
		spawn_3_beat = 0
		spawn_4_beat = 2
	if song_position_in_beats > 322:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 388:
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
	if song_position_in_beats > 399:
		_goEnd(true)


func _goEnd(victory):
	Global.score = score
	Global.combo = max_combo
	Global.great = great
	Global.good = good
	Global.okay = okay
	Global.missed = missed
	Global.victory = victory
	if get_tree().change_scene_to_file("res://Scenes/End.tscn") != OK:
		print ("Error changing scene to End")

func _spawn_notes(to_spawn):
	if to_spawn > 0:
		lane = randi() % 3
		var instanceP1 = note.instantiate()
		instanceP1.initialize(lane, 0)
		add_child(instanceP1)
		var instanceP2 = note.instantiate()
		instanceP2.initialize(lane, 1)
		add_child(instanceP2)
	if to_spawn > 1:
		while rand == lane:
			rand = randi() % 3
		lane = rand
		var instanceP1 = note.instantiate()
		instanceP1.initialize(lane, 0)
		add_child(instanceP1)
		var instanceP2 = note.instantiate()
		instanceP2.initialize(lane, 1)
		add_child(instanceP2)
		


func increment_score(by):
	if by > 0:
		combo += 1
		$Meter.value += by;
	else:
		combo = 0
		$Meter.value -= 5;
	
	if by == 3:
		great += 1
	elif by == 2:
		good += 1
	elif by == 1:
		okay += 1
	else:
		missed += 1
	
	
	score += by * combo
	$Label.text = str(score)
	if combo > 0:
		$Combo.text = str(combo) + " combo!"
		if combo > max_combo:
			max_combo = combo
	else:
		$Combo.text = ""
