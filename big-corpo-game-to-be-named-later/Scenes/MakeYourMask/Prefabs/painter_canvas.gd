extends Sprite2D
class_name PainterCanvas

#set up all our stamps here
@export var stamp: Texture2D
@export var mask: Texture2D

#set brush properties user is currenty using
@export var paint_color : Color = Color.WHITE :
	set(value):
		paint_color = value
		current_color_rect.color = value
		update_brush()
@export var brush_size := 10 :
	set(value):
		brush_size = value
		update_brush()
@export var current_color_rect: ColorRect
@export var brush_texture : Texture2D

#set canvas properties
@export var img_size := Vector2i(256,256)
@export var canvas_bg : Color
@export var canvas_bg2 : Color
@export var canvas_bg3 : Color

@export var img: Image
var brush_img : Image

var prev_mouse_pos:Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	#demo_paint_system()	
	update_brush()
	setup_real_paint_system()


#Demo/Test of how paint system works for dev purposes
func demo_paint_system() -> void:
	#setup empty canvas on screen (location set in inspector of this node)
	texture = ImageTexture.create_from_image(Image.create_empty(256, 256, false, Image.FORMAT_RGBA8))
	img = texture.get_image()
	
	#fill canvas with a gray background
	img.fill(canvas_bg)
	
	#ref to sticker
	var stamp_img = stamp.get_image()
	stamp_img.decompress()
	
	#place sticker at location 50,50
	#img.blit_rect(stamp_img, Rect2i(Vector2.ZERO, stamp.get_size()), Vector2i(50,50))
	img.blend_rect(stamp_img, Rect2i(Vector2.ZERO, stamp.get_size()), Vector2i(50,50))
	#img.blend_rect_mask(stamp_img, mask.get_image(), Rect2i(Vector2.ZERO, stamp.get_size()), Vector2i(50,50))
	
	#adjust Brightness, Color, Saturation of entire canvas
	#img.adjust_bcs(2.0, 1.0, 1.0)
	
	
	
	texture.update(img)

#Create and setup a paint canvas
func setup_real_paint_system() -> void:
	img = Image.create_empty(img_size.x, img_size.y, false, Image.FORMAT_RGBA8)
	img.fill(canvas_bg)
	texture = ImageTexture.create_from_image(img)
	
#Erase canvas
func erase_canvas(level : int) -> void:
	if level == 1 :
		img.fill(canvas_bg)
	elif level == 2 :
		img.fill(canvas_bg2)
	elif level == 3 :
		img.fill(canvas_bg3)
	
	texture = ImageTexture.create_from_image(img)

#Called every time we paint
func _paint_tex(pos) -> void:
	#when painting transparent (erase) use no brush (solid color only)
	if(paint_color == canvas_bg or paint_color == canvas_bg2 or paint_color == canvas_bg3):
		img.fill_rect(Rect2i(pos, Vector2i(1,1)).grow(brush_size/2.0), paint_color)
		
	#otherwise use brush texture
	else :
		img.blend_rect(brush_img, brush_img.get_used_rect(), pos - Vector2(brush_size/2.0, brush_size/2.0))
		
#Called if we need to update the brush
func update_brush() -> void:
	if brush_texture != null :
		brush_img = brush_texture.get_image()
		brush_img.resize(brush_size, brush_size, Image.INTERPOLATE_NEAREST)
		
		for x in brush_img.get_size().x:
				for y in brush_img.get_size().y:
					var cc := brush_img.get_pixel(x,y)
					brush_img.set_pixel(x,y,paint_color * cc)

#Player input and controls
func _input(event: InputEvent) -> void:
	#"Brush" click events
	if event is InputEventMouseButton:		
		if event.pressed and event.is_echo() == false:
			#left click to paint
			if event.button_index == MOUSE_BUTTON_LEFT:
				var localPosition = to_local(event.position)
				var imgPosition = localPosition-offset+get_rect().size/2.0
				
				if((imgPosition - prev_mouse_pos).length_squared() >28):
					prev_mouse_pos = imgPosition
					_paint_tex(imgPosition)
					texture.update(img)
			
			#right click to mimic color
			if event.button_index == MOUSE_BUTTON_RIGHT:
				var localPosition = to_local(event.position)
				var imgPosition = localPosition-offset+get_rect().size/2.0
				#If in canvas, get color from there, if outside canvas get color from viewport
				if img.get_used_rect().has_point(imgPosition):
					paint_color = img.get_pixelv(imgPosition)
				else:
					paint_color = get_viewport().get_texture().get_image().get_pixelv(event.position)
	#"Brush drag events
	if event is InputEventMouseMotion:
		if event.button_mask== MOUSE_BUTTON_LEFT:
			var localPosition = to_local(event.position)
			var imgPosition = localPosition-offset+get_rect().size/2.0
			
			if event.relative.length_squared() > 0:
				var num := ceili(event.relative.length())
				var target_pos = imgPosition - (event.relative)
				for i in num:
					imgPosition = imgPosition.move_toward(target_pos, 1.0)
					_paint_tex(imgPosition)
					
			texture.update(img)
		

#Player modified brush size
func _on_h_slider_value_changed(value: float) -> void:
	brush_size = int(value)

#Possible fix if we run into mipmap issues on 3D model
func mipmapFix() -> void:
	img.generate_mipmaps()
	texture.update(img)
	#OR set texture_filter on 3d model to not use mipmaps (LINEAR)
