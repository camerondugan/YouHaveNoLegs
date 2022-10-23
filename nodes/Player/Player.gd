extends Spatial

var lives := 3
var invulnerable = false

onready var larm := get_node("PlayerBody/VR/Camera/prison-arms-left")
onready var rarm := get_node("PlayerBody/VR/Camera/prison-arms-right")

func _process(_delta):
	if invulnerable:
		var tleft := int($Invulnerability.time_left*5)
		larm.visible = tleft%2==0
		rarm.visible = tleft%2==0

func reduceLives(num):
	if (!invulnerable):
		lives -= num
		invulnerable = true
		$Invulnerability.start()
		get_node("%Glitch").visible = true
		if (lives <= 0):
			var enemies := get_tree().get_nodes_in_group("Enemies")
			for enemy in enemies:
				enemy.die()
			queue_free()

func _exit_tree():
	if (!get_tree().change_scene("res://Levels/Game.tscn")):
		print("Failed to restart level")

func increaseLives(num):
	lives += num

func _on_Invulnerability_timeout():
	invulnerable = false
	larm.visible = true
	rarm.visible = true
	get_node("%Glitch").visible = false
