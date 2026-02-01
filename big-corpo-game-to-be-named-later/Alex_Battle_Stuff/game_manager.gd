extends Node3D

@export var player_scn:PackedScene
@export var retical_scn:PackedScene
@export var cont_retical_scn:PackedScene

func _ready() -> void:
	$"../AudioStreamPlayer3D".play()
	if (len(Input.get_connected_joypads()) < 1):
		var retical:Retical = retical_scn.instantiate()
		var player:Player = player_scn.instantiate()
		self.add_child(player)
		self.get_parent().add_child.call_deferred(retical)
		player.global_position = self.global_position
		player.player_ID = 0
		
		player.retical = retical
		player.rescale_stats()
	else:
		for i in Input.get_connected_joypads():
			var Cont:Node3D = cont_retical_scn.instantiate()
			var player:Player = player_scn.instantiate()
			self.add_child(player)
			player.add_child(Cont)
			player.global_position = self.global_position
			player.player_ID = i
			
			player.controller_retical = Cont
			player.rescale_stats()

func _process(delta: float) -> void:
	if(GlobalPlayerData.PlayersAlive == 0 && not $Control.visible):
		$Control.show()
		$Control/Label.text = "Player "+str(GlobalPlayerData.LastPlayerToDie)+" won!!!"
		$Control/Button.pressed.connect(on_to_main_menu_clicked)

func on_to_main_menu_clicked():
	get_tree().change_scene_to_file("res://Scenes/MainMenu/main_menu.tscn")
