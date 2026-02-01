extends Node3D

@export var player_scn:PackedScene

func _ready() -> void:
	for i in Input.get_connected_joypads():
		print("p")
		var player:Player = player_scn.instantiate()
		self.add_child(player)
		player.global_position = self.global_position
		player.player_ID = i
	
	
	
	
