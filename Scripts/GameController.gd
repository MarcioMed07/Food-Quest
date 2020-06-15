extends Node

var cur_stage_path = "res://Scenes/Menus/StartMenu.tscn"
var cur_stage
func _ready():
	change_scene(cur_stage_path)
	pass
	
func change_scene(new_stage_path):
	print(cur_stage)
	if cur_stage && cur_stage.get_parent():
		cur_stage.get_parent().remove_child(cur_stage)
	cur_stage = load(new_stage_path).instance()
	get_node("/root/Game").add_child(cur_stage)
	pass
