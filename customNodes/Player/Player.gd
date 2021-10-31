extends Spatial

var lives := 3
var invulnerable = false

func reduceLives(num):
	lives -= num
	invulnerable = true
	$Invulnerability.start()
	print(invulnerable)
	print(lives)
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
