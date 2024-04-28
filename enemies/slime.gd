## The purpose of this script is to add animation and movement to the slime entity

## extends is like tying a script to a node in your scene, here we reference it by the type of node, not the name, since scripts are tied directly to nodes
extends CharacterBody2D

## export refers to making a variable of your choice available in the inpector tab to the right
## here we export the variables "speed, limit, endPoint" 
## "var speed = 20" sets the character's (slime's) speed
## "var limit = 0.5" sets the threshold for when the character should change direction
## "var endPoint: Marker2D" endPoint is a marker indicating the destination point towards which the character will initially move
## endPoint is bound to a Marker2D node which is place on the 2D plane, the character will move in a straight line towards wherever this is placed on intialization 
@export var speed = 20
@export var limit = 0.5
@export var endPoint: Marker2D

## onready is a shorthand for assigning a variable within the ready function
## this line creates a variable named animations and assigns it to the AnimatedSprite2D node named AnimationSlime, which contains frame data for each up, down, left, and right animations
@onready var animations = $AnimationSlime


## these two variables are defined for usage later within multiple non-nested functions. 
## we need to place them here so the variables persist between seperate function calls
var startPosition
var endPosition

## "_ready():" is a native function of Godot that is called when the node and it's children have been loaded
## These just ready both vars with startPosition being a vector using native position
## endPosition becomes the global position of the endPoint variable which as mentioned earlier maps to our Marker2D
func _ready():
	startPosition = position
	endPosition = endPoint.global_position

## "var tempEnd = endPosition" declares tempEnd and assigns it the value of endPosition
## "endPosition = startPosition" swaps the value of endPosition with the value of startPosition, this means whatever value endPosition had before, it will now have the value of startPosition
## "startPosition = tempEnd" this line assigns the value tempEnd which originally held the value of endPosition to startPosition, this completes the swap, exchanging startPosition and endPosition
func changeDirection():
		var tempEnd = endPosition
		endPosition = startPosition
		startPosition = tempEnd
		
## "var moveDirection = (endPosition - position)" this calculates the direction in which the object needs to move. It subtracts the current position of the target (position) from the target position (endPosition) to obtain the vector represeting the direction the object shold move
## "if moveDirection.length() < limit:" this checks if the length of moveDirection is lower than the limit, this is represented by a length
## "changeDirection()" if the length of moveDirection vector is less than the limit, change the objects direction
## "velocity = moveDirection.normalized() * speed" after updating the "moveDirection" based on the current and target position, this line calculates the velocity vector
## This first normalizes the "moveDirection" vector, and then scales it using the earlier exported variable "speed" to determine the magnitude of it's velocity, the result is then assigned to the velocity variable
func updateVelocity():
	var moveDirection = (endPosition - position)
	if moveDirection.length() < limit:
		changeDirection()
		
	velocity = moveDirection.normalized() * speed

func updateAnimation():
	var animationString = "walkUp"
	if velocity.y > 0:
		animationString = "walkDown"
		
	animations.play(animationString)
		
func _physics_process(_delta):
	updateVelocity()
	move_and_slide()
	updateAnimation()
