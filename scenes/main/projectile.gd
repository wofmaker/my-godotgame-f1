extends Area2D
## 투사체. 활/지팡이 공격에 사용. 오브젝트 풀로 관리된다.

var speed: float = 300.0
var damage: int = 10
var max_pierce: int = 1

var _direction: Vector2 = Vector2.ZERO
var _max_range: float = 300.0
var travelled: float = 0.0
var _pierce_remaining: int = 1
var _hit_bodies: Array[Node] = []


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	var step: float = speed * delta
	position += _direction * step
	travelled += step

	if travelled >= _max_range:
		deactivate()


func launch(direction: Vector2, max_range: float) -> void:
	_direction = direction.normalized()
	_max_range = max_range
	travelled = 0.0
	_pierce_remaining = max_pierce
	_hit_bodies.clear()
	rotation = _direction.angle()


func activate() -> void:
	visible = true
	set_physics_process(true)
	monitoring = true
	monitorable = true


func deactivate() -> void:
	visible = false
	set_physics_process(false)
	monitoring = false
	monitorable = false
	_direction = Vector2.ZERO
	travelled = 0.0
	_hit_bodies.clear()


func _on_body_entered(body: Node2D) -> void:
	if body in _hit_bodies:
		return
	if not body.is_in_group("damageable"):
		return
	if not body.has_method("take_damage"):
		return

	_hit_bodies.append(body)
	body.take_damage(damage)

	_pierce_remaining -= 1
	if _pierce_remaining <= 0:
		deactivate()
