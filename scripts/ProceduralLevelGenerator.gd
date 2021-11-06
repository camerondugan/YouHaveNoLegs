extends Spatial

export(Dictionary) var gridLibrary

var grid := [[]]
var blocks := []
var squareSize := 5
var playerGridPos := Vector2.ZERO

func _ready():
	seed("You Have No Legs".hash())
	setPlayerPosition(Vector2(0,0))

func spawnWVector(block,xy):
	spawn(block,xy.x,xy.y)

func spawn(block,x,y):
	if unoccupied(x,y):
		var b = gridLibrary[block].instance()
		b.translation = Vector3.ZERO
		b.global_transform.origin = Vector3(x*squareSize,0,y*squareSize)
		b.gridPosition = Vector2(x,y)
		self.add_child(b)
		blocks.append(b)
		reduceGridSize()

func unoccupied(x,y):
	for block in blocks:
		if (block.gridPosition.x == x && block.gridPosition.y == y):
			return false
	print("Occupied: " + str(x) + ", " + str(y))
	return true

func reduceGridSize():
	for block in blocks:
		if (block.gridPosition.distance_to(playerGridPos) > 1.5):
			print("Erasing block at: " + str(block.gridPosition))
			block.queue_free()
			blocks.erase(block)

func setPlayerPosition(playerPos):
	playerGridPos = playerPos
	spawnAroundPlayer()

func getCurBlock():
	for block in blocks:
		if (block.gridPosition == playerGridPos):
			return block
	return null

func spawnAroundPlayer():
	var curBlock = getCurBlock()
	while(curBlock!=null):
		