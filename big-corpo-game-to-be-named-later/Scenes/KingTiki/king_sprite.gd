extends Control

@export var KingOpen : Sprite2D
@export var KingClosed : Sprite2D

var timePassed = 0
var mouthToggle = false


func _ready():
	pass
	
func _process(delta):
	#cycle between open and closed mouth every X frames
	timePassed += delta
	
	if(timePassed > 0):
		mouthToggle = !mouthToggle
		timePassed = randf_range(-0.5, -0.1)
	
	if(mouthToggle):
		KingOpen.visible = true
		KingClosed.visible = false
	else:
		KingOpen.visible = false
		KingClosed.visible = true
	
	pass
