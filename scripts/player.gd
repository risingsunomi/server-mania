extends CharacterBody3D

const SPEED = 5.0
#const JUMP_VELOCITY = 4.5
const GRAVITY = 10.0
const MOUSE_CAM_SENSITIVITY_Y = 0.5
const MOUSE_CAM_SENSITIVITY_X = 0.5

var target_velocity = Vector3.ZERO

@onready var camera_mount = $CameraMount
@onready var _anime_tree = $hoodie_blender_remix/AnimationTree
#@onready var _anime_player = $hoodie_blender_remix/AnimationPlayer

func _ready():
	# capture mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(
			deg_to_rad(-event.relative.x*MOUSE_CAM_SENSITIVITY_Y))
		camera_mount.rotate_x(
			deg_to_rad(event.relative.y*MOUSE_CAM_SENSITIVITY_X))
			
		
		
func _physics_process(delta: float) -> void:
	# check if floating
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	
	# add use
	# currently animation is not playing
	#if Input.is_key_pressed(KEY_E):
		#print("E pressed")
		#$hoodie_blender_remix/AnimationPlayer.play("CharacterArmature|Interact")
		
	var input_dir = Input.get_vector("right", "left", "down", "up")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var blend_direction = Vector2(direction.x, direction.z).normalized().abs()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	# setup anime tree stuff for run and idle
	_anime_tree.get("parameters/playback").travel("Idle")
	if blend_direction != Vector2.ZERO:
		_anime_tree.set("parameters/Idle/Blend2/blend_amount", 1)
	else:
		_anime_tree.set("parameters/Idle/Blend2/blend_amount", 0)
		
	#var look_direction = global_position + (-1 * velocity)
		#var vec_up = Vector3.UP
		#if vec_up.cross(look_direction - global_position).is_zero_approx() != true:
			#look_at(look_direction, Vector3.UP)

	move_and_slide()
	
	# add collision detection
	var collision_object = null
	var collision_count = get_slide_collision_count()
	for i in collision_count:
		collision_object = get_slide_collision(i)
		var collider = collision_object.get_collider()
		if collider and collider.name == "ServerRack":
			collider.server_pushed(self)
