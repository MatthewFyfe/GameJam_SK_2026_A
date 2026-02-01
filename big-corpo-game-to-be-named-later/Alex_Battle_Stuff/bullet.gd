class_name Bullet extends RigidBody3D

var player_ID: int = 0
var damage: float = 0
var timer: float = 0

func _physics_process(delta):
	timer += delta
	
	self.look_at(self.linear_velocity)

func _on_area_3d_body_entered(body: Node):
	if (body is Player):
		if (body.player_ID != player_ID or timer > 0.4):
			body.deal_damage(damage)
			self.queue_free()
	else:
		self.queue_free()
