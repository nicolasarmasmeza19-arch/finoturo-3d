extends CharacterBody3D
## Controlador del jugador. Gestiona movimiento, entrada y estado del personaje.

class_name PlayerController

# Velocidades
@export var walk_speed: float = 5.0
@export var run_speed: float = 8.0
@export var jump_force: float = 5.0
@export var gravity: float = -9.8

# Energía
@export var max_energy: float = 100.0
var current_energy: float = 100.0
@export var energy_regen_rate: float = 2.0
@export var energy_drain_rate: float = 5.0

# Estadísticas del jugador
var player_level: int = 1
var player_experience: int = 0

# Variables internas
var is_running: bool = false
var move_direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	print("[PlayerController] Jugador inicializado")
	if GameManager.instance:
		GameManager.instance.player = self

func _physics_process(delta: float) -> void:
	handle_input()
	update_energy(delta)
	apply_movement(delta)

move_and_slide()


## Maneja la entrada del jugador
func handle_input() -> void:
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	move_direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	is_running = Input.is_action_pressed("run") and current_energy > 0
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()


## Aplica el movimiento
func apply_movement(delta: float) -> void:
	var speed: float = run_speed if is_running else walk_speed
	velocity.x = move_direction.x * speed
	velocity.z = move_direction.z * speed
	
	# Aplicar gravedad
	velocity.y += gravity * delta


## Implementa el salto
func jump() -> void:
	if not is_on_floor():
		return
	
	velocity.y = jump_force
	print("[PlayerController] ¡Salto!")


## Actualiza la energía del jugador
func update_energy(delta: float) -> void:
	if is_running and move_direction.length() > 0:
		current_energy -= energy_drain_rate * delta
	else:
		current_energy += energy_regen_rate * delta
	
	current_energy = clamp(current_energy, 0, max_energy)


## Obtiene la energía actual
func get_current_energy() -> float:
	return current_energy


## Obtiene la energía máxima
func get_max_energy() -> float:
	return max_energy


## Obtiene el nivel del jugador
func get_player_level() -> int:
	return player_level


## Obtiene la experiencia del jugador
func get_player_experience() -> int:
	return player_experience


## Añade experiencia al jugador
func add_experience(amount: int) -> void:
	player_experience += amount
	print("[PlayerController] +%d XP. Total: %d" % [amount, player_experience])


## Sube de nivel
func level_up() -> void:
	player_level += 1
	player_experience = 0
	print("[PlayerController] ¡Nivel %d!" % player_level)
