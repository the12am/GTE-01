## Player Script for Movement as well as Walking Animations

## I will use the term "operator" when I refer to a human that is playing the game
## I will use the term "player" when I refer to the ingame entity that is controlled by the operator
## I will use the term "native" when I refer to something that is a part of the Godot Engine itself

## extends is like tying a script to a node in your scene, here we reference it by the type of node, not the name, since scripts are tied directly to nodes
extends CharacterBody2D

## export refers to making a variable of your choice available in the inpector tab to the right
## here we export the variable "speed" which is represented by an integer, this will be referenced later
@export var speed: int = 35

## onready is a shorthand for assigning a variable within the ready function, the expanded version can be seen below. vvv
## onready executes the moment the scripts runtime begins (ex: here it is called immediately since the player is a part of the world immediately)
##
##var animations 
##func _ready() -> void:
##	animations = $AnimationPlayer
## this line creates a variable named animations and assigns it to the AnimatedSprite2D node named AnimationPlayer, which contains frame data for each up, down, left, and right animations
@onready var animations = $AnimationPlayer

## func refers to function, or a block of organized reusable code that is used to perform a single related task/action
## here we have func handleInput(): "handleInput" is simply the "name" of the function, you can use whatever names you wish, but keep it readable, (): follows to close the "name"
## "var moveDirection" is simply defining a variable,
## "Input.get_vector" is a function that, in this code, gets the direction we want the player to move in by specifying 4 directions for the positive and negative x and y axis,
## meaning they must be in order with "("ui_left", "ui_right", "ui_up", "ui_down")", ui is basically refering to user input
## velocity = moveDirection*speed is setting the players direction by multiplying "moveDirection", or the users input, by "speed" the variable that we set earlier to an integer of 35
func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection*speed
	
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
		
		
## this function is used to handle collision
func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		print_debug(collider.name)

## this function is simply calling other functions and looping them consistently since there is no if/else statements, it simply runs as a constant. If we do not call these functions they will not actually work other than once they are called on initilization.
## handleInput and updateAnimation are functions we have defined above, updateAnimation is a built in function/native functionality.
func _physics_process(_delta):
	handleInput()
	move_and_slide()
	handleCollision()
	updateAnimation()

func _on_hurt_box_area_entered(area):
	if area.name == "hitBox":
		print_debug(area.get_parent().name)
