extends Area2D
class_name Hitbox

signal damage_recieved

@onready var entity := get_parent()
@export var BASE_HEALTH := 1
@export var BASE_SIZE: float = scale.x 
@export var SIZE_SCALE_FACTOR := 0.01 # factor relating size and health
@export var SIZE_TWEEN_RATE := 0.01 # REVISIT! linear rate might not be feasible for larger sizes

var health: int = BASE_HEALTH :
	set (value):
		update_size(health, value)
		health = value

var size_tween: Tween = null

func update_size(old_health: int, current_health: int):
	var target_scale := (SIZE_SCALE_FACTOR * (current_health - BASE_HEALTH) + BASE_SIZE) * Vector2.ONE
	if size_tween: size_tween.kill()
	size_tween = get_tree().create_tween()
	size_tween.tween_property(entity, "scale", target_scale, SIZE_TWEEN_RATE * abs(current_health - old_health))

func on_damage_recieved(val: int):
	health -= val
	damage_recieved.emit()
	
func _on_area_entered(area: Area2D) -> void:
	if entity is Player and area is Hitbox:
		var loser = self if (entity.scale.x <= area.entity.scale.x) else area
		health += loser.health
		loser.entity.on_absorbed()
