extends Spatial

export(Dictionary) var gridLibrary

var grid := [[]]
var blocks := []
var squareSize := 5
var maxBlockDistance := 20
var playerGridPos := Vector2.ZERO
var endPieces = ['c1']

func _ready():
	#seed("You Have No Legs".hash())
	randomize()
	spawn('c1',1,playerGridPos)
	genMapDepth(playerGridPos,10)
	
func spawn(block,rotations,pos):
	if unoccupied(pos):
		var b = load(gridLibrary[block]).instance()
		b.name = block
		b.gridPosition = pos
		b.rotation=Vector3.UP*deg2rad(-90*rotations)
		b.rotateClockwiseRepeat(rotations)
		b.translation = Vector3(-pos.x*squareSize,0,pos.y*squareSize)
		add_child(b)
		blocks.append(b)
		return true
	return false

func unoccupied(pos):
	for block in blocks:
		if (block.gridPosition.distance_to(pos)<.8):
			return false
	return true

func reduceGridSize():
	for block in blocks:
		if (block.gridPosition.distance_to(playerGridPos) > maxBlockDistance):
			block.queue_free()
			blocks.erase(block)
			return true
	return false

func setPlayerPosition(playerPos):
	playerGridPos = playerPos
	getBlock(playerPos).spawnEnemies()
	updateMap()

func getBlock(pos):
	for block in blocks:
		if (block.gridPosition.x == pos.x and block.gridPosition.y == pos.y):
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

func validAdjacent(dir, adj2,p1,p2):
	for adj in adj2:
		if dir.round() == -adj.round():
			return true
	return false

#Finds piece that allows adjacents from that direction
func spawnFittingGridPiece(dir,gridPos,spawnEnd):
	if !unoccupied(gridPos+dir): return false
	var rotations = range(4)
	var shuffledPieces = randomGridPieces()
	if (spawnEnd):
		shuffledPieces = endPieces
	var ogPiece = getBlock(gridPos-dir)
	for piece in shuffledPieces:
		var instancedPiece = load(gridLibrary[piece]).instance()
		for rotation in rotations:
			if (validAdjacent(dir,instancedPiece.adjacents,ogPiece,instancedPiece)):
				var spawned = spawn(piece,rotation,gridPos+dir)
				instancedPiece.free()
				return spawned
			instancedPiece.rotateClockwise()
		instancedPiece.queue_free()
	return spawn('c4',0,gridPos+dir)

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
	spawn("c4",0,playerGridPos)
	var curBlock = getBlock(playerGridPos)
	spawnAllAdjacents(curBlock)
	reduceGridSize()
