@tool
extends Node3D
@export var Scenes : Array[PackedScene]:
	set(v):
		Scenes = v
		_set_grid()
@export var grid_dimensions : Vector3i = Vector3i.ONE :
	set(_v):
		grid_dimensions = _v
		if grid_dimensions[grid_dimensions.min_axis_index()] == 0:
			grid_dimensions[grid_dimensions.min_axis_index()] = 1
		_set_grid()

@export var grid_spacing : Vector3 = Vector3.ONE :
	set(_v):
		grid_spacing = _v
		_set_grid()
@export var random_rotate : bool = false :
	set(_v):
		random_rotate = _v
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
		print("{name}: Please set atleast one Scene".format({"name": self.name}))
	else:
		for coord in _positions:
			var instance = Scenes.pick_random().instantiate()
			instance.name = "_grid_placer_" + str(instance.get_instance_id())
			if random_rotate:
					instance.rotate(Vector3.UP,deg_to_rad(90 * (randi() % 4)))
			add_child(instance)
			instance.global_transform.origin = coord + self.global_transform.origin
			instance.owner = self

func _clear_children():
	for c in get_children():
		if c.name.begins_with("_grid_placer_"):
			remove_child(c)
			c.queue_free()
