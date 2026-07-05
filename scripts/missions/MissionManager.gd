extends Node
## Gestor del sistema de misiones del juego.
## Controla misiones disponibles, activas y completadas.

class_name MissionManager

# Variables
var available_missions: Array = []
var current_mission: Dictionary = {}
var completed_missions: Array = []

func _ready() -> void:
	initialize_missions()


## Inicializa las misiones del juego
func initialize_missions() -> void:
	print("[MissionManager] Inicializando misiones...")
	
	# Misión 1: Ahorrar dinero
	available_missions.append({
		"id": 1,
		"title": "Ahorrador Principiante",
		"description": "Ahorra 500 monedas en tu cuenta bancaria",
		"objective": "save_money",
		"target_value": 500.0,
		"current_progress": 0.0,
		"reward": 100,
		"is_active": false,
		"is_completed": false
	})
	
	# Misión 2: Conseguir primer trabajo
	available_missions.append({
		"id": 2,
		"title": "Primer Empleo",
		"description": "Consigue un trabajo para ganar dinero",
		"objective": "get_job",
		"target_value": 1.0,
		"current_progress": 0.0,
		"reward": 50,
		"is_active": false,
		"is_completed": false
	})
	
	# Misión 3: Crear presupuesto
	available_missions.append({
		"id": 3,
		"title": "Presupuesto Personal",
		"description": "Crea tu primer presupuesto mensual",
		"objective": "create_budget",
		"target_value": 1.0,
		"current_progress": 0.0,
		"reward": 75,
		"is_active": false,
		"is_completed": false
	})
	
	# Misión 4: Abrir cuenta bancaria
	available_missions.append({
		"id": 4,
		"title": "Mi Primera Cuenta",
		"description": "Abre una cuenta bancaria en el banco",
		"objective": "open_bank_account",
		"target_value": 1.0,
		"current_progress": 0.0,
		"reward": 50,
		"is_active": false,
		"is_completed": false
	})
	
	# Misión 5: Compra responsable
	available_missions.append({
		"id": 5,
		"title": "Consumo Responsable",
		"description": "Compra solo productos necesarios en el supermercado",
		"objective": "responsible_purchase",
		"target_value": 5.0,
		"current_progress": 0.0,
		"reward": 100,
		"is_active": false,
		"is_completed": false
	})
	
	# Misión 6: Invertir dinero
	available_missions.append({
		"id": 6,
		"title": "Inversionista Novato",
		"description": "Realiza tu primera inversión",
		"objective": "invest",
		"target_value": 100.0,
		"current_progress": 0.0,
		"reward": 150,
		"is_active": false,
		"is_completed": false
	})
	
	print("[MissionManager] %d misiones cargadas" % available_missions.size())


## Activa una misión por ID
func activate_mission(mission_id: int) -> bool:
	for mission in available_missions:
		if mission["id"] == mission_id:
			if mission["is_completed"]:
				print("[MissionManager] Misión %d ya completada" % mission_id)
				return false
			
			current_mission = mission
			current_mission["is_active"] = true
			print("[MissionManager] Misión activada: %s" % mission["title"])
			return true
	
	print("[MissionManager] Misión %d no encontrada" % mission_id)
	return false


## Obtiene la misión actual
func get_current_mission() -> Dictionary:
	return current_mission


## Obtiene todas las misiones disponibles
func get_available_missions() -> Array:
	return available_missions


## Obtiene todas las misiones completadas
func get_completed_missions() -> Array:
	return completed_missions


## Actualiza el progreso de la misión actual
func update_mission_progress(value: float) -> void:
	if current_mission.is_empty() or not current_mission["is_active"]:
		return
	
	current_mission["current_progress"] = value
	var progress_percent: float = (current_mission["current_progress"] / current_mission["target_value"]) * 100.0
	print("[MissionManager] Progreso de '%s': %.1f%%" % [current_mission["title"], progress_percent])
	
	if current_mission["current_progress"] >= current_mission["target_value"]:
		complete_mission()


## Completa la misión actual
func complete_mission() -> void:
	if current_mission.is_empty():
		return
	
	current_mission["is_completed"] = true
	current_mission["is_active"] = false
	completed_missions.append(current_mission)
	
	print("[MissionManager] ¡Misión completada! '%s' +%d XP" % [current_mission["title"], current_mission["reward"]])
	
	# Dar recompensa al jugador
	if GameManager.instance:
		var player = GameManager.instance.player
		if player and player.has_method("add_experience"):
			player.add_experience(current_mission["reward"])
	
	current_mission = {}


## Cancela la misión actual
func cancel_mission() -> void:
	if current_mission.is_empty():
		return
	
	current_mission["is_active"] = false
	current_mission["current_progress"] = 0.0
	print("[MissionManager] Misión cancelada: %s" % current_mission["title"])
	current_mission = {}


## Obtiene la información de una misión por ID
func get_mission_by_id(mission_id: int) -> Dictionary:
	for mission in available_missions:
		if mission["id"] == mission_id:
			return mission
	return {}
