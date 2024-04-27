## Script to control camera movement and follow player

## extends is like tying a script to a node in your scene, here we reference it by the type of node, not the name, since scripts are tied directly to nodes
extends Camera2D

## export refers to making a variable of your choice available in the inpector tab to the right
## here we export the variable "TileMap" allowing us to select the TileMap node attached to the world
@export var tilemap: TileMap

## "_ready():" is a native function of Godot that is called when the node and it's children have been loaded
## "var mapRect = tilemap.get_used_rect()" retrieves the rectangular area used by the tiles in TileMap using "tilemap.get_used_rect()" stored as mapRect
## "var tileSize = tilemap.cell_quadrant_size" is used to retrieve the size of a singular tile within the TileMap stored as tileSize
## "var worldSizeInPixels = mapRect.size * tileSize" is used to retrieve the size of the world in pixels using "mapRect" multiplying it by the size of a single tile "tileSize"
## "limit_right = worldSizeInPixels.x" sets the limit of the camera on the x coordinate in pixels
## "limit_bottom = worldSizeInPixels.y" sets the limit of the camera on the y coordinate in pixels
## this is intended to capture the painted 2D tilemaps boundaries based on where tiles are placed, allowing for the camera to not have pre-defined variables for the amount of pixels on x and y that make up the map
func _ready():
	var mapRect = tilemap.get_used_rect()
	var tileSize = tilemap.cell_quadrant_size
	var worldSizeInPixels = mapRect.size * tileSize
	limit_right = worldSizeInPixels.x
	limit_bottom = worldSizeInPixels.y
