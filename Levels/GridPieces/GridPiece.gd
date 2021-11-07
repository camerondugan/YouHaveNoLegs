extends Spatial

var gridPosition := Vector2.ZERO
export var adjacents := []

#updates the adjacent vectors as if rotated once
func rotateClockwise():
	for i in range(len(adjacents)):
		var tmpX = adjacents[i].x
		rotate_object_local(Vector3.UP,PI/2)
		adjacents[i].x = adjacents[i].y
		adjacents[i].y = -tmpX

func rotateClockwiseRepeat(x):
	for _i in range(x):
		rotateClockwise()

func _body_entered(body):
	if (body.name=="PlayerBody"):
		print("setting player position: " + str(gridPosition))
		get_parent().setPlayerPosition(gridPosition)
