class_name KnockbackGuy
extends Organism

@export var knockback_cooldown_timer :Timer
@export var detection_area :Area2D
@export var knockback_effect :GPUParticles2D

@export var angry_face :Sprite2D
@export var neutral_face :Sprite2D

@export var CHASE_SPEED :float = 150.0
@export var DASH_SPEED :float = 1000.0
@export var DASH_DURATION :float = 0.3

var target: Player = null

func _ready() -> void:
	Wwise.register_game_obj(self, self.name)
	$Hitbox.health = initial_health
	EventManager.game_over.connect(_on_game_over)

func on_absorbed() -> void:
	$Hitbox.queue_free()
	EventManager.enemy_died.emit(self)
	died.emit(self)

	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(0, 0), 0.5)
	tween.tween_callback(queue_free)
	
func _on_hitbox_damage_received (_value :int) -> void:
	Wwise.post_event_id(AK.EVENTS.PLAY_KNOCKBACKGUY_DAMAGE, self)
	if $Hitbox.health <= 0:
		on_absorbed()

func set_angry_face() -> void:
	angry_face.visible = true
	neutral_face.visible = false

func set_neutral_face() -> void:
	angry_face.visible = false
	neutral_face.visible = true

func _on_game_over():
	process_mode = Node.PROCESS_MODE_DISABLED
