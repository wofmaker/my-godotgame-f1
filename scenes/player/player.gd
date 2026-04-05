extends CharacterBody2D
## 플레이어 이동 + 대시 로직

# --- 이동 ---
@export var speed: float = 200.0

# --- 대시 ---
@export var dash_speed: float = 1500.0
@export var dash_duration: float = 0.1
@export var dash_cooldown: float = 2.0
@export var invincible_duration: float = 0.3

# --- 내부 상태 ---
var _last_direction: Vector2 = Vector2.RIGHT
var _is_dashing: bool = false
var _is_invincible: bool = false
var _dash_timer: float = 0.0
var _cooldown_timer: float = 0.0
var _invincible_timer: float = 0.0

@onready var _body_draw: Node2D = %BodyDraw
@onready var _weapon_component: WeaponComponent = %WeaponComponent


func _physics_process(delta: float) -> void:
	_update_timers(delta)

	var input_direction: Vector2 = _get_input_direction()

	if input_direction != Vector2.ZERO:
		_last_direction = input_direction

	if _is_dashing:
		# 대시 중에는 입력 무시, 기존 velocity 유지
		pass
	else:
		velocity = input_direction * speed
		_try_dash()

	move_and_slide()
	_update_body_draw_rotation()


func _get_input_direction() -> Vector2:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction.length() > 1.0:
		direction = direction.normalized()
	return direction


func _try_dash() -> void:
	if Input.is_action_just_pressed("dash") and is_dash_ready():
		_is_dashing = true
		_is_invincible = true
		_dash_timer = dash_duration
		_cooldown_timer = dash_cooldown
		_invincible_timer = invincible_duration
		velocity = _last_direction * dash_speed


func _update_timers(delta: float) -> void:
	if _dash_timer > 0.0:
		_dash_timer -= delta
		if _dash_timer <= 0.0:
			_dash_timer = 0.0
			_is_dashing = false

	if _invincible_timer > 0.0:
		_invincible_timer -= delta
		if _invincible_timer <= 0.0:
			_invincible_timer = 0.0
			_is_invincible = false

	if _cooldown_timer > 0.0:
		_cooldown_timer -= delta
		if _cooldown_timer <= 0.0:
			_cooldown_timer = 0.0


func _update_body_draw_rotation() -> void:
	_body_draw.rotation = _last_direction.angle()


func is_invincible() -> bool:
	return _is_invincible


func is_dash_ready() -> bool:
	return _cooldown_timer <= 0.0 and not _is_dashing


func equip_weapon(weapon: WeaponResource) -> void:
	if _weapon_component != null:
		_weapon_component.set_weapon(weapon)
		EventBus.weapon_changed.emit(weapon)


func get_weapon_component() -> WeaponComponent:
	return _weapon_component
