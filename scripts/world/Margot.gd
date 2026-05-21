extends CharacterBody2D
## Personnage joueur. Déplacement linéaire vers une position cible.
## Pas de pathfinding : les scènes point-and-click sont des pièces
## ou couloirs ouverts.

signal arrived(target: Vector2)
signal movement_started(target: Vector2)

@export var speed: float = 220.0
@export var arrive_distance: float = 4.0

var _target: Vector2 = Vector2.ZERO
var _moving: bool = false

@onready var _sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null
@onready var _anim: AnimationPlayer = $AnimationPlayer if has_node("AnimationPlayer") else null


func _ready() -> void:
	add_to_group("player")
	_play("idle")


# --- API publique ---------------------------------------------------------

func move_to(point: Vector2) -> void:
	_target = point
	_moving = true
	movement_started.emit(point)
	_play("walk")


func stop() -> void:
	_moving = false
	velocity = Vector2.ZERO
	_play("idle")


func is_moving() -> bool:
	return _moving


# --- Physique -------------------------------------------------------------

func _physics_process(_delta: float) -> void:
	if not _moving:
		return
	var to_target := _target - global_position
	var dist := to_target.length()
	if dist <= arrive_distance:
		_moving = false
		velocity = Vector2.ZERO
		_play("idle")
		arrived.emit(_target)
		return
	var dir := to_target.normalized()
	velocity = dir * speed
	move_and_slide()
	if _sprite and absf(dir.x) > 0.1:
		_sprite.flip_h = dir.x < 0


# --- Anim helper ----------------------------------------------------------

func _play(anim_name: String) -> void:
	if _anim == null:
		return
	if not _anim.has_animation(anim_name):
		return
	if _anim.current_animation == anim_name:
		return
	_anim.play(anim_name)
