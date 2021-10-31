extends Spatial

var lives := 3
var invulnerable = false

onready var larm := get_node("VR/Headset Camera/prison-arms-left")
onready var rarm := get_node("VR/Headset Camera/prison-arms-left")

func _process(delta):
	if invulnerable:
		var tleft:int = int($Invulnerability.time_left*5)
		larm.visible = tleft%2==0
		rarm.visible = tleft%2==0

func reduceLives(num):
	lives -= num
	invulnerable = true
	$Invulnerability.start()
	if (lives <= 0):
		var enemies := get_tree().get_nodes_in_group("Enemies")
		for enemy in enemies:
			enemy.die()
		queue_free()

func _exit_tree():
	get_tree().reload_current_scene()

func increaseLives(num):
	lives += num

func _on_Invulnerability_timeout():
	invulnerable = false
	larm.visible = true
	rarm.visible = true
