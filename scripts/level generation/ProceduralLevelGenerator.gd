extends Spatial

export(Dictionary) var gridLibrary

var blocks := []
var squareSize := 5
var maxBlockDistance := 10
var playerGridPos := Vector3.ZERO
var endPieces = ['c1']

var total_player_traversal_time := 0.0
var approx_number_of_tiles_traversed := 0
var avg_player_grid_traversal_time := 0.0

# var level_end_tile = tileId?

func _ready():
	seed("You Have No Legs".hash())
	randomize()
	spawn('c2',1,playerGridPos)
	genMapDepth(playerGridPos,10)

func _process(delta):
	#update timer
	total_player_traversal_time += delta
	
func spawn(block,rotations,pos):
	if not occupied(pos):
		print(block, " grid: ", pos.x, ",", pos.z, " r: ", rotations)
		var b = load(gridLibrary[block]).instance()
		b.name = block
		b.gridPosition = pos
		b.rotateClockwiseRepeat(rotations)
		b.translation = pos*squareSize
		add_child(b)
		blocks.append(b)
		return true
	return false

func occupied(pos):
	for block in blocks:
		if (block.isAt(pos)):
			return true
	return false

func reduceGridSize():
	for block in blocks:
		if (block.gridPosition.distance_to(playerGridPos) > maxBlockDistance):
			block.set_process(false)
			return true
	return false

func setPlayerPosition(p):
	var pblock = getPiece(p)
	if pblock:
		playerGridPos = p
		pblock.spawnEnemies()
		approx_number_of_tiles_traversed += 1
	updateMap()

func getPiece(pos):
	for block in blocks:
		if block.isAt(pos):
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
			spawnFittingGridPiece(adj,block.gridPosition,false)
	else:
		print("block: " + block.name + " had no adjacents")

# Checks if a piece connects properly with another (but not if the otherpiece connects and this one doesn't)
func validAdjacent(piece, otherPiece):
	if (!piece or !otherPiece):
		return false
	for adj in piece.adjacents:
		if piece.gridPosition + adj == otherPiece.gridPosition:
			for adj2 in otherPiece.adjacents:
				if otherPiece.gridPosition + adj2 == piece.gridPosition:
					print("found valid")
					return true
			#return false
	return false

func validPlacement(piece):
	var valid = false	
	if len(piece.adjacents) == 0:
		return false
	for adj in [Vector3.UP,Vector3.DOWN,Vector3.FORWARD,Vector3.BACK, Vector3.LEFT, Vector3.RIGHT]:
		var otherPiece = getPiece(piece.gridPosition+adj)
		if (otherPiece):
			if (validAdjacent(piece, otherPiece) and validAdjacent(otherPiece,piece)):
				return !valid
	return valid

#Finds piece that allows adjacents from that direction
func spawnFittingGridPiece(dir,gridPos,spawnEnd):
	if occupied(gridPos+dir): 
		return false
	var rotations = range(4)
	rotations.shuffle()
	var shuffledPieces = randomGridPieces()
	if (spawnEnd):
		shuffledPieces = endPieces
		shuffledPieces.shuffle()

	for piece in shuffledPieces:
		var instancedPiece = load(gridLibrary[piece]).instance()
		instancedPiece.gridPosition = gridPos+dir
		for rotation in rotations:
			instancedPiece.rotateClockwiseRepeat(rotation)
			if (validPlacement(instancedPiece)):
				var ifSpawn = spawn(piece,rotation,gridPos+dir)
				instancedPiece.free()
				return ifSpawn
			instancedPiece.rotateClockwiseRepeat(-rotation)
		instancedPiece.queue_free()
	return spawn('error',0,gridPos+dir) #if nothing is spawned, try spawning this

func genMapDepth(pos,depth):
	var curBlock = getPiece(pos)
	if (depth == 0 or curBlock == null): 
		return
	var spawnEndPiece = depth==1 #boolean
	for dir in curBlock.adjacents:
		spawnFittingGridPiece(dir,curBlock.gridPosition,spawnEndPiece)
	for dir in curBlock.adjacents:
		genMapDepth(curBlock.gridPosition+dir,depth-1)

func randomGridPieces():
	var shuffledPieces = gridLibrary.keys()
	shuffledPieces.shuffle()
	for piece in endPieces:
		shuffledPieces.erase(piece)
	return shuffledPieces

func updateMap():
	#spawn("c4",0,playerGridPos)
	var curBlock = getPiece(playerGridPos)
	spawnAllAdjacents(curBlock)
	reduceGridSize()
