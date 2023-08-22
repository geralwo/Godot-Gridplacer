@tool
extends Node3D
@export var Scenes : Array[PackedScene]:
	set(v):
		Scenes = v
		_update_grid()
@export var grid_dimensions : Vector3i = Vector3i.ONE :
	set(_v):
		grid_dimensions = _v
		while grid_dimensions[grid_dimensions.min_axis_index()] == 0:
			grid_dimensions[grid_dimensions.min_axis_index()] = 1
		_update_grid()

@export var grid_spacing : Vector3 = Vector3.ONE :
	set(_v):
		grid_spacing = _v
		_update_grid()
@export var instance_scale : Vector3 = Vector3.ONE
@export var random_rotate : bool = false :
	set(_v):
		random_rotate = _v
		notify_property_list_changed()
		_update_grid()
var random_rotate_x : bool = false :
	set(_v):
		random_rotate_x = _v
		_update_grid()
var random_rotate_y : bool = true :
	set(_v):
		random_rotate_y = _v
		_update_grid()
var random_rotate_z : bool = false :
	set(_v):
		random_rotate_z = _v
		_update_grid()

func _update_grid():
	if is_inside_tree():
		_set_grid()

func _set_grid():
		_clear_children()
		var _positions = []
		for x in range(grid_dimensions.x):
			for y in range(grid_dimensions.y):
				for z in range(grid_dimensions.z):
					var _offset = Vector3()
					_offset.x = x * grid_spacing.x
					_offset.y = y * grid_spacing.y
					_offset.z = z * grid_spacing.z
					_positions.append(_offset)
		if Scenes.size() == 0:
			print("{name}: Please set atleast one Scene".format({"name": name}))
		else:
			for coord in _positions:
				var instance = Scenes.pick_random()
				if instance:
					instance = instance.instantiate()
				else:
					return
				instance.name = "_grid_placer_" + str(instance.get_instance_id())
				if random_rotate:
					if random_rotate_x:
						instance.rotate_x(deg_to_rad(90 * (randi() % 4)))
					if random_rotate_y:
						instance.rotate_y(deg_to_rad(90 * (randi() % 4)))
					if random_rotate_z:
						instance.rotate_z(deg_to_rad(90 * (randi() % 4)))
				instance.scale = instance_scale
				add_child(instance)
				instance.global_transform.origin = coord + self.global_transform.origin
				instance.owner = self.owner

func _clear_children():
	for c in get_children():
		if c.name.begins_with("_grid_placer_"):
			remove_child(c)
			c.queue_free()

func _get_property_list():
	var properties = []

	if random_rotate:
		properties.append({
			"name": "random_rotate_x",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT
		})
		properties.append({
			"name": "random_rotate_y",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT
		})
		properties.append({
			"name": "random_rotate_z",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT
		})

	return properties
