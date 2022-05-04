extends Spatial

export(Dictionary) var gridLibrary

var blocks := []
var squareSize := 5
var maxBlockDistance := 10
var playerGridPos := Vector3.ZERO
var endPieces = ['c1']

func _ready():
	seed("You Have No Legs".hash())
	#randomize()
	spawn('c2',1,playerGridPos)
	genMapDepth(playerGridPos,10)
	
func spawn(block,rotations,pos):
	if not occupied(pos):
		print(block, pos)
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
	var pblock = getBlock(p)
	if pblock:
		playerGridPos = p
		pblock.spawnEnemies()
	updateMap()

func getBlock(pos):
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

func validAdjacent(dir, otherPiece):
	for adj in otherPiece.adjacents:
		if dir.round() == -adj.round():
			return true
	return false

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
	var ogPiece = getBlock(gridPos)
	for piece in shuffledPieces:
		var instancedPiece = load(gridLibrary[piece]).instance()
		for rotation in rotations:
			if (validAdjacent(dir,instancedPiece)):
				var ifSpawn = spawn(piece,rotation,gridPos+dir)
				instancedPiece.free()
				return ifSpawn
			instancedPiece.rotateClockwise()
		instancedPiece.queue_free()
	return spawn('c4',0,gridPos+dir) #if nothing is spawned, try spawning this

func genMapDepth(pos,depth):
	var curBlock = getBlock(pos)
	if (depth == 0 or curBlock == null): 
		return
	var spawnEndPiece = depth==1 #boolean
	for adj in curBlock.adjacents:
		spawnFittingGridPiece(adj,curBlock.gridPosition,spawnEndPiece)
	for adj in curBlock.adjacents:
		genMapDepth(curBlock.gridPosition+adj,depth-1)

func randomGridPieces():
	var shuffledPieces = gridLibrary.keys()
	shuffledPieces.shuffle()
	for piece in endPieces:
		shuffledPieces.erase(piece)
	return shuffledPieces

func updateMap():
	#spawn("c4",0,playerGridPos)
	var curBlock = getBlock(playerGridPos)
	spawnAllAdjacents(curBlock)
	reduceGridSize()
