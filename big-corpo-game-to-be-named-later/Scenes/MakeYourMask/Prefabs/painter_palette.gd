extends GridContainer

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
