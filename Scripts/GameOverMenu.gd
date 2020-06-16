extends Control

func _ready():
	visible = false
	pass

func _process(_delta):
	if PlayerVariables.health <= 0:
		visible = true

func _on_MainMenu_pressed():
	GameController.change_scene("res://Scenes/Menus/StartMenu.tscn")
	pass

func _on_QuitGame_pressed():
	get_tree().quit()
	pass
