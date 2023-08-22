@tool
extends EditorPlugin

var grid_placer = preload("res://addons/GridPlacer/GridPlacer.gd").new()

func _enter_tree():
	add_custom_type(
		"GridPlacer",
		"Node3D",
		preload("res://addons/GridPlacer/GridPlacer.gd"),
		preload("res://addons/GridPlacer/gridplacericon.png")
	)

func _exit_tree():
	# Clean up
	remove_custom_type("GridPlacer")
