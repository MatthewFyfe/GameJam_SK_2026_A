extends GridContainer
class_name PainterPalettez

#set ref to painter canvas image
@export var painter_image : Sprite2D
@export var current_color_rect : ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c:ColorRect in get_children():
		c.gui_input.connect(func(input):
			if input is InputEventMouseButton:
				if input.pressed and input.button_index == MOUSE_BUTTON_LEFT:
					painter_image.paint_color = c.color
					#current_color_rect.color = c.color
		)			
	set_palette_mode(1)

#Mode 1 = black/white define mask geometry
#Mode 2 = greyscale define mask heightmap
#Mode 3 = color define map texture
func set_palette_mode(mode : int) -> void :
	var index = 0
	#set to black/white only
	if mode == 1:
		for child in get_children():
			if index != 0 and index != 1:
				child.visible = false
			index += 1
			
	#set to greyscale
	if mode == 2:
		for child in get_children():
			if index != 0 and index != 1:
				child.visible = false
			index += 1
		#TODO: make drawing mode additive/subtractive
	
	#unlock all colors
	if mode == 3:
		for child in get_children():
			child.visible = true
