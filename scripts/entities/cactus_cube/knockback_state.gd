extends State

@export var entity: Organism
@export var STUN_DURATION := 1.0

func enter() -> void:
	entity.velocity = entity.knockback
	var tree = get_tree()
	if tree: tree.create_timer(STUN_DURATION).timeout.connect(_on_stun_timeout)

func process(delta: float) -> void:
	entity.move_and_slide()
	entity.knockback = lerp(entity.knockback, Vector2.ZERO, 0.9)
	
func _on_stun_timeout() -> void:
	entity.knockback = Vector2.ZERO
	entity.velocity = Vector2.ZERO
	# last minute hack :(
	entity.target = get_tree().get_nodes_in_group("Player")[0]
	transitioned.emit("Chase")
