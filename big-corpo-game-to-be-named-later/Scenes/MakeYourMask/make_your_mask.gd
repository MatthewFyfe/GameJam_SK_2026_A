extends Node3D

#The 3 image files we will pass on to the 3D preview system
var baseMask: Image
var heightMapMask: Image
var paintedMask: Image

#Note: PainterCanvas extends Sprite2D
@export var painter_image : PainterCanvas
@export var PBack_image : Sprite2D
@export var Palette_grid_container : PainterPalettez
@export var MeshGen_ref : Node3D

@export var ButtonDoneMask : TextureButton
@export var ButtonDoneHeight : TextureButton
@export var ButtonDonePaint : TextureButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	ButtonDoneMask.disabled = false
	ButtonDoneHeight.disabled = true
	ButtonDonePaint.disabled = true
	pass # Replace with function body.


func _on_button_done_mask_pressed() -> void:
	#save this image as the base mask shape
	baseMask = painter_image.img.duplicate()
	#put mask shape in background so player can see it while height/color painting
	PBack_image.texture = ImageTexture.create_from_image(painter_image.img)
	painter_image.erase_canvas(2)
	Palette_grid_container.set_palette_mode(2)

	ButtonDoneMask.disabled = true
	ButtonDoneHeight.disabled = false
	ButtonDonePaint.disabled = true
	
	#hide this button
	
	


func _on_button_done_height_map_pressed() -> void:
	#save this image as the heightmap texture, swap to paint mode
	heightMapMask = painter_image.img.duplicate()
	painter_image.erase_canvas(3)
	Palette_grid_container.set_palette_mode(3)
	
	ButtonDoneMask.disabled = true
	ButtonDoneHeight.disabled = true
	ButtonDonePaint.disabled = false


func _on_button_done_painting_pressed() -> void:
	#save this image as the color texture
	paintedMask = painter_image.img.duplicate()
	
	MeshGen_ref.export_bean_mask(baseMask, heightMapMask, paintedMask)
	#get_tree().change_scene_to_file("res://Scenes/MeshGenExample.tscn")
