extends Node
## Gestor central del juego. Controla el estado global y lógica principal.
## Patrón Singleton para acceso desde cualquier parte del juego.

class_name GameManager

# Singleton instance
static var instance: GameManager

# Enums
enum GameState { PLAYING, PAUSED, MENU, DIALOG, SHOPPING, INVENTORY }

# Variables
var current_game_state: GameState = GameState.PLAYING
var game_time: float = 0.0  # Tiempo en minutos
var time_scale: float = 1.0  # Velocidad del tiempo

# Referencias a managers
var economy_manager: EconomyManager
var mission_manager: MissionManager
var ui_manager: UIManager
var player: Node3D

func _ready() -> void:
	# Implementar Singleton
	if instance == null:
		instance = self
	else:
		queue_free()
		return
	
	print("[GameManager] Inicializando Finuturo 3D...")
	
	# Obtener referencias
	get_references()


func _process(delta: float) -> void:
	if current_game_state == GameState.PLAYING:
		game_time += delta * time_scale


## Obtiene las referencias de los managers
func get_references() -> void:
	economy_manager = get_node_or_null("EconomyManager")
	mission_manager = get_node_or_null("MissionManager")
	ui_manager = get_node_or_null("UIManager")
	
	if economy_manager == null:
		print("[GameManager] ERROR: EconomyManager no encontrado")
	if mission_manager == null:
		print("[GameManager] ERROR: MissionManager no encontrado")
	if ui_manager == null:
		print("[GameManager] ERROR: UIManager no encontrado")


## Pausa el juego
func pause_game() -> void:
	current_game_state = GameState.PAUSED
	get_tree().paused = true
	print("[GameManager] Juego pausado")


## Reanuda el juego
func resume_game() -> void:
	current_game_state = GameState.PLAYING
	get_tree().paused = false
	print("[GameManager] Juego reanudado")


## Obtiene el estado actual del juego
func get_game_state() -> GameState:
	return current_game_state


## Obtiene el tiempo de juego en minutos
func get_game_time() -> float:
	return game_time


## Establece la velocidad del tiempo
func set_time_scale(scale: float) -> void:
	time_scale = clamp(scale, 0.1, 10.0)


## Obtiene el gestor de economía
func get_economy_manager() -> EconomyManager:
	return economy_manager


## Obtiene el gestor de misiones
func get_mission_manager() -> MissionManager:
	return mission_manager


## Obtiene el gestor de UI
func get_ui_manager() -> UIManager:
	return ui_manager
