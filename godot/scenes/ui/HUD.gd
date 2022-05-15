extends Control

var languages_list = ["zh", "en"]
var level_progress = 0

var is_menu_shown = false

onready var menu_btn = $VBoxC/MarginC/HBoxC/Menu
onready var menu_panel = $VBoxC/MenuPanel
onready var result_panel = $ResultPanel
onready var tween = $Tween
onready var lang_btn = $VBoxC/MenuPanel/VBoxC/HBoxCButton/Languages
onready var dialog = $DialogPanel
onready var notification_c = $NotificationContainer


func _ready():
	Logger.add_module("HUD")
	
	show()
	result_panel.hide()
	Global.hud = self
	_hide_menu()
	result_panel.hide()
	Global.connect("locale_changed", self, "_when_locale_changed")
	
	#var level_name = get_parent().get_parent().get("level_name")
	#if level_name is String:
	#	$MapLabel.text = level_name


func add_notification(p_text : String):
	notification_c.add_notification(p_text)


func show_result_panel():
	# Hide menu buttons.
	menu_btn.hide()
	menu_panel.hide()
	result_panel.show_when_level_is_clear("Level 0", 10, 10)


func _show_menu():
	$Joystick.hide()
	
	# Show menu panel with transition.
	menu_panel.show()
	tween.remove_all()
	tween.interpolate_property(menu_panel, "modulate", Color.transparent, Color.white, 0.2)
	tween.start()
	
	get_tree().paused = true
	$BlurShader.change_blur_amount(2, 0.5)


func _hide_menu():
	$Joystick.show()
	
	# Hide menu panel with transition.
	tween.remove_all()
	tween.interpolate_property(menu_panel, "modulate", Color.white, Color.transparent, 0.2)
	tween.start()
	
	get_tree().paused = false
	$BlurShader.change_blur_amount(0, 0.5)


func _on_Menu_toggled(button_pressed):
	if button_pressed:
		_show_menu()
	else:
		_hide_menu()


func _on_Exit_pressed():
	get_node("/root/Main").loading_panel.load_scene("res://scenes/stages/Home.tscn")


func _on_Languages_pressed():
	# Get current locale.
	var old_locale = TranslationServer.get_locale()
	
	var index = languages_list.find(old_locale)
	
	# Change locale.
	if index > -1:
		index = (index + 1) % languages_list.size()
		var new_locale = languages_list[index]
		Global.change_locale(new_locale)
		
		# Change looking of the language button.
		lang_btn.get_child(0).texture = load("res://assets/ui/flags/%s.png" % new_locale)
	else:
		Logger.error("Failed to change language!", "HUD")


func _on_SFX_toggled(button_pressed):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), button_pressed)


func _on_Music_toggled(button_pressed):
	var bgm_player = get_node_or_null("/root/Main/BGMPlayer")
	
	if bgm_player:
		if button_pressed:
			bgm_player.decrease_volume_to_zero()
		else:
			bgm_player.increase_volume_to_normal()


func _when_locale_changed():
	_update_language()


func _update_language():
	pass


func _on_Menu_pressed():
	pass # Replace with function body.
