class_name Player extends RigidBody3D

var Mirth: float = 0 # Joy, merryment, jolly
var Perspicacity: float = 0 # Insight, gile, foresight
var Historical_materialism : float = 0 # Understaing of history from a materialist lens
var Misanthropy: float = 0 # Aversion and distrust of others
var Equine: float = 0 # Horses and their associated kin
var Green: float = 0 # the color
var Kitsch: float = 0 # Gaudiness or affectionate unfashionability
var Mercader: float = 0 # Method of project a sphere onto a plane
var Fatherhood: float = 0 # Siring the next generation through masculinity
var Appropriation: float = 0 # Adapting anothers components to advantage yourself
var Intelligence: float = 0 # The basis for mana and spell resistance
var Girth: float = 0 # Width divided by height
var Chutzpah: float = 0 # Audacity
var Marketability: float = 0 # The capacity to create a marketable franchise
var Misnomer: float = 0 # a wrong or inaccurate name or designation

var jump_held: bool = false
var on_ground: bool = false
var jumps: int = 2
var right_movement: bool = true
var launching: bool = false
var bullet: PackedScene = preload("res://Alex_Battle_Stuff/bullet.tscn")
@export var retical: Retical = null
@export var player_ID: int = 0
var shot_timer: float = 0

var terminal_velocity: float = -150
var gravity: float = -100
var jump_force: float = 40
var acceleration: float = 200
var max_speed: float = 50
var max_jumps: int = 40
var friction: float = 90
var bullet_velocity: float = 30
var shot_delay: float = 0.8

func _physics_process(delta) -> void:
	move(delta)
	
	shot_timer += delta
	
	if (Input.get_connected_joypads()):
		
		
		#Movement
		var input_direction: float = acceleration
		input_direction *= Input.get_joy_axis(player_ID, JoyAxis.JOY_AXIS_LEFT_X)
		self.linear_velocity.z = 0
		linear_velocity.x += input_direction * delta
		
		#Jump
		if (Input.is_joy_button_pressed(player_ID, JoyButton.JOY_BUTTON_A) and not jump_held):
			jump_held = true
			linear_velocity.y = jump_force
			jumps -= 1
			on_ground = false
			launching = false
		elif (not Input.is_joy_button_pressed(player_ID, JoyButton.JOY_BUTTON_A)):
			jump_held = false
		
		#Shooting
		if (Input.is_joy_button_pressed(player_ID, JoyButton.JOY_BUTTON_RIGHT_SHOULDER) and shot_timer > shot_delay):
			shot_timer = 0
			var item:RigidBody3D = bullet.instantiate()
			self.get_parent().add_child(item)
			item.global_position = self.global_position
			
			
			# Right stick aiming
			item.linear_velocity = (self.position + Vector3(Input.get_joy_axis(player_ID, JoyAxis.JOY_AXIS_RIGHT_X),-Input.get_joy_axis(player_ID, JoyAxis.JOY_AXIS_RIGHT_Y), 0)-item.position).normalized() * bullet_velocity
			item.linear_velocity.z = 0
			
			item.player_ID = player_ID
		
		
	#test this elif (was else, but crashed when clicking lol)
	elif (Input.is_action_just_pressed("fire") and shot_timer > shot_delay):
		shot_timer = 0
		var item:RigidBody3D = bullet.instantiate()
		self.get_parent().add_child(item)
		item.global_position = self.global_position
		
		item.linear_velocity = (retical.position-item.position).normalized() * bullet_velocity
		item.linear_velocity.z = 0
		
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

func deal_damage(ID: int) -> void:
	pass

func _on_area_3d_body_entered(body: Node):
	if (body.is_in_group("terrain")):
		jumps = max_jumps
		on_ground = true

func _on_area_3d_body_exited(body: Node):
	if (body.is_in_group("terrain")):
		jumps = max_jumps - 1
		on_ground = false


func _on_area_3d_2_body_entered(body: Node):
	launching = true
	if (body.is_in_group("border_bottom")):
		linear_velocity.y = -terminal_velocity / 2
	elif (body.is_in_group("border_top")):
		linear_velocity.y = terminal_velocity / 4
	elif (body.is_in_group("border_right")):
		linear_velocity.x = terminal_velocity
	elif (body.is_in_group("border_left")):
		linear_velocity.x = -terminal_velocity
