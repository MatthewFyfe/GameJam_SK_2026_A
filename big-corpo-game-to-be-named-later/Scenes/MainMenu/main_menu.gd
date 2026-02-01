extends Node2D

var timeDelta = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MusicPlayer.playOceanAmbience()
	pass # Replace with function body.

func _process(delta):
	timeDelta += delta
	
	if(timeDelta > 5):
		var songToPlay = (randi() % 4)
		if(songToPlay == 0):
			$MusicPlayer.playD1()
		if(songToPlay == 1):
			$MusicPlayer.playD2()
		if(songToPlay == 2):
			$MusicPlayer.playD3()
		if(songToPlay == 3):
			$MusicPlayer.playD4()
		if(songToPlay == 4):
			$MusicPlayer.playD5()
		timeDelta = 0
	

func button_start() -> void:
	#get_tree().change_scene_to_file("res://Scenes/GameScene.tscn")
	get_tree().change_scene_to_file("res://Scenes/MakeYourMask/MakeYourMask1P.tscn")


func _on_start_button_2p_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MakeYourMask/MakeYourMask2P.tscn")
	pass # Replace with function body.


func _on_start_button_2p_2_pressed() -> void:
	
	get_tree().change_scene_to_file("res://Scenes/MakeYourMask/MakeYourMask4P.tscn")
	pass # Replace with function body.




func _on_start_button_2p_3_pressed() -> void:
	$Control/TextureButton.show()
	pass # Replace with function body.


func _on_texture_button_pressed() -> void:
	$Control/TextureButton.hide()
	pass # Replace with function body.
