extends AudioStreamPlayer3D

export(Array,Resource) var sounds=[]

func _ready():
	randomize()
	stream =sounds.front()

func _randomize(s:Array):
	s.shuffle()
	stream=sounds.front()

func _play():
	_randomize(sounds)
	play()

func _recieveSignal(_body:Node):
	_play()
