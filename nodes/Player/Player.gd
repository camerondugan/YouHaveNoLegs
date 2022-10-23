extends Spatial

var lives := 3
var startLives := lives
var invulnerable = false
var startInvulnerable = false

onready var world := get_node("/root/World")
onready var larm := get_node("PlayerBody/VR/Camera/prison-arms-left")
onready var rarm := get_node("PlayerBody/VR/Camera/prison-arms-right")

func _process(_delta):
	if invulnerable:
		var tleft := int($Invulnerability.time_left*5)
		larm.visible = tleft%2==0
		rarm.visible = tleft%2==0

func reset():
	invulnerable = startInvulnerable
	lives = startLives

func reduceLives(num):
	if (!invulnerable):
		lives -= num
		invulnerable = true
		$Invulnerability.start()
		get_node("%Glitch").visible = true
		if (lives <= 0):
			world.restart()

func increaseLives(num):
	lives += num

func _on_Invulnerability_timeout():
	invulnerable = false
	larm.visible = true
	rarm.visible = true
	get_node("%Glitch").visible = false
