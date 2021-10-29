extends Spatial

var lives := 3

func _process(_delta):
	if (lives <= 0):
		queue_free()

func reduceLives(num):
	lives -= num

func increaseLives(num):
	lives += num
