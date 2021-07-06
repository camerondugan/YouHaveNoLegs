extends ARVROrigin

var _instance
var headCollider # Sphere collider
var bodyCollider # Capsure Collider

var leftHandFollower #transform
var rightHandFollower #transform
var rightHandTransform #transform
var leftHandTransform #transform
var lastLeftHandPosition #Vector3s
var lastRightHandPosition

var lastHeadPosition

var playerRigidBody #Rigidbody
#var velocityHistorySize = 10 #int
var maxArmLength = 1.5 #float
var unStickDistance = 1.0

onready var raycast = $RayCast

var velocityLimit #floats
var maxJumpSpeed
var jumpMultiplier
var minimumRaycastDistance = 0.05
var defaultSlideFactor = 0.03
var defaultPrecision = 0.995

var velocityHistory #Vector3 history
var velocityIndex #integer
var currentVelocity
var denormalizedVelocityAverage
var jumpHandIsLeft
var lastPosition

var rightHandOffset
var leftHandOffset

var locomotionEnabledLayers #Physics layers

var wasLeftHandTouching
var wasRightHandTouching

var disableMovement = false

func _ready():
	if (_instance != null && _instance != self):
		#Destroy(gameobject)
		pass
	else:
		_instance = self
	InitializeValues()

func InitializeValues():
	playerRigidBody = $RigidBody
	velocityHistory = []
	lastLeftHandPosition = leftHandFollower.transform.position
	lastRightHandPosition = rightHandFollower.transform.position
	lastHeadPosition = headCollider.transform.position
	velocityIndex = 0
	lastPosition = translation
	#get raycasts to collide with things hands collide with
	raycast.set_collision_mask_bit(0,false)
	raycast.set_collision_mask_bit(1,true)
	raycast.set_collision_mask_bit(2,true)

func CurrentLeftHandPosition():
	if ((PositionWithOffset(leftHandTransform, leftHandOffset) - headCollider.transform.position).magnitude < maxArmLength):
		return PositionWithOffset(leftHandTransform, leftHandOffset)
	else:
		return headCollider.transform.position + (PositionWithOffset(leftHandTransform, leftHandOffset) - headCollider.transform.position).normalized * maxArmLength

func CurrentRightHandPosition():

	if ((PositionWithOffset(rightHandTransform, rightHandOffset) - headCollider.transform.position).magnitude < maxArmLength):
		return PositionWithOffset(rightHandTransform, rightHandOffset)
	else:
		return headCollider.transform.position + (PositionWithOffset(rightHandTransform, rightHandOffset) - headCollider.transform.position).normalized * maxArmLength

func PositionWithOffset(var transformToModify, var offsetVector):
	return transformToModify.position + transformToModify.rotation * offsetVector

