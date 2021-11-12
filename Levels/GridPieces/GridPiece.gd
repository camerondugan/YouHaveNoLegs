extends Spatial

var gridPosition := Vector2.ZERO
export var gridSize := Vector2.ONE
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
		get_parent().setPlayerPosition(gridPosition)

func contains(pos):
	for h in range(gridSize.y):
		for w in range(gridSize.x):
			if (pos == gridPosition + Vector2(w,h)):
				return true
	return false
