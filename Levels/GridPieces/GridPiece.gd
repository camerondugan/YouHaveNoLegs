extends Spatial

var gridPosition := Vector2.ZERO
export var adjacents := []

#updates the adjacent vectors as if rotated once
func rotateClockwise():
	for i in range(len(adjacents)):
		adjacents[i] = adjacents[i].rotated(-PI/2)

func rotateClockwiseRepeat(x):
	for _i in range(x):
		rotateClockwise()

func _body_entered(body):
	if (body.name=="PlayerBody"):
		print("setting player position: " + str(gridPosition))
		get_parent().setPlayerPosition(gridPosition)
