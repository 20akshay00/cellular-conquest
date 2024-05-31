
class_name ToothDasher
extends Organism

signal died(enemy)


@export var dash_cooldown_timer :Timer
@export var dash_wait_timer :Timer

@export var angry_face :Sprite2D
@export var neutral_face :Sprite2D

@export var CHASE_SPEED :float = 150.0
@export var DASH_SPEED :float = 1000.0
@export var DASH_DURATION :float = 0.3


var target :Player = null


func _ready () -> void:
    $Hitbox.health = initial_health


func on_absorbed () -> void:
    died.emit(self)
    queue_free() # should call Organism.on_absorbed version


func _on_hitbox_damage_received (_value :int) -> void:
    if $Hitbox.health <= 0:
        on_absorbed()


func set_angry_face() -> void:
    angry_face.visible = true
    neutral_face.visible = false


func set_neutral_face() -> void:
    angry_face.visible = false
    neutral_face.visible = true