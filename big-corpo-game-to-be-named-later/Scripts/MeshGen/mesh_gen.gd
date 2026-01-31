extends Node

@export var mesh:MeshInstance3D

var texture: Image = Image.new()

var height: Image = Image.new()

@export var mat:Material

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	texture.load("res://Textures/maaaask.png")
	height.load("res://Textures/HEEIGHT.png")
	
	var stool = SurfaceTool.new()
	
	stool.begin(Mesh.PRIMITIVE_TRIANGLES)
	for x in range(255):
		for y in range(255):
			var c := texture.get_pixel(x,y)
			var h := height.get_pixel(x,y)
			var h10 := height.get_pixel(x+1,y)
			var h01 := height.get_pixel(x,y+1)
			var h11 := height.get_pixel(x+1,y+1)
			if(c.r > 0):
				stool.set_uv(Vector2(x/256.0,y/256.0))
				stool.add_vertex(Vector3(x-128,y-128,h.r*25.0))
				stool.add_vertex(Vector3(x-128+1,y-128,h10.r*25.0))
				stool.add_vertex(Vector3(x-128+1,y-128+1,h11.r*25.0))
				stool.add_vertex(Vector3(x-128,y-128,h.r*25.0))
				
				stool.add_vertex(Vector3(x-128+1,y-128+1,h11.r*25.0))
				stool.add_vertex(Vector3(x-128,y-128+1,h01.r*25.0))
	mesh.mesh = stool.commit()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mesh.rotation.y += delta
	pass
