class_name Player extends RigidBody3D

var Mirth: float = randf() # Joy, merryment, jolly
var Perspicacity: float = randf() # Insight, gile, foresight
var Historical_materialism : float = randf() # Understaing of history from a materialist lens
var Misanthropy: float = randf() # Aversion and distrust of others
var Equine: float = randf() # Horses and their associated kin
var Green: float = randf() # the color
var Kitsch: float = randf() # Gaudiness or affectionate unfashionability
var Mercator: float = randf() # Method of project a sphere onto a plane
var Fatherhood: float = randf() # Siring the next generation through masculinity
var Appropriation: float = randf() # Adapting anothers components to advantage yourself
var Intelligence: float = randf() # The basis for mana and spell resistance
var Girth: float = randf() # Width divided by height
var Chutzpah: float = randf() # Audacity
var Marketability: float = randf() # The capacity to create a marketable franchise
var Misnomer: float = randf() # a wrong or inaccurate name or designation

var terminal_velocity: float = -150
var gravity: float = -100
var jump_force: float = 40
var acceleration: float = 200
var max_speed: float = 50
var max_jumps: int = 2
var friction: float = 90
var bullet_velocity: float = 30
var shot_delay: float = 0.8
var max_health: float = 200
var damage: float = 20
var accuracy: float = 1

var jump_held: bool = false
var on_ground: bool = false
var jumps: int = 2
var right_movement: bool = true
var launching: bool = false
var bullet: PackedScene = preload("res://Alex_Battle_Stuff/bullet.tscn")
@export var retical: Retical = null
@export var player_ID: int = 0
@export var controller_retical: Node3D = null
var shot_timer: float = 0
var current_health: float = max_health

func _ready() -> void:
	GlobalPlayerData.PlayersAlive += 1
	if (GlobalPlayerData.PlayerData[player_ID] != null):
		$MeshGenExample.setMesh(GlobalPlayerData.PlayerData[player_ID])
		apply_ratings(GlobalPlayerData.PlayerScores[player_ID])
func apply_ratings(ratings:Array):
	Mirth = ratings[0]
	Perspicacity = ratings[1]
	Historical_materialism = ratings[2]
	Misanthropy = ratings[3]
	Equine = ratings[4]
	Green = ratings[5]
	Kitsch = ratings[6]
	Mercator = ratings[7]
	Fatherhood = ratings[8]
	Appropriation = ratings[9]
	Intelligence = ratings[0]
	Girth = ratings[1]
	Chutzpah = ratings[2]
	Marketability = ratings[3]
	Misnomer = ratings[4]

func _physics_process(delta) -> void:
	move(delta)
	
	shot_timer += delta
	
	if (Input.get_connected_joypads()):
		#Movement
		var input_direction: float = acceleration
		input_direction *= Input.get_joy_axis(player_ID, JoyAxis.JOY_AXIS_LEFT_X)
		self.linear_velocity.z = 0
		linear_velocity.x += input_direction * delta
		
		if(linear_velocity.x > 2):
			($MeshGenExample as Node3D).global_rotation.y = deg_to_rad(45)
		elif(linear_velocity.x < 2):
			($MeshGenExample as Node3D).global_rotation.y = deg_to_rad(-45)
		else:
			($MeshGenExample as Node3D).global_rotation.y = deg_to_rad(0)
		
		#Jump
		if (Input.is_joy_button_pressed(player_ID, JoyButton.JOY_BUTTON_A) and not jump_held and jumps > 0):
			jump_held = true
			linear_velocity.y = jump_force
			jumps -= 1
			on_ground = false
			launching = false
		elif (not Input.is_joy_button_pressed(player_ID, JoyButton.JOY_BUTTON_A)):
			jump_held = false
		
		#Shooting
		controller_retical.rotation = Vector3(0,0, -atan2(Input.get_joy_axis(player_ID, JoyAxis.JOY_AXIS_RIGHT_X), -Input.get_joy_axis(player_ID, JoyAxis.JOY_AXIS_RIGHT_Y)))
		
		if (Input.is_joy_button_pressed(player_ID, JoyButton.JOY_BUTTON_RIGHT_SHOULDER) and shot_timer > shot_delay):
			shot_timer = 0
			var item:RigidBody3D = bullet.instantiate()
			self.get_parent().add_child(item)
			item.global_position = self.global_position
			item.damage = damage
			
			# Right stick aiming
			item.linear_velocity = (self.position + Vector3(Input.get_joy_axis(player_ID, JoyAxis.JOY_AXIS_RIGHT_X),-Input.get_joy_axis(player_ID, JoyAxis.JOY_AXIS_RIGHT_Y), 0)-item.position).normalized() * bullet_velocity
			item.linear_velocity.z = 0
			
			var offset:float = PI/2 - PI/2 * accuracy
			if (offset < 0):
				offset = 0
				
			item.linear_velocity = item.linear_velocity.rotated(Vector3(0,0,1), randf_range(-offset, offset))
			
			item.player_ID = player_ID
		
		
	#test this elif (was else, but crashed when clicking lol)
	elif (Input.is_action_just_pressed("fire") and shot_timer > shot_delay and retical != null):
		shot_timer = 0
		var item:RigidBody3D = bullet.instantiate()
		self.get_parent().add_child(item)
		item.global_position = self.global_position
		item.damage = damage
		
		item.linear_velocity = (retical.position-item.position).normalized() * bullet_velocity
		item.linear_velocity.z = 0
		
		var offset:float = PI - PI * accuracy
		if (offset < 0):
			offset = 0
			
		item.linear_velocity = item.linear_velocity.rotated(Vector3(0,0,1), randf_range(-offset, offset))
		
		item.player_ID = player_ID

