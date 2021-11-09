extends Spatial

export(Dictionary) var gridLibrary

var grid := [[]]
var blocks := []
var squareSize := 5
var maxBlockDistance := 20
var playerGridPos := Vector2.ZERO

func _ready():
	#seed("You Have No Legs".hash())
	randomize()
	spawn('c4',0,playerGridPos)
	for adj in getPlayerBlock().adjacents:
		spawnFittingGridPiece(adj,playerGridPos)
	
func spawn(block,rotations,pos):
	if unoccupied(pos):
		var b = load(gridLibrary[block]).instance()
		#var b = load("res://Levels/GridPieces/c4.tscn").instance()
		#print(b.adjacents)
		b.name = block
		b.gridPosition = pos
		b.rotation=Vector3.UP*deg2rad(-90*rotations)
		b.rotateClockwiseRepeat(rotations)
		print(b.rotation)
		b.translation = Vector3(-pos.x*squareSize,0,pos.y*squareSize)
		add_child(b)
		blocks.append(b)
		return true
	return false

func unoccupied(pos):
	for block in blocks:
		if (block.gridPosition.distance_to(pos)<.8):
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
	#print("Spawning adjacents" + str(block.adjacents))
	if (len(block.adjacents) != 0):
		for adj in block.adjacents:
			spawnFittingGridPiece(adj,block.gridPosition)
	else:
		print("block: " + block.name + " had no adjacents")

func validAdjacent(dir, adj2):
	#print(adj2)
	for adj in adj2:
		print("checking valid: " + str(dir) + " -> " + str(adj))
		if dir.round() == -adj.round():
			return true
	return false

#Finds piece that allows adjacents from that direction
func spawnFittingGridPiece(dir,gridPos):
	if !unoccupied(gridPos+dir): return false
	var rotations = range(4)
	var shuffledPieces = randomGridPieces()
	for piece in shuffledPieces:
		print(piece + " @ " + str(gridPos+dir))
		var instancedPiece = load(gridLibrary[piece]).instance()
		#rotations.shuffle()
		for rotation in rotations:
			#print(rotation)
			if (validAdjacent(dir,instancedPiece.adjacents)):
				var spawned = spawn(piece,rotation,gridPos+dir)
				#if spawned:
					#print("Grid Piece Location: " + str(gridPos.x+dir.x) + " " + str(gridPos.y+dir.y))
					#print("Spawned " + str(piece) + " with rotation: " + str(rotation))
				instancedPiece.free()
				return spawned
			#print(instancedPiece.adjacents)
			instancedPiece.rotateClockwise()
		instancedPiece.queue_free()
	print("spawning c4, failed to find a fit")
	return spawn('c4',0,gridPos+dir)

func randomGridPieces():
	var shuffledPieces = gridLibrary.keys()
	shuffledPieces.shuffle()
	return shuffledPieces

func updateMap():
	print(blocks)
	spawn("c4",0,playerGridPos)
	var curBlock = getBlock(playerGridPos.x,playerGridPos.y)
	spawnAllAdjacents(curBlock)
	reduceGridSize()
