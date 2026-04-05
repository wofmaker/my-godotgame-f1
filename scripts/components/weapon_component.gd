class_name WeaponComponent
extends Node2D
## 자동 전투 무기 컴포넌트. 범위 내 적을 감지하고 무기 패턴에 따라 공격한다.

const POOL_SIZE: int = 20

@export var weapon: WeaponResource

@onready var _detection_area: Area2D = %DetectionArea
@onready var _attack_timer: Timer = %AttackTimer

var _enemies_in_range: Array[Node2D] = []
var _current_target: Node2D = null
var _projectile_pool: Array[Node] = []
var _projectile_scene: PackedScene = preload("res://scenes/main/projectile.tscn")


func _ready() -> void:
	if weapon == null:
		return
	_setup_detection()
	_setup_timer()
	_setup_projectile_pool()


func _setup_detection() -> void:
	var shape: CircleShape2D = CircleShape2D.new()
	shape.radius = weapon.attack_range

	# DetectionArea 하위에 이미 CollisionShape2D가 있으면 재사용, 없으면 생성
	var col_shape: CollisionShape2D = null
	for child in _detection_area.get_children():
		if child is CollisionShape2D:
			col_shape = child
			break
	if col_shape == null:
		col_shape = CollisionShape2D.new()
		_detection_area.add_child(col_shape)
	col_shape.shape = shape

	_detection_area.body_entered.connect(_on_detection_body_entered)
	_detection_area.body_exited.connect(_on_detection_body_exited)


func _setup_timer() -> void:
	_attack_timer.wait_time = 1.0 / maxf(weapon.attack_speed, 0.01)
	_attack_timer.autostart = false
	_attack_timer.one_shot = false
	_attack_timer.timeout.connect(_on_attack_timer_timeout)
	_attack_timer.start()


func _setup_projectile_pool() -> void:
	if weapon.attack_pattern == WeaponResource.AttackPattern.SWORD:
		return
	for i in range(POOL_SIZE):
		var proj: Node = _projectile_scene.instantiate()
		add_child(proj)
		proj.deactivate()
		_projectile_pool.append(proj)


# --- 적 감지 ---

func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("damageable"):
		_enemies_in_range.append(body)


func _on_detection_body_exited(body: Node2D) -> void:
	_enemies_in_range.erase(body)


func _get_nearest_enemy() -> Node2D:
	# 유효하지 않은 적 정리
	_enemies_in_range = _enemies_in_range.filter(func(e: Node2D) -> bool: return is_instance_valid(e))

	var nearest: Node2D = null
	var nearest_dist: float = INF
	for enemy in _enemies_in_range:
		var dist: float = global_position.distance_squared_to(enemy.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = enemy
	return nearest


# --- 공격 ---

func _on_attack_timer_timeout() -> void:
	_perform_attack()


func _perform_attack() -> void:
	_current_target = _get_nearest_enemy()
	if _current_target == null:
		return
	if not is_instance_valid(_current_target):
		_current_target = null
		return

	match weapon.attack_pattern:
		WeaponResource.AttackPattern.SWORD:
			_attack_sword()
		WeaponResource.AttackPattern.BOW:
			_attack_bow()
		WeaponResource.AttackPattern.STAFF:
			_attack_staff()

	EventBus.weapon_attack_performed.emit(weapon.attack_pattern, global_position)


func _attack_sword() -> void:
	var attack_dir: Vector2 = (_current_target.global_position - global_position).normalized()
	var cos_threshold: float = cos(deg_to_rad(weapon.sword_angle_deg))

	for enemy in _enemies_in_range:
		if not is_instance_valid(enemy):
			continue
		if not enemy.is_in_group("damageable"):
			continue
		if not enemy.has_method("take_damage"):
			continue

		var to_enemy: Vector2 = (enemy.global_position - global_position).normalized()
		var dist: float = global_position.distance_to(enemy.global_position)

		if to_enemy.dot(attack_dir) >= cos_threshold and dist <= weapon.attack_range:
			enemy.take_damage(weapon.damage)


func _attack_bow() -> void:
	_fire_projectile()


func _attack_staff() -> void:
	_fire_projectile()


func _fire_projectile() -> void:
	var proj: Node = _get_pooled_projectile()
	if proj == null:
		return

	var direction: Vector2 = (_current_target.global_position - global_position).normalized()
	proj.speed = weapon.projectile_speed
	proj.damage = weapon.damage
	proj.max_pierce = weapon.pierce_count
	proj.global_position = global_position
	proj.launch(direction, weapon.attack_range)
	proj.activate()


func _get_pooled_projectile() -> Node:
	# 비활성 투사체 우선
	for proj in _projectile_pool:
		if not proj.visible:
			return proj

	# 풀 고갈: 가장 먼 거리 이동한 활성 투사체 강제 회수
	var farthest: Node = null
	var farthest_travelled: float = -1.0
	for proj in _projectile_pool:
		if proj.travelled > farthest_travelled:
			farthest_travelled = proj._travelled
			farthest = proj

	if farthest != null:
		farthest.deactivate()
	return farthest


# --- 무기 교체 ---

func set_weapon(new_weapon: WeaponResource) -> void:
	if GameManager.current_state != GameManager.State.BASE:
		push_warning("WeaponComponent: 무기 교체는 BASE 상태에서만 가능합니다.")
		return

	weapon = new_weapon

	if weapon == null:
		_attack_timer.stop()
		return

	# 타이머 갱신
	_attack_timer.wait_time = 1.0 / maxf(weapon.attack_speed, 0.01)
	_attack_timer.start()

	# 감지 반경 갱신
	for child in _detection_area.get_children():
		if child is CollisionShape2D and child.shape is CircleShape2D:
			child.shape.radius = weapon.attack_range
			break

	# 기존 투사체 풀 정리 후 재생성 (활성 투사체 먼저 비활성화)
	for proj in _projectile_pool:
		proj.deactivate()
		proj.queue_free()
	_projectile_pool.clear()
	_setup_projectile_pool()