func move(delta: float) -> void:
	var input_direction: float = acceleration
	input_direction *= Input.get_action_strength("right") - Input.get_action_strength("left") 
	linear_velocity.x += input_direction * delta
	
	if (input_direction > 0 and right_movement):
		right_movement = false
		linear_velocity.x = 0
	elif (input_direction < 0 and not right_movement):
		right_movement = true
		linear_velocity.x = 0
	
	if (not launching):
		if (linear_velocity.x > max_speed):
			linear_velocity.x = max_speed
		elif (linear_velocity.x < -max_speed):
			linear_velocity.x = -max_speed
	
	if (Input.is_action_just_pressed("jump") and jumps > 0):
		jump_held = true
		linear_velocity.y = jump_force
		jumps -= 1
		on_ground = false
		launching = false
	elif ((not jump_held) and linear_velocity.y > 5 and (not on_ground) and (not launching)):
		linear_velocity.y /= 2
	elif (not on_ground):
		linear_velocity.y += gravity * delta
		if (linear_velocity.y < terminal_velocity):
			linear_velocity.y = terminal_velocity
	else:
		launching = false
		if (linear_velocity.x > 0):
			linear_velocity.x -= friction * delta
			if (linear_velocity.x < 0):
				linear_velocity.x = 0
		elif (linear_velocity.x < 0):
			linear_velocity.x += friction * delta
			if (linear_velocity.x > 0):
				linear_velocity.x = 0
	
	if (Input.is_action_just_released("jump")):
		jump_held = false

func deal_damage(taken: float) -> void:
	current_health -= taken
	if (current_health <= 0):
		self.queue_free()

func rescale_stats() -> void:
	jump_force = 40 + (Mirth * 5) - (Chutzpah * 4)
	acceleration = 200 + (Equine * 20) - (Appropriation * 24) - (Girth * 20)
	max_speed = 50 + (Equine * 5) - (Appropriation * 6) - (Girth * 5)
	max_jumps = 2 + roundi(Mirth) + roundi(Chutzpah)
	friction = 90 + (Equine * 12)
	bullet_velocity = 30 + (Kitsch * 2) + (Mercator * 5) + (Intelligence * 10) + (Marketability * 5) - (Misnomer * 10)
	shot_delay = 0.8 - (Kitsch * 0.1) - (Mercator * 0.2) + (Fatherhood * 0.1) + (Intelligence * 0.1) - (Marketability * 0.2)
	max_health = 200 + (Historical_materialism * 20) - (Misanthropy * 25) + (Green * 40) + (Girth * 30)
	damage = 20 - (Mirth * 4) + (Misanthropy * 5) - (Green * 3) + (Kitsch * 1) + (Fatherhood * 4) + (Appropriation * 4) - (Marketability * 4) + (Misnomer * 15)
	accuracy = 1 + (Perspicacity * 0.2) - (Historical_materialism * 0.05) - (Equine * 0.05) - (Kitsch * 0.05) - (Mercator * 0.05)
	
	print(jump_force)
	print(acceleration)
	print(max_speed)
	print(max_jumps)
	print(friction)
	print(bullet_velocity)
	print(shot_delay)
	print(max_health)
	print(damage)
	print(accuracy)

func _on_area_3d_body_entered(body: Node):
	if (body.is_in_group("terrain")):
		jumps = max_jumps
		on_ground = true

func _on_area_3d_body_exited(body: Node):
	if (body.is_in_group("terrain")):
		jumps = max_jumps - 1
		on_ground = false


func _on_area_3d_2_body_entered(body: Node):
	if (body.is_in_group("border_bottom")):
		jumps = max_jumps - 1
		linear_velocity.y = -terminal_velocity / 2
		launching = true
		deal_damage(25)
	elif (body.is_in_group("border_top")):
		linear_velocity.y = terminal_velocity / 3
		launching = true
		deal_damage(25)
	elif (body.is_in_group("border_right")):
		linear_velocity.x = terminal_velocity
		launching = true
		deal_damage(25)
	elif (body.is_in_group("border_left")):
		linear_velocity.x = -terminal_velocity
		launching = true
		deal_damage(25)
