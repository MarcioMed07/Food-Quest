extends Control
var options = preload("res://Scripts/OptionsMenu.gd").new()

func _ready():
	visible = false
	$".".add_child(options)
	options.refresh_screen_options($ColorRect/VBox/ScreenMode/ScreenModeButton,$ColorRect/VBox/Resolution/ResolutionButton)
	pass # Replace with function body.
func _input(event):
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func toggle_pause():
	var cur_pause_state = get_tree().paused
	get_tree().paused = !cur_pause_state
	visible = !cur_pause_state

func _on_MainMenu_pressed():
	get_tree().paused = false
	GameController.change_scene("res://Scenes/Menus/StartMenu.tscn")
	pass # Replace with function body.

func _on_Resume_pressed():
	toggle_pause()
	pass # Replace with function body.

func _on_MusicSlider_value_changed(value):
	$ColorRect/VBox/Music/MusicNumber.text = str(value).pad_zeros(3)
	pass

func _on_SoundSlider_value_changed(value):
	$ColorRect/VBox/Sound/SoundNumber.text = str(value).pad_zeros(3)
	pass


func _on_ResolutionButton_item_selected(id):
	options._on_ResolutionButton_item_selected(id)
	options.refresh_screen_options($ColorRect/VBox/ScreenMode/ScreenModeButton,$ColorRect/VBox/Resolution/ResolutionButton)
	pass # Replace with function body.


func _on_ScreenModeButton_item_selected(id):
	options._on_ScreenModeButton_item_selected(id)
	options.refresh_screen_options($ColorRect/VBox/ScreenMode/ScreenModeButton,$ColorRect/VBox/Resolution/ResolutionButton)
	pass # Replace with function body.
