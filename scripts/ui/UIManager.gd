extends CanvasLayer
## Gestor de la interfaz de usuario del juego.
## Controla HUD, inventario, menús y pantallas.

class_name UIManager

var is_pause_menu_open: bool = false
var is_inventory_open: bool = false

func _ready() -> void:
	print("[UIManager] Interfaz inicializada")

func _process(_delta: float) -> void:
	handle_inputs()
	update_hud()


## Maneja la entrada del usuario en UI
func handle_inputs() -> void:
	# Pause (ESC)
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause_menu()
	
	# Inventario (I)
	if Input.is_action_just_pressed("ui_focus_next"):
		toggle_inventory()


## Actualiza los elementos del HUD
func update_hud() -> void:
	if not GameManager.instance:
		return
	
	var economy_manager = GameManager.instance.get_economy_manager()
	var mission_manager = GameManager.instance.get_mission_manager()
	var player = GameManager.instance.player
	
	if not economy_manager or not player:
		return
	
	# Actualizar información
	var total_money = economy_manager.get_total_money()
	var level = player.get_player_level()
	var experience = player.get_player_experience()
	var energy_percent = (player.get_current_energy() / player.get_max_energy()) * 100.0
	
	print("Dinero: $%.2f | Nivel: %d | XP: %d | Energía: %.1f%%" % [total_money, level, experience, energy_percent])


## Alterna el menú de pausa
func toggle_pause_menu() -> void:
	is_pause_menu_open = !is_pause_menu_open
	
	if is_pause_menu_open:
		GameManager.instance.pause_game()
		print("[UIManager] Menú de pausa abierto")
	else:
		GameManager.instance.resume_game()
		print("[UIManager] Menú de pausa cerrado")


## Alterna el inventario
func toggle_inventory() -> void:
	is_inventory_open = !is_inventory_open
	print("[UIManager] Inventario %s" % ("abierto" if is_inventory_open else "cerrado"))


## Muestra un diálogo
func show_dialog(dialog_text: String) -> void:
	print("[UIManager] Diálogo: %s" % dialog_text)


## Muestra una notificación
func show_notification(message: String) -> void:
	print("[UIManager] Notificación: %s" % message)
