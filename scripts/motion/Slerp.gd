extends Node

static func calc(val,isIncreasing,mx,mn,delta,speed):
	if isIncreasing and val < mx:
		val += delta * speed #+1 speed number of times per second
	elif(!isIncreasing and val > mn):
		val -= delta * speed 
	return val
