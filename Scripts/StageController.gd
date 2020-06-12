extends Node2D

export var MAX_TIME = 10
export (String, FILE,"*.tscn") var NEXT_LEVEL_SCENE
var time = MAX_TIME

func _ready():
	var pause_instance = preload("res://Scenes/Menus/PauseMenu.tscn").instance()
	add_child(pause_instance)
	pass
	
func _process(delta):
	time -= delta
#	if time <=0:
		#GameController.change_scene(NEXT_LEVEL_SCENE)

func _on_ObjectiveArea_body_entered(body):
	if body.name == "Player":
		GameController.change_scene(NEXT_LEVEL_SCENE)	
	pass # Replace with function body.
