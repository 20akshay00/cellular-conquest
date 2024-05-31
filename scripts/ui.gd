extends CanvasLayer


@onready var size_value: Label = %SizeValue
@onready var player: Player = $"../Player"

@onready var dash_cooldown_timer: Timer = player.dash_timer
@onready var dash_ability_cooldown: TextureRect = $Control/MarginContainer/HBoxContainer/DashAbility

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	size_value.text = str(player.health)
	if dash_cooldown_timer.time_left != 0:
		dash_ability_cooldown.set_progress( (1 - (dash_cooldown_timer.time_left / dash_cooldown_timer.wait_time)) * 100)
	else:
		dash_ability_cooldown.set_progress(100.0)