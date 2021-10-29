extends Spatial

var spawner = preload("res://customNodes/Enemies/Drone.tscn")

func spawn():
	var spawn = spawner.instance()
	spawn.transform = global_transform
	get_parent().add_child(spawn)
