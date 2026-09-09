extends Usable

@onready var raycast = $RayCast3D
@onready var particles = $GPUParticles3D
func use(player: Player):
	var collider = raycast.get_collider();
	if(collider is RigidBody3D):
		collider.apply_impulse(Vector3(0, 0, 500) * position.direction_to(collider.position));
	particles.restart()
