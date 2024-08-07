extends Node

signal spawn_root_attached

const SPAWN_DISTANCE = 750.0
const SPAWN_VARIATION = 900.0
const SHIFT_DISTANCE = 150.0
const RESPAWN_DISTANCE = 2000.0

@export var _enemy_data :Array[EnemyData] = []

var _enemies :Dictionary = {} 

var SpawnRoot :Node2D :
	set(value): 
		SpawnRoot = value
		spawn_root_attached.emit()

var player = null

func _ready () -> void:
	randomize()
	await spawn_root_attached
	_initialize_enemies()
	var i = 0
	for data in _enemy_data:
		_enemies[i] = {
			instances = []
		}
		for n in range(data.max_count):
			_spawn_enemy(data, i)
		i += 1
	
	var tween = get_tree().create_tween().set_loops()
	tween.tween_callback(_respawn_far_enemies).set_delay(2.0)
	
# Re-initialize the enemies to be used.
func _initialize_enemies() -> void:
	_enemies.clear()
	var i = 0
	for data in _enemy_data:
		_enemies[i] = {
			instances = []
		}
		for n in range(data.max_count):
			_spawn_enemy(data, i)
		i += 1

func _find_enemy_spawn_location () -> Vector2:
	if not player: return Vector2.ZERO

	var new_position := Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() 
	new_position *= SPAWN_DISTANCE + randf_range(SHIFT_DISTANCE, SPAWN_VARIATION)
	new_position = player.global_position + new_position
	for enemy_type in _enemies.values(): for enemy in enemy_type.instances:
		var direction = enemy.global_position - new_position
		if direction.length() > SHIFT_DISTANCE: continue
		new_position = new_position + Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * SHIFT_DISTANCE
	return new_position

func _spawn_enemy (enemy_data :EnemyData, index :int) -> void:
	var enemy = enemy_data.scene.instantiate()
	enemy.global_position = _find_enemy_spawn_location()
	enemy.initial_health = randi_range(8, 12) / GameHandler.global_scale_factor
	enemy.died.connect(_on_enemy_died.bind(index))
	_enemies[index].instances.append(enemy)
	SpawnRoot.add_child.call_deferred(enemy)

func _respawn_far_enemies () -> void:
	if not player: return

	for index in _enemies: 
		var respawn :Array = []
		for enemy in _enemies[index].instances:
			if enemy == null or not enemy.is_inside_tree():
				continue
				
			var direction = Vector2.ZERO
			if player and player.is_inside_tree():
				direction = enemy.global_position - player.global_position
			else:
				print("Player node is not valid or not in the tree.")
				continue
			if direction.length() < RESPAWN_DISTANCE: continue
			respawn.append(enemy)
		for enemy in respawn:
			_enemies[index].instances.erase(enemy)
			enemy.queue_free()
			_spawn_enemy(_enemy_data[index], index)

func _on_enemy_died (enemy, index :int) -> void:
	_enemies[index].instances.erase(enemy)
	_spawn_enemy(_enemy_data[index], index)

func scale_enemies(scale_factor: float, duration: float, pos: Vector2) -> void:
	for enemy_type in _enemies.values(): 
		for enemy in enemy_type.instances:
			enemy.global_scale_factor = GameHandler.global_scale_factor
			enemy.zoom(scale_factor, duration, pos)

func destroy() -> void:
	for enemy_type in _enemies.values(): 
		for enemy in enemy_type.instances:
			enemy.queue_free()
		
	queue_free()
