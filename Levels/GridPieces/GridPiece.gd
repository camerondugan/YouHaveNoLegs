extends Spatial

var gridPosition := Vector2.ZERO
export var adjacents := []

#updates the adjacent vectors as if rotated once
func rotateClockwise():
	for i in range(len(adjacents)):
		adjacents[i] = adjacents[i].rotated(deg2rad(-90))

func rotateClockwiseRepeat(x):
	for i in range(len(adjacents)):
		adjacents[i] = adjacents[i].rotated(deg2rad(-90)*x)

func _body_entered(body):
	if (body.name=="PlayerBody"):
		print("setting player position: " + str(gridPosition))
		get_parent().setPlayerPosition(gridPosition)
