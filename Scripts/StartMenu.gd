extends Control
var focus_option = 0

func _ready():
	$Mid/VBoxContainer/Play.grab_focus()
	pass

func _on_Play_pressed():
	PlayerVariables.health = PlayerVariables.INITIAL_HEALTH
	GameController.change_scene("res://Scenes/Stages/Stage1.tscn")
	pass

func _on_Quit_pressed():
	get_tree().quit()
	pass

func _on_Options_pressed():
	GameController.change_scene("res://Scenes/Menus/OptionsMenu.tscn")
	pass

func _on_HighScores_pressed():
	GameController.change_scene("res://Scenes/Menus/HighScoreMenu.tscn")
	pass

func _on_Credits_pressed():
	GameController.change_scene("res://Scenes/Menus/CreditsMenu.tscn")
	pass
	
