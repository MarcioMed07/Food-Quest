extends Control

const SCREEN_MODES = ["Fullscreen","Borderless Windowed", "Windowed"]
const SCREEN_RESOLUTIONS = ["1366x768","1920x1080","1280x800","1440x900","1600x900","1024x768","1680x1050","1920x1200","1360x768","1280x720"]
#TODO: Save this somewhere
var screen_mode = 0
var screen_resolution = 0

func _ready():
	$VBox/Music/MusicSlider.grab_focus()
	for i in range(SCREEN_MODES.size()):
		$VBox/ScreenMode/ScreenModeButton.add_item(SCREEN_MODES[i], i)

	for i in range(SCREEN_RESOLUTIONS.size()):
		$VBox/Resolution/ResolutionButton.add_item(SCREEN_RESOLUTIONS[i], i)
	refresh_screen_options()
	pass

func refresh_screen_options():
	screen_mode = get_screen_mode()
	screen_resolution = get_screen_resolution()
	$VBox/ScreenMode/ScreenModeButton.selected = screen_mode
	$VBox/Resolution/ResolutionButton.selected = screen_resolution
	pass

func get_screen_mode():
	if OS.window_fullscreen == false:
		if OS.window_borderless == true:
			return 1
		else:
			return 2
	return 0

func get_screen_resolution():
	var size_str = str(OS.window_size.x,"x",OS.window_size.y)
	var aux = SCREEN_RESOLUTIONS.find(size_str)
	if aux == -1:
		$VBox/ScreenMode/ScreenModeButton.add_item(size_str,SCREEN_MODES.size())
		aux = SCREEN_RESOLUTIONS.find(size_str)
	return aux

func _on_Back_pressed():
	GameController.change_scene("res://Scenes/Menus/StartMenu.tscn")
	pass

func _on_MusicSlider_value_changed(value):
	$VBox/Music/MusicNumber.text = str(value).pad_zeros(3)
	pass

func _on_SoundSlider_value_changed(value):
	$VBox/Sound/SoundNumber.text = str(value).pad_zeros(3)
	pass

func _on_ScreenModeButton_item_selected(id):
	print(id, SCREEN_MODES[id])
	match id:
		0:
			OS.window_fullscreen = true
			OS.window_borderless = true
		1:
			OS.window_fullscreen = false
			OS.window_borderless = true
			_on_ResolutionButton_item_selected(0)
		2:
			OS.window_fullscreen = false
			OS.window_borderless = false
			_on_ResolutionButton_item_selected(0)
	refresh_screen_options()
	pass
func _on_ResolutionButton_item_selected(id):
	var size_str = SCREEN_RESOLUTIONS[id]
	var sizes = size_str.split("x")
	OS.window_size = Vector2(int(sizes[0]),int(sizes[1]))
	refresh_screen_options()
	pass
