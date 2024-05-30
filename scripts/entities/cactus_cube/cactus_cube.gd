class_name CactusCube
extends Organism

@export var rage_persistence_timer: Timer
@export var shoot_cooldown_timer: Timer

@export var angry_face: Sprite2D
@export var neutral_face: Sprite2D
@export var spike_spawner: Node2D
@export var spikes: Node2D

var target: Player = null

func _ready() -> void:
	$Hitbox.health = initial_health
	spawn_spikes()

func on_absorbed() -> void:
	queue_free()

func _on_hitbox_damage_recieved(_value: int) -> void:
	if $Hitbox.health <= 0:
		on_absorbed()

func set_angry_face() -> void:
	angry_face.visible = true
	neutral_face.visible = false
	
func set_neutral_face() -> void:
	angry_face.visible = false
	neutral_face.visible = true

func launch_spikes() -> void:
	for spike in $Spikes.get_children():
		spike.launch()
		
func spawn_spikes() -> void:
	for spawner in spike_spawner.get_children():
		spike_spawner.spawn(spawner.global_position, spawner.direction.angle(), spawner.scale, spikes)