extends Spatial

export(Dictionary) var gridLibrary
export(Dictionary) var blockProbabilities
var maxBlockProbability := 0.0

export(int) var level_depth
var blocks := []
var squareSize := 5
var maxBlockDistance := 10
var playerGridPos := Vector3.ZERO
var endPieces = ['c1']
var excludePieces = ['f1']

var total_player_traversal_time := 0.0
var approx_number_of_tiles_traversed := 0
var avg_player_grid_traversal_time := 0.0
var random = RandomNumberGenerator.new()

# var level_end_tile = tileId?

func initvars():
	for b in blockProbabilities.values():
		maxBlockProbability += b
	random.randomize()

func _ready():
	initvars()
	spawn('c2',1,playerGridPos)
	genMapDepth(playerGridPos,level_depth)
	spawnEndOfLevel()

func _process(delta):
	#update timer
	total_player_traversal_time += delta
	
func spawn(block,rotations,pos):
	if not occupied(pos):
		#print(block, " grid: ", pos.x, ",", pos.z, " r: ", rotations)
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

func spawnEndOfLevel():
	var lastPiece = null
	var b = blocks.duplicate(true)
	b.shuffle()
	for block in b:
		if (endPieces.has(block.name)): #Find a block that is an end piece
			lastPiece = block
			break
	assert(lastPiece != null)
	blocks.remove(blocks.find(lastPiece)) #removes old piece from the blocks list
	spawn("f1",lastPiece.rotations,lastPiece.gridPosition) #f1 should be replaced with a random chosen potential end gate?
	lastPiece.queue_free()

func spawnAllAdjacents(block):
	if (len(block.adjacents) != 0):
		for adj in block.adjacents:
			spawnFittingGridPiece(adj,block.gridPosition,false)
	else:
		#print("block: " + block.name + " had no adjacents")
		pass

# Checks if a piece connects properly with another (but not if the otherpiece connects and this one doesn't)
func validAdjacent(piece, otherPiece):
	if (!piece or !otherPiece):
		return false
	for adj in piece.adjacents:
		if piece.gridPosition + adj == otherPiece.gridPosition:
			for adj2 in otherPiece.adjacents:
				if otherPiece.gridPosition + adj2 == piece.gridPosition:
					#print("found valid")
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
	for piece in excludePieces:
		shuffledPieces.erase(piece)
	#duplicate probabilities + dictionary
	var tmaxBlockProbability = maxBlockProbability
	var tblockProbabilities = blockProbabilities.duplicate(true)

	#Remove Negative and Zero Probabilities from dictionary
	var valuesToRemove = []
	var j :int = 0
	for v in tblockProbabilities.values():
		if (v <= 0.0):
			valuesToRemove.append(tblockProbabilities.keys()[j]) #append key with irrelevant value
		j += 1
	for k in valuesToRemove:
		tblockProbabilities.erase(k)


	#Move random piece to new list of pieces
	var statisticallyShuffedPieces = []
	while tmaxBlockProbability > 0 and len(tblockProbabilities) > 1:
		#var l:int=len(shuffledPieces)
		#print("looping")
		#print(tmaxBlockProbability)
		#print(tmaxBlockProbability)
		var f = random.randf_range(0, tmaxBlockProbability)
		var i := 0
		for bp in tblockProbabilities.values():
			#print("Random Number: ", f)
			f -= bp
			#print("This Piece: ", bp)
			if (f<=0):
				# Update dictionary + lists with chosen piece
				tmaxBlockProbability -= bp
				var choice = tblockProbabilities.keys()[i]
				#print(choice)
				statisticallyShuffedPieces.append(choice)
				tblockProbabilities.erase(choice)
				break
			i += 1
		#if (len(tblockProbabilities) != 0):
			#assert(l>len(shuffledPieces))
	if len(tblockProbabilities) == 1:
		statisticallyShuffedPieces.append(tblockProbabilities.keys()[0])
	return statisticallyShuffedPieces

func updateMap():
	#spawn("c4",0,playerGridPos)
	var curBlock = getPiece(playerGridPos)
	spawnAllAdjacents(curBlock)
	reduceGridSize()
