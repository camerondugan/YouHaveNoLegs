extends Spatial

var gridPosition := Vector2.ZERO
export var adjacents := []

func _ready():
	pass # Replace with function body.

#updates the adjacent vectors as if rotated once
func rotateClockwise():
	for i in range(len(adjacents)):
		var tmpX = adjacents[i].x
		adjacents[i].x = adjacents[i].y
		adjacents[i].y = -tmpX

func _body_entered(body):
	if (body.name=="PlayerBody"):
		print("setting player position: " + str(gridPosition))
		get_parent().setPlayerPosition(gridPosition)
