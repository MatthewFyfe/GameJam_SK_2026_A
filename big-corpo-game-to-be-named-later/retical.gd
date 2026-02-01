class_name Retical extends Node3D

func _physics_process(_delta):
	var pos: Vector3 = Vector3.ZERO
	
	pos.x = get_viewport().get_mouse_position().x -get_viewport().get_visible_rect().size.x/2.0
	pos.y = -get_viewport().get_mouse_position().y +get_viewport().get_visible_rect().size.y/2.0
	
	pos.x *= $"../Camera3D".position.z/31.0
	pos.y *= $"../Camera3D".position.z/31.0
	
	pos.x /= get_viewport().get_visible_rect().size.x
	pos.y /= get_viewport().get_visible_rect().size.y
	
	pos.x *= 84
	pos.y *= 48
	
	self.position = pos 
