extends Node

@export var mesh:MeshInstance3D

var texture: Image = Image.new()

var height: Image = Image.new()

@export var mat:Material

var ratings:Array[float] = []

@export var mask_rating:MaskRating

@export var bean_container:Node3D

#@export var 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#texture.load("res://Textures/GMaks.png")
	#height.load("res://Textures/GHeight.png")
	
	texture.load("res://Textures/maaaask.png")
	height.load("res://Textures/HEEIGHT.png")
	var color:Image = Image.new()
	color.load("res://Textures/Imrg.png")
	
	mesh.mesh = generate_mesh(texture,height)
	
	#mask_rating.rate_textures(texture,height,texture)
	#texture.load("res://Textures/GMaks.png")
	#mask_rating.rate_textures(texture,height,color)
	pass # Replace with function body.
	

#Matt sends the art here
func export_bean_mask(maskShape, maskDepth, maskColor):	
	var imgtex : ImageTexture = ImageTexture.create_from_image(maskColor)
	(mesh.material_override as StandardMaterial3D).albedo_texture = imgtex
	mesh.mesh = generate_mesh(maskShape, maskDepth)

func generate_mesh(mask:Image,depth:Image) -> ArrayMesh:
	var thickness:float = 5.0
	#texture.load("res://Textures/GMaks.png")
	#height.load("res://Textures/GHeight.png")
	
	texture.load("res://Textures/maaaask.png")
	height.load("res://Textures/HEEIGHT.png")
	
	var stool := SurfaceTool.new()
	var indx := 0
	var sizx:float = mask.get_size().x
	var sizy:float = mask.get_size().y
	
	stool.begin(Mesh.PRIMITIVE_TRIANGLES)
	for x in range(mask.get_size().x-1):
		for y in range(mask.get_size().y-1):
			var c := mask.get_pixel(x,y)
			var h := depth.get_pixel(x,y)
			var h10 := depth.get_pixel(x+1,y)
			var h01 := depth.get_pixel(x,y+1)
			var h11 := depth.get_pixel(x+1,y+1)
			if(c.a8 > 20):
				stool.set_uv(Vector2(x/sizx,y/sizy))
				stool.add_vertex(Vector3(x-(sizx/2.0),y-(sizy/2.0),h.a*25.0))
				stool.add_vertex(Vector3(x-(sizx/2.0),y-(sizy/2.0)+1,h01.a*25.0))
				stool.add_vertex(Vector3(x-(sizx/2.0)+1,y-(sizy/2.0),h10.a*25.0))
				stool.add_vertex(Vector3(x-(sizx/2.0)+1,y-(sizy/2.0)+1,h11.a*25.0))
				
				populate_verticies(stool, indx)
				
				indx += 4
				
				stool.set_uv(Vector2(x/sizx,y/sizy))
				stool.add_vertex(Vector3(x-(sizx/2.0),y-(sizy/2.0),h.a*25.0 - thickness))
				stool.add_vertex(Vector3(x-(sizx/2.0),y-(sizy/2.0)+1,h01.a*25.0 - thickness))
				stool.add_vertex(Vector3(x-(sizx/2.0)+1,y-(sizy/2.0),h10.a*25.0 - thickness))
				stool.add_vertex(Vector3(x-(sizx/2.0)+1,y-(sizy/2.0)+1,h11.a*25.0 - thickness))
				
				populate_verticies(stool, indx)
				
				indx += 4
				
				stool.set_uv(Vector2(x/sizx,y/sizy))
				stool.add_vertex(Vector3(x-(sizx/2.0),y-(sizy/2.0),h.a*25.0))
				stool.add_vertex(Vector3(x-(sizx/2.0),y-(sizy/2.0)+1,h01.a*25.0))
				stool.add_vertex(Vector3(x-(sizx/2.0),y-(sizy/2.0),h.a*25.0 - thickness))
				stool.add_vertex(Vector3(x-(sizx/2.0),y-(sizy/2.0)+1,h01.a*25.0 - thickness))
				
				populate_verticies(stool, indx)
				
				indx += 4
				
				stool.set_uv(Vector2(x/sizx,y/sizy))
				stool.add_vertex(Vector3(x-(sizx/2.0)+1,y-(sizy/2.0),h10.a*25.0))
				stool.add_vertex(Vector3(x-(sizx/2.0)+1,y-(sizy/2.0)+1,h11.a*25.0))
				stool.add_vertex(Vector3(x-(sizx/2.0)+1,y-(sizy/2.0),h10.a*25.0 - thickness))
				stool.add_vertex(Vector3(x-(sizx/2.0)+1,y-(sizy/2.0)+1,h11.a*25.0 - thickness))
				
				populate_verticies(stool, indx)
				
				indx += 4
				
	stool.generate_normals(true)
	return stool.commit()

func populate_verticies(stool:SurfaceTool, indx:int):
	stool.add_index(indx+0)
	stool.add_index(indx+1)
	stool.add_index(indx+2)
	
	stool.add_index(indx+1)
	stool.add_index(indx+3)
	stool.add_index(indx+2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#mesh.rotation.y += delta
	if(bean_container != null):
		if(Input.is_action_pressed("ui_left")):
			bean_container.rotation.y -= delta
		if(Input.is_action_pressed("ui_right")):
			bean_container.rotation.y += delta
	pass
