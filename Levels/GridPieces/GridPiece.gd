extends Spatial

var gridPosition := Vector2.ZERO

func _ready():
	pass # Replace with function body.

func _body_entered(body):
	if (body.name=="PlayerBody"):
		print(body.name)
		get_parent().setPlayerPosition(gridPosition)