func _physics_process(delta):
	var leftHandColliding = false
	var rightHandColliding = false
	var finalPosition
	var rigidBodyMovement = Vector3.ZERO
	var firstIterationLeftHand = Vector3.ZERO
	var firstIterationRightHand = Vector3.ZERO
	var hitInfo #raycasthit
	
	bodyCollider.transform.eulerAngles = Vector3(0, headCollider.transform.eulerAngles.y, 0)

	#left hand
	var distanceTraveled = CurrentLeftHandPosition() - lastLeftHandPosition + Vector3.DOWN * 2.0 * 9.81 * delta * delta
	if (IterativeCollisionSphereCast(lastLeftHandPosition, minimumRaycastDistance, distanceTraveled, defaultPrecision, finalPosition, true)):
		#this lets you stick to the position you touch, as long as you keep touching the surface this will be the zero point for that hand
		if (wasLeftHandTouching):
			firstIterationLeftHand = lastLeftHandPosition - CurrentLeftHandPosition()
		else:
			firstIterationLeftHand = finalPosition - CurrentLeftHandPosition()
		playerRigidBody.velocity = Vector3.ZERO
		leftHandColliding = true

	#right hand
	distanceTraveled = CurrentRightHandPosition() - lastRightHandPosition + Vector3.DOWN * 2.0 * 9.81 * delta * delta

	if (IterativeCollisionSphereCast(lastRightHandPosition, minimumRaycastDistance, distanceTraveled, defaultPrecision, finalPosition, true)):
		if (wasRightHandTouching):
			firstIterationRightHand = lastRightHandPosition - CurrentRightHandPosition()
		else:
			firstIterationRightHand = finalPosition - CurrentRightHandPosition()
		playerRigidBody.velocity = Vector3.ZERO
		rightHandColliding = true

	#average or add
	if ((leftHandColliding || wasLeftHandTouching) && (rightHandColliding || wasRightHandTouching)):
		#this lets you grab stuff with both hands at the same time
		rigidBodyMovement = (firstIterationLeftHand + firstIterationRightHand) / 2
	else:
		rigidBodyMovement = firstIterationLeftHand + firstIterationRightHand
	

	#check valid head movement
	if (IterativeCollisionSphereCast(lastHeadPosition, headCollider.radius, headCollider.transform.position + rigidBodyMovement - lastHeadPosition, defaultPrecision, finalPosition, false)):
		rigidBodyMovement = finalPosition - lastHeadPosition
		#last check to make sure the head won't phase through geometry
		raycast.translation = lastHeadPosition
		if (raycast.cast_to(headCollider.translation - lastHeadPosition + rigidBodyMovement)):
			rigidBodyMovement = lastHeadPosition - headCollider.translation
		#if (Physics.Raycast(lastHeadPosition, headCollider.transform.position - lastHeadPosition + rigidBodyMovement, hitInfo, (headCollider.transform.position - lastHeadPosition + rigidBodyMovement).magnitude + headCollider.radius * defaultPrecision * 0.999, locomotionEnabledLayers.value)):
		#	rigidBodyMovement = lastHeadPosition - headCollider.transform.position

	if (rigidBodyMovement != Vector3.ZERO):
		translation = translation + rigidBodyMovement

	lastHeadPosition = headCollider.transform.position

	#do final left hand position
	distanceTraveled = CurrentLeftHandPosition() - lastLeftHandPosition
	if (IterativeCollisionSphereCast(lastLeftHandPosition, minimumRaycastDistance, distanceTraveled, defaultPrecision, finalPosition, !((leftHandColliding || wasLeftHandTouching) && (rightHandColliding || wasRightHandTouching)))):
		lastLeftHandPosition = finalPosition
		leftHandColliding = true
	else:
		lastLeftHandPosition = CurrentLeftHandPosition()

	#do final right hand position
	distanceTraveled = CurrentRightHandPosition() - lastRightHandPosition
	if (IterativeCollisionSphereCast(lastRightHandPosition, minimumRaycastDistance, distanceTraveled, defaultPrecision, finalPosition, !((leftHandColliding || wasLeftHandTouching) && (rightHandColliding || wasRightHandTouching)))):
		lastRightHandPosition = finalPosition
		rightHandColliding = true

	else:
	
		lastRightHandPosition = CurrentRightHandPosition()
	

	StoreVelocities()

	if ((rightHandColliding || leftHandColliding) && !disableMovement):
		if (denormalizedVelocityAverage.magnitude > velocityLimit):
			if (denormalizedVelocityAverage.magnitude * jumpMultiplier > maxJumpSpeed):
				playerRigidBody.velocity = denormalizedVelocityAverage.normalized * maxJumpSpeed
			else:
				playerRigidBody.velocity = jumpMultiplier * denormalizedVelocityAverage

	#check to see if left hand is stuck and we should unstick it
	#if (leftHandColliding && (CurrentLeftHandPosition() - lastLeftHandPosition).magnitude > unStickDistance && !Physics.SphereCast(headCollider.transform.position, minimumRaycastDistance * defaultPrecision, CurrentLeftHandPosition() - headCollider.transform.position, hitInfo, (CurrentLeftHandPosition() - headCollider.transform.position).magnitude - minimumRaycastDistance, locomotionEnabledLayers.value)):
	#	lastLeftHandPosition = CurrentLeftHandPosition()
	#	leftHandColliding = false

	#check to see if right hand is stuck and we should unstick it
	#if (rightHandColliding && (CurrentRightHandPosition() - lastRightHandPosition).magnitude > unStickDistance && !Physics.SphereCast(headCollider.transform.position, minimumRaycastDistance * defaultPrecision, CurrentRightHandPosition() - headCollider.transform.position, hitInfo, (CurrentRightHandPosition() - headCollider.transform.position).magnitude - minimumRaycastDistance, locomotionEnabledLayers.value)):
	#	lastRightHandPosition = CurrentRightHandPosition()
	#	rightHandColliding = false

	leftHandFollower.position = lastLeftHandPosition
	rightHandFollower.position = lastRightHandPosition

	wasLeftHandTouching = leftHandColliding
	wasRightHandTouching = rightHandColliding


