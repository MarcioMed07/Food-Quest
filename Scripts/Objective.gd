extends Area2D

export var type = 0

func _process(_delta):
	for body in get_overlapping_bodies():
		if body.name == "Player":
			var curr_stage = int(get_tree().current_scene.name.replace("Stage",""))
			var next_stage = curr_stage + 1
			get_tree().change_scene("res://Scenes/Stages/Stage"+String(next_stage)+".tscn")
	pass
