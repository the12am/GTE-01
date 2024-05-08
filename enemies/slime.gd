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
@onready var animations = $AnimationPlayer

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

## overall, this function is used to update the animation direction based on the velocity of the player. If the player is not moving(no input), it stops any currently playing animations. If the player is moving, it determines the direction of movement and sets the direction variable accordingly (up, down, left, right)
## function is defined with "func updateAnimation():"
## "if" is used for conditional branching
## "velocity.length()" uses the vector variable velocity and length to calculate the magnitude, or length of the vector
## "== 0:" checks if the magnitude/length of the velocity vector is equal to 0. if equal to zero, this means that the player is not moving.
## "if animations.is_playing():" simply asks if the variable animations is currently being called, or if animations are currently being played (ex: the player is in motion downward, thus a downward animation is playing)
## "animations.stop()" if any animation is playing, (ex: if animations.is_playing(): returns as (TRUE) then stop the animation.
## this basically says when your velocity is 0 but an animation is playing, stop it.
func updateAnimation():
	if velocity.length() == 0:
			if animations.is_playing():
				animations.stop()
				
## else is a conditional statement, this is only called once the initial if statement "if velocity.length() == 0:" is NOT MET, meaning the velocity vector is longer than 0, meaning the operator has input a control, meaning the player is in motion.
## "var direction" is just a variable declaration, "Down" initializes the variable as "Down", basically when the variable is called it begins as "Down" this is why the character is facing downward when the game starts, if changed to "Up", the character would start facing upwards
## if and elif are conditional statements, elif is used when testing multiple conditions before applying to the else statement
## "velocity.x < 0" Checks if the horizontal(x) component of the velocity vector is less than 0, meaning the player is moving left.
## "direction = "Left"" If the object is moving left (aka horizontal velocity vector is less than 0) set the variable direction to "Left"
## "velocity.x > 0" Checks if the horizontal(x) component of the velocity vector is greater than 0, meaning the player is moving "Right".
## "velocity.y < 0" Checks if the vertical(y) component of the velocity vector is less than 0, meaning the player is moving "Up".
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
		
## "animations.play" is calling the var animations which is tied to the $AnimationPlayer constant
## "("walk" + direction)" is adding "walk" plus the direction which is dictated by the else statement as either Up, Down, Left, or Right
## When an operator enters "w" to walk up, the direction variable changes to up since the elif condition is met, therefore the animations.play becomes "walkUp" which is a defined player animation against the node "Player"
		animations.play("walk" + direction)
		
func _physics_process(_delta):
	updateVelocity()
	move_and_slide()
	updateAnimation()
