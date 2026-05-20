extends Area2D
## Cône de surveillance dans une NavigableRoom. Quand le joueur
## (groupe "player") entre, prévient SurveillanceManager. Le temps
## d'exposition cumulé déclenche les incidents (PD +1, tick
## equipe_nettoyage).

@export_range(1, 4) var surveillance_level: int = 1
@export var is_active: bool = true


func _ready() -> void:
	add_to_group("camera_zone")
	monitoring = true
	monitorable = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node) -> void:
	if not is_active:
		return
	if body.is_in_group("player"):
		SurveillanceManager.register_zone_entered(get_instance_id(), surveillance_level)


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		SurveillanceManager.register_zone_exited(get_instance_id())


func set_active(v: bool) -> void:
	is_active = v
	if not v:
		SurveillanceManager.register_zone_exited(get_instance_id())
