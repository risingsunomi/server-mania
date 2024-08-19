extends RigidBody3D

var is_grabbed = false
var is_pushed = false
var t = 0.0

@onready var player = $"../Player"

func server_pushed(player: CharacterBody3D):
	print("pushed by player!")
	var direction = (
		transform.basis * Vector3(
			player.position.x, 0, player.position.z
	)).normalized()
	
	# making static but need to make dynamic depending on the velocity
	var force_strength = 10.0
	# var force_strength = player.velocity.z
	apply_impulse(direction * force_strength, Vector3.ZERO)

func _load():
	print("server_rack script loaded")
	set_physics_process(true)
	
func _ready():
	add_to_group("objective_items")

func _physics_process(delta: float) -> void:
	pass
		
