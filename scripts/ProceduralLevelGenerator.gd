extends Spatial

export(Dictionary) var gridLibrary

var grid := [[]]
var blocks := []
var squareSize := 5
var maxBlockDistance := 20
var playerGridPos := Vector2.ZERO

func _ready():
	seed("You Have No Legs".hash())
	spawn("c4",0,0,0)
	#setPlayerPosition(Vector2(0,0))

func spawnWVector(block,rotations,xy):
	return spawn(block,rotations,xy.x,xy.y)

func spawn(block,rotations,x,y):
	if unoccupied(x,y):
		var b = gridLibrary[block].instance()
		b.name = block
		b.translation = Vector3(x*squareSize,0,y*squareSize).rotated(Vector3.UP,PI*rotations)
		b.gridPosition = Vector2(x,y)
		add_child(b)
		blocks.append(b)
		return true
	return false

func unoccupied(x,y):
	for block in blocks:
		if (block.gridPosition.x == x && block.gridPosition.y == y):
			return false
	#print("Occupied: " + str(x) + ", " + str(y))
	return true

func reduceGridSize():
	for block in blocks:
		if (block.gridPosition.distance_to(playerGridPos) > maxBlockDistance):
			print("Erasing block at: " + str(block.gridPosition))
			block.queue_free()
			blocks.erase(block)
			return true
	return false

func setPlayerPosition(playerPos):
	playerGridPos = playerPos
	updateMap()

func getBlock(x,y):
	for block in blocks:
		if (block.gridPosition.x ==x and block.gridPosition.y == y):
			return block
	return null

func getPlayerBlock():
	for block in blocks:
		if (block.gridPosition == playerGridPos):
			return block
	return null

func spawnAllAdjacents(block):
	if (len(block.adjacents) != 0):
		for adj in block.adjacents:
			var rotations = range(4)
			rotations.shuffle()
			var rotation = rotations[0]
			#for rotation in rotations:
				#spawn(randomGridPieces()[0],block.gridPosition.x+adj.x,block.gridPosition.y+adj.y)
			spawn(fittingGridPiece(adj.x,adj.y,rotation),rotation,block.gridPosition.x+adj.x,block.gridPosition.y+adj.y)
	else:
		print("empty adjacents")

#Finds piece that allows adjacents from that direction
func fittingGridPiece(dirX,dirY,rotation):
	var shuffledPieces = randomGridPieces()
	for piece in shuffledPieces:
		var instancedPiece = gridLibrary[piece].instance()
		for _i in range(rotation):
			instancedPiece.rotateClockwise()
			for adj in instancedPiece.adjacents:
				print(adj)
				if (-adj.x == dirX and -adj.y == dirY):
					return piece
		instancedPiece.queue_free()
	return null

func randomGridPieces():
	var shuffledPieces = gridLibrary.keys()
	shuffledPieces.shuffle()
	return shuffledPieces

func updateMap():
	spawn("c4",0,playerGridPos.x,playerGridPos.y)
	var curBlock = getBlock(playerGridPos.x,playerGridPos.y)
	spawnAllAdjacents(curBlock)
	reduceGridSize()
