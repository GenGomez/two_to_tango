extends Area2D

@export var TARGET_Y = 164
@export var SPAWN_Y = -16
var DIST_TO_TARGET = TARGET_Y - SPAWN_Y

@export var LEFT_P1 = 26
@export var UP_P1 = 66
@export var RIGHT_P1 = 106

@export var P2_OFFSET = 188

var black_note = preload("res://Animations/note_black.tres")
var red_note = preload("res://Animations/note_red.tres")

var LEFT_LANE_SPAWN = Vector2(LEFT_P1, SPAWN_Y)
var CENTRE_LANE_SPAWN = Vector2(UP_P1, SPAWN_Y)
var RIGHT_LANE_SPAWN = Vector2(RIGHT_P1, SPAWN_Y)

var OFFSET_VECTOR = Vector2(P2_OFFSET,0);

var speed = 0
var hit = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !hit:
		position.y += speed * delta
		if position.y > 200:
			queue_free()
			get_parent().increment_score(0)
	else:
		$Node2D.position.y -= speed * delta
		

func initialize(lane, playerNum):
	if playerNum == 0:
		$AnimatedSprite2D.sprite_frames = black_note
	else :
		$AnimatedSprite2D.sprite_frames = red_note
	
	if lane == 0:
		$AnimatedSprite2D.frame = 0
		position = LEFT_LANE_SPAWN + (OFFSET_VECTOR * playerNum)
	elif lane == 1:
		$AnimatedSprite2D.frame = 1
		position = CENTRE_LANE_SPAWN + (OFFSET_VECTOR * playerNum)
	elif lane == 2:
		$AnimatedSprite2D.frame = 2
		position = RIGHT_LANE_SPAWN + (OFFSET_VECTOR * playerNum)
	else:
		printerr("Invalid lane set for note: " + str(lane))
		return
	
	speed = DIST_TO_TARGET / 2.0

func destroy(score):
	$AnimatedSprite2D.visible = false
	$Timer.start()
	hit = true
	$Node2D/Label.modulate.a = 1
	if score == 3:
		$Node2D/Label.text = "GREAT"
		$Node2D/Label.modulate = Color("ffffffff")
	elif score == 2:
		$Node2D/Label.text = "GOOD"
		$Node2D/Label.modulate = Color("ccccccff")
	elif score == 1:
		$Node2D/Label.text = "OKAY"
		$Node2D/Label.modulate = Color("b3b3b3ff")


func _on_Timer_timeout():
	queue_free()
