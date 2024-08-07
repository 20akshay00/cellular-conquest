extends State

@export var entity: CactusCube
var enraged: bool = false

func enter() -> void:
	entity.set_angry_face()
	_on_shoot_cooldown_timer_timeout()
	entity.shoot_cooldown_timer.start()

func process(_delta: float) -> void:
	var angle_to_target = (entity.target.global_position - entity.global_position).angle()
	entity.rotation = lerp_angle(entity.rotation, angle_to_target + PI/2, 0.1)

func on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		if entity.rage_persistence_timer.time_left > 0:
			entity.rage_persistence_timer.stop()

func on_detection_area_body_exited(body: Node2D) -> void:
	if body is Player:
		entity.rage_persistence_timer.start()

func _on_rage_timer_timeout() -> void:
	entity.target = null
	entity.shoot_cooldown_timer.stop()
	transitioned.emit("Idle")

func _on_shoot_cooldown_timer_timeout() -> void:
	entity.launch_spikes()
	entity.call_deferred("spawn_spikes")
	
func on_damage_recieved(_damage: int) -> void:
	if (entity.scale.x < entity.target.scale.x) and not enraged:
		enraged = true
		entity.shoot_cooldown_timer.wait_time = 0.5 * entity.shoot_cooldown_timer.wait_time

