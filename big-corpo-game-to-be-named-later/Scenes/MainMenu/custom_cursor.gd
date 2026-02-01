extends Node2D

@export var cursor : Sprite2D
@export var cursor2: Sprite2D
@export var cursor3: Sprite2D
@export var cursor4: Sprite2D

var mousePosition : Vector2
var mousePosition2 : Vector2
var mousePosition3: Vector2
var mousePosition4 : Vector2

var mouse_speed = 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set logic cursor to same position as sprite
	mousePosition = cursor.position
	mousePosition2 = cursor2.position
	mousePosition3 = cursor3.position
	mousePosition4 = cursor4.position
	
	#maybe hide the real mouse?
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	
func _update() -> void:
	pass
	
func _process(delta) -> void:
	#adjust cursor positions based on player input
	var mouse_rel = Vector2.ZERO
	if Input.is_action_pressed("mouse_up"):
		mouse_rel += Vector2.UP * mouse_speed
	
	
	
