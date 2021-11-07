extends Spatial

export(Dictionary) var gridLibrary

var grid := [[]]
var blocks := []
var squareSize := 5
var maxBlockDistance := 20
var playerGridPos := Vector2.ZERO

func _ready():
	seed("You Have No Legs".hash())
	setPlayerPosition(Vector2(0,0))

func spawnWVector(block,rotations,xy):
	return spawn(block,rotations,xy.x,xy.y)

func spawn(block,rotations,x,y):
	if unoccupied(x,y):
		var b = gridLibrary[block].instance()
		print(b.adjacents)
		b.name = block
		b.gridPosition = Vector2(x,y)
		b.rotateClockwiseRepeat(rotations)
		b.translation = Vector3(x*squareSize,0,y*squareSize)
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
		if (block.gridPosition.x == x and block.gridPosition.y == y):
			return block
	return null

func getPlayerBlock():
	for block in blocks:
		if (block.gridPosition == playerGridPos):
			return block
	return null

func spawnAllAdjacents(block):
	print("Spawning adjacents" + str(block.adjacents))
	if (len(block.adjacents) != 0):
		for adj in block.adjacents:
			spawnFittingGridPiece(adj.x,adj.y,block.gridPosition.x,block.gridPosition.y)
	else:
		print("block: " + block.name + " had no adjacents")

func validAdjacent(dx,dy, adj2):
	for adj in adj2:
		if (int(-adj.x) == int(dx) and int(-adj.y) == int(dy)):
			return true
	return false


#Finds piece that allows adjacents from that direction
func spawnFittingGridPiece(dirX,dirY,gridX,gridY):
	var shuffledPieces = randomGridPieces()
	for piece in shuffledPieces:
		var rotations = range(4)
		rotations.shuffle()
		for rotation in rotations:
			var instancedPiece = gridLibrary[piece].instance()
			for _i in range(rotation):
				instancedPiece.rotateClockwise()
			if (validAdjacent(dirX,dirY,instancedPiece.adjacents)):
				var spawned = spawn(piece,rotation,gridX-dirX,gridY-dirY)
				if spawned:
					print("Grid Piece Location: " + str(gridX+dirX) + " " + str(gridY+dirY))
					print("Spawned " + str(piece) + " with rotation: " + str(rotation))
				instancedPiece.queue_free()
				return spawned
			instancedPiece.queue_free()
	return spawn('c4',0,gridX,gridY)

func randomGridPieces():
	var shuffledPieces = gridLibrary.keys()
	shuffledPieces.shuffle()
	return shuffledPieces

func updateMap():
	spawn("c4",0,playerGridPos.x,playerGridPos.y)
	var curBlock = getBlock(playerGridPos.x,playerGridPos.y)
	spawnAllAdjacents(curBlock)
	reduceGridSize()
