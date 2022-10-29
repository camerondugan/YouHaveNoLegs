extends Spatial

export(Dictionary) var gridLibrary
export(Dictionary) var blockProbabilities
var maxBlockProbability := 0.0

export(int) var level_depth
export var enemySpawnRate = 0.2
var blocks := {}
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
	for v in gridLibrary.values():
		print(v)
	for key in gridLibrary.keys():
		print(key)
		var newd = {key:load(gridLibrary[key]).instance()}
		gridLibrary.merge(newd,true); #Changes key to loaded scene
	for v in gridLibrary.values():
		print(v)

func reset():
	blocks.clear()
	playerGridPos = Vector3.ZERO
	for c in get_children():
		c.queue_free()
	_ready()

var initVars = false
func _ready():
	showLoadingScreen(true)
	if not initVars:
		initvars()
		initVars = true
	spawn(safePiece(),1,playerGridPos)
	genMapDepth(playerGridPos,level_depth)
	spawnEndOfLevel()
	showLoadingScreen(false)

func _process(delta):
	#update timer
	total_player_traversal_time += delta
	
func showLoadingScreen(show): #Flashbang Fix
	for c in get_children():
		if (c.name == "Loading Screen"):
			print("Showing Loading:", show)
			c.visible = show
		else:
			c.visible = !show

func spawn(block,rotations,pos):
	var firstBlock = len(blocks) == 0
	if not occupied(pos):
		print(block, " grid: ", pos.x, ",", pos.z, " r: ", rotations)
		var b = gridLibrary[block].duplicate()
		b.visible = true
		b.name = block
		b.gridPosition = pos
		b.rotateClockwiseRepeat(rotations)
		b.translation = pos*squareSize
		b.canSpawnEnemies = b.canSpawnEnemies and (random.randf_range(0,1) < enemySpawnRate) and not firstBlock
		add_child(b)
		blocks.merge({pos:b})
		return true
	else:
		print("Blocked on", pos)
	return false

func occupied(pos):
	return blocks.has(pos)

func reduceGridSize():
	for pos in blocks.keys():
		if (pos.distance_to(playerGridPos) > maxBlockDistance):
			blocks[pos].set_process(false)
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
	if blocks.has(pos):
		return blocks[pos]
	return null

func getPlayerBlock():
	for pos in blocks.keys():
		if (pos == playerGridPos):
			return blocks[pos]
	return null

func spawnEndOfLevel():
	var lastPiece = null
	var ends = []
	for b in blocks.values():
		if (endPieces.has(b.name.get_slice("@",1))): #Find a block that is an end piece
			ends.append(b)
	lastPiece = furthestBlockFrom(ends,playerGridPos)
	assert(lastPiece != null)
	var _e = blocks.erase(lastPiece.gridPosition)
	#blocks.remove(blocks.find(lastPiece)) #removes old piece from the blocks list
	spawn("f1",lastPiece.rotations,lastPiece.gridPosition) #f1 should be replaced with a random chosen potential end gate?
	lastPiece.queue_free()

func furthestBlockFrom(theseBlocks, place):
	var furthestDist = 0
	var furthest = null
	for p in theseBlocks:
		var dist = p.gridPosition.distance_to(place)
		print(dist)
		if (dist > furthestDist):
			furthestDist = dist
			furthest = p
	return furthest

func spawnAllAdjacents(block):
	if (len(block.adjacents) != 0):
		for adj in block.adjacents:
			spawnFittingGridPiece(adj,block.gridPosition,false)
	else:
		pass

# Checks if a piece connects properly with another (but not if the otherpiece connects and this one doesn't)
func validAdjacent(piece, otherPiece):
	if (!piece or !otherPiece):
		return false
	for adj in piece.adjacents:
		if piece.gridPosition + adj == otherPiece.gridPosition:
			for adj2 in otherPiece.adjacents:
				if otherPiece.gridPosition + adj2 == piece.gridPosition:
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
		var instancedPiece = gridLibrary[piece].duplicate()
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
	print(depth)
	var spawnEndPiece = depth==1 #boolean
	for dir in curBlock.adjacents:
		if (spawnFittingGridPiece(dir,curBlock.gridPosition,spawnEndPiece)):
			genMapDepth(curBlock.gridPosition+dir,depth-1)
	
func safePiece():
	var pieces = randomGridPieces()
	for p in pieces:
		print(p,gridLibrary[p].hazard)
		if not gridLibrary[p].hazard:
			return p

func randomGridPieces():
	var shuffledPieces = gridLibrary.keys()
	#shuffledPieces.shuffle()
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
		var f = random.randf_range(0, tmaxBlockProbability)
		var i := 0
		for bp in tblockProbabilities.values():
			f -= bp
			if (f<=0):
				# Update dictionary + lists with chosen piece
				tmaxBlockProbability -= bp
				var choice = tblockProbabilities.keys()[i]
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