func IterativeCollisionSphereCast(var startPosition, var sphereRadius, var movementVector, var precision, var endPosition, var singleHand):

	var hitInfo #raycasthit
	var movementToProjectedAboveCollisionPlane
	var gorillaSurface #surface?
	var slipPercentage
	#first spherecast from the starting position to the final position
	if (CollisionsSphereCast(startPosition, sphereRadius * precision, movementVector, precision, endPosition, hitInfo)):
	
		#if we hit a surface, do a bit of a slide. this makes it so if you grab with two hands you don't stick 100%, and if you're pushing along a surface while braced with your head, your hand will slide a bit

		#take the surface normal that we hit, then along that plane, do a spherecast to a position a small distance away to account for moving perpendicular to that surface
		var firstPosition = endPosition
		gorillaSurface = hitInfo.collider #get surface
		if (gorillaSurface):
			slipPercentage = gorillaSurface.slipPercentage
		elif(!singleHand):
			slipPercentage = defaultSlideFactor
		else:
			slipPercentage =  0.001
		#movementToProjectedAboveCollisionPlane = Vector3.ProjectOnPlane(startPosition + movementVector - firstPosition, hitInfo.normal) * slipPercentage
		if (CollisionsSphereCast(endPosition, sphereRadius, movementToProjectedAboveCollisionPlane, precision * precision, endPosition, hitInfo)):
		
			#if we hit trying to move perpendicularly, stop there and our end position is the final spot we hit
			return true
		
		#if not, try to move closer towards the true point to account for the fact that the movement along the normal of the hit could have moved you away from the surface
		elif (CollisionsSphereCast(movementToProjectedAboveCollisionPlane + firstPosition, sphereRadius, startPosition + movementVector - (movementToProjectedAboveCollisionPlane + firstPosition), precision * precision * precision, endPosition, hitInfo)):
			#if we hit, then return the spot we hit
			return true
		else:
		
			#this shouldn't really happe, since this means that the sliding motion got you around some corner or something and let you get to your final point. back off because something strange happened, so just don't do the slide
			endPosition = firstPosition
			return true

	#as kind of a sanity check, try a smaller spherecast. this accounts for times when the original spherecast was already touching a surface so it didn't trigger correctly
	elif (CollisionsSphereCast(startPosition, sphereRadius * precision * 0.66, movementVector.normalized * (movementVector.magnitude + sphereRadius * precision * 0.34), precision * 0.66, endPosition, hitInfo)):
		endPosition = startPosition
		return true
	else:
		endPosition = Vector3.ZERO
		return false


func CollisionsSphereCast(var startPosition, var sphereRadius, var movementVector, var precision, var finalPosition, var hitInfo):
	#kind of like a souped up spherecast. includes checks to make sure that the sphere we're using, if it touches a surface, is pushed away the correct distance (the original sphereradius distance). since you might
	#be pushing into sharp corners, this might not always be valid, so that's what the extra checks are for
	#initial spherecase
	var innerHit #raycasthit
	if (Physics.SphereCast(startPosition, sphereRadius * precision, movementVector, hitInfo, movementVector.magnitude + sphereRadius * (1 - precision), locomotionEnabledLayers.value)):
	
		#if we hit, we're trying to move to a position a sphereradius distance from the normal
		finalPosition = hitInfo.point + hitInfo.normal * sphereRadius

		#check a spherecase from the original position to the intended final position
		if (Physics.SphereCast(startPosition, sphereRadius * precision * precision, finalPosition - startPosition, innerHit, (finalPosition - startPosition).magnitude + sphereRadius * (1 - precision * precision), locomotionEnabledLayers.value)):
		
			finalPosition = startPosition + (finalPosition - startPosition).normalized * Mathf.Max(0, hitInfo.distance - sphereRadius * (1 - precision * precision))
			hitInfo = innerHit
		
		#bonus raycast check to make sure that something odd didn't happen with the spherecast. helps prevent clipping through geometry
		elif (Physics.Raycast(startPosition, finalPosition - startPosition, innerHit, (finalPosition - startPosition).magnitude + sphereRadius * precision * precision * 0.999, locomotionEnabledLayers.value)):
			finalPosition = startPosition
			hitInfo = innerHit
			return true
		
		return true
	
	#anti-clipping through geometry check
	elif (Physics.Raycast(startPosition, movementVector, hitInfo, movementVector.magnitude + sphereRadius * precision * 0.999, locomotionEnabledLayers.value)):
	
		finalPosition = startPosition
		return true
	else:
		finalPosition = Vector3.ZERO
		return false

func IsHandTouching(var forLeftHand):
	if (forLeftHand):
		return wasLeftHandTouching
	else:
		return wasRightHandTouching


func  Turn(var degrees):
	transform.RotateAround(headCollider.transform.position, transform.up, degrees)
	denormalizedVelocityAverage = Quaternion.Euler(0, degrees, 0) * denormalizedVelocityAverage
	for velocity in velocityHistory:
		velocity = Quaternion.Euler(0, degrees, 0) * velocity
	#for (int i = 0; i < velocityHistory.Length; i++):
	#	velocityHistory[i] = Quaternion.Euler(0, degrees, 0) * velocityHistory[i]
	


func StoreVelocities():
	velocityIndex = (velocityIndex + 1) % velocityHistorySize
	var oldestVelocity = velocityHistory[velocityIndex]
	currentVelocity = (transform.position - lastPosition) / Time.deltaTime
	denormalizedVelocityAverage += (currentVelocity - oldestVelocity) / velocityHistorySize
	velocityHistory[velocityIndex] = currentVelocity
	lastPosition = transform.position
