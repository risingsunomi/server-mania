extends Node3D

const scene = preload("res://scene1.tscn")
const server_rack_scene = preload("res://scenes/server_rack.tscn")

@onready var floor_node = $Floor
@onready var player = $Player

func load_servers() -> void:
	# get floor size
	var floor_size = floor_node.scale
	var floor_position = floor_node.global_position
	
	var num_instances = randi_range(100, 1000)
	var servers_placed = []
	for i in range(num_instances):
		# try to do a full clone with script and collision layers
		var server_rack = server_rack_scene.instantiate()
		
		var random_x = (randf() * 2.0 - 1.0) * floor_size.x * 0.5 + floor_position.x
		var random_z = (randf() * 2.0 - 1.0) * floor_size.z * 0.5 + floor_position.z
		var random_position = Vector3(random_x, 0, random_z)
		
		if random_position not in servers_placed and random_position != player.position:
			servers_placed.append(random_position)
			add_child(server_rack)
			server_rack.global_position = random_position
			

func _ready() -> void:
	load_servers()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
