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

var startPosition
var endPosition

func _ready():
	startPosition = position
	endPosition = endPoint.global_position
	
func changeDirection():
		var tempEnd = endPosition
		endPosition = startPosition
		startPosition = tempEnd
		
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
