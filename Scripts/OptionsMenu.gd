extends Control

const SCREEN_MODES = ["Fullscreen","Borderless Windowed", "Windowed"]
const SCREEN_RESOLUTIONS = ["1366x768","1920x1080","1280x800","1440x900","1600x900","1024x768","1680x1050","1920x1200","1360x768","1280x720"]
#TODO: Save this somewhere
var screen_mode = 0
var screen_resolution = 0

func _ready():
	if $VBox/Music/MusicSlider:
		$VBox/Music/MusicSlider.grab_focus()
	
	refresh_screen_options($VBox/ScreenMode/ScreenModeButton,$VBox/Resolution/ResolutionButton)
	pass

func refresh_screen_options(screen_mode_node, resolution_node):
	if !(screen_mode_node && resolution_node):
		return
	var curr_screen_modes = []
	for i in range(screen_mode_node.get_item_count()):
		curr_screen_modes.push_back (screen_mode_node.get_item_text(i))
		
	var curr_resolutions = []
	for i in range(resolution_node.get_item_count()):
		curr_resolutions.push_back (resolution_node.get_item_text(i))
		
	for i in range(SCREEN_MODES.size()):
		var aux = SCREEN_MODES[i]
		if curr_screen_modes.find(aux) == -1:
			screen_mode_node.add_item(aux, i)
			
	for i in range(SCREEN_RESOLUTIONS.size()):
		var aux = SCREEN_RESOLUTIONS[i]
		if curr_resolutions.find(aux) == -1:
			resolution_node.add_item(SCREEN_RESOLUTIONS[i], i)
	screen_mode = get_screen_mode()
	screen_resolution = get_screen_resolution(resolution_node)
	screen_mode_node.selected = screen_mode
	resolution_node.selected = screen_resolution
	pass

func get_screen_mode():
	if OS.window_fullscreen == false:
		if OS.window_borderless == true:
			return 1
		else:
			return 2
	return 0

func get_screen_resolution(resolution_node):
	var size_str = str(OS.window_size.x,"x",OS.window_size.y)
	var aux = SCREEN_RESOLUTIONS.find(size_str)
	if aux == -1:
		resolution_node.add_item(size_str,SCREEN_MODES.size())
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
	refresh_screen_options($VBox/ScreenMode/ScreenModeButton,$VBox/Resolution/ResolutionButton)
	pass
func _on_ResolutionButton_item_selected(id):
	var size_str = SCREEN_RESOLUTIONS[id]
	var sizes = size_str.split("x")
	OS.window_size = Vector2(int(sizes[0]),int(sizes[1]))
	refresh_screen_options($VBox/ScreenMode/ScreenModeButton,$VBox/Resolution/ResolutionButton)
	pass
