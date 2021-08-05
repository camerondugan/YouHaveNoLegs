extends Spatial

export var nextSceneDir = ""
onready var next_scene = load(nextSceneDir)

func _on_Area_body_entered(body):
	print(body.name)
	if (len(body.get_groups()) > 1):
		print(body.get_groups())
		if (body.get_groups()[1] == "body"):
			get_tree().change_scene_to(next_scene)
