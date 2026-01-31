extends Node3D

#The 3 image files we will pass on to the 3D preview system
var baseMask: Image
var heightMapMask: Image
var paintedMask: Image

#Note: PainterCanvas extends Sprite2D
@export var painter_image : PainterCanvas

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_button_done_mask_pressed() -> void:
	#TODO: save this image as the base mask shape, swap to height map mode
	baseMask = painter_image.img
	


func _on_button_done_height_map_pressed() -> void:
	#TODO: save this image as the heightmap texture, swap to paint mode
	heightMapMask = painter_image.img
	


func _on_button_done_painting_pressed() -> void:
	#TODO: save this image as the color texture
	paintedMask = painter_image.img
	
	get_tree().change_scene_to_file("res://Scenes/MeshGenExample.tscn")
