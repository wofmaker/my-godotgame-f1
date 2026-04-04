extends GutTest
## Player 이동+대시 단위 테스트.
## player.tscn을 instantiate해서 %BodyDraw @onready 참조를 보장한다.

var _player: CharacterBody2D

func before_each() -> void:
	_player = preload("res://scenes/player/player.tscn").instantiate()
	add_child(_player)

func after_each() -> void:
	_player.queue_free()


# --- 초기 상태 ---

func test_initial_velocity_is_zero() -> void:
	assert_eq(_player.velocity, Vector2.ZERO, "초기 velocity는 Vector2.ZERO")

func test_initial_not_dashing() -> void:
	assert_false(_player._is_dashing, "초기 대시 상태는 false")

func test_initial_not_invincible() -> void:
	assert_false(_player._is_invincible, "초기 무적 상태는 false")

func test_initial_dash_ready() -> void:
	assert_true(_player.is_dash_ready(), "초기에는 대시 준비 완료")

func test_last_direction_initial_value() -> void:
	assert_eq(_player._last_direction, Vector2.RIGHT, "초기 마지막 방향은 Vector2.RIGHT")


# --- export 기본값 ---

func test_default_speed_200() -> void:
	assert_eq(_player.speed, 200.0, "기본 이동 속도는 200.0")

func test_default_dash_speed_1500() -> void:
	assert_eq(_player.dash_speed, 1500.0, "기본 대시 속도는 1500.0")


# --- 대시 발동 (내부 상태 직접 설정) ---

func test_dash_sets_dashing_and_invincible() -> void:
	_player._is_dashing = true
	_player._is_invincible = true
	_player._dash_timer = _player.dash_duration
	_player._cooldown_timer = _player.dash_cooldown
	_player._invincible_timer = _player.invincible_duration
	_player.velocity = _player._last_direction * _player.dash_speed

	assert_true(_player._is_dashing, "대시 중 _is_dashing은 true")
	assert_true(_player._is_invincible, "대시 중 _is_invincible은 true")
	assert_eq(
		_player.velocity,
		Vector2.RIGHT * _player.dash_speed,
		"대시 velocity는 last_direction * dash_speed"
	)

func test_dash_sets_cooldown() -> void:
	_player._cooldown_timer = _player.dash_cooldown

	assert_gt(_player._cooldown_timer, 0.0, "대시 후 쿨다운 타이머가 양수")

func test_dash_not_ready_during_cooldown() -> void:
	_player._cooldown_timer = _player.dash_cooldown

	assert_false(_player.is_dash_ready(), "쿨다운 중에는 대시 불가")


# --- 타이머 로직 (_update_timers 직접 호출) ---

func test_dash_ends_after_duration() -> void:
	_player._is_dashing = true
	_player._dash_timer = _player.dash_duration

	# dash_duration보다 큰 delta를 넘겨서 타이머 만료
	_player._update_timers(_player.dash_duration + 0.01)

	assert_false(_player._is_dashing, "dash_duration 경과 후 _is_dashing은 false")
	assert_eq(_player._dash_timer, 0.0, "만료된 dash_timer는 0.0")

func test_invincible_ends_after_duration() -> void:
	_player._is_invincible = true
	_player._invincible_timer = _player.invincible_duration

	_player._update_timers(_player.invincible_duration + 0.01)

	assert_false(_player._is_invincible, "invincible_duration 경과 후 _is_invincible은 false")
	assert_eq(_player._invincible_timer, 0.0, "만료된 invincible_timer는 0.0")

func test_cooldown_decreases_over_time() -> void:
	_player._cooldown_timer = _player.dash_cooldown

	var delta: float = 0.5
	_player._update_timers(delta)

	assert_almost_eq(
		_player._cooldown_timer,
		_player.dash_cooldown - delta,
		0.001,
		"쿨다운 타이머는 delta만큼 감소"
	)


# --- is_invincible / is_dash_ready 공개 메서드 ---

func test_is_invincible_returns_state() -> void:
	_player._is_invincible = true
	assert_true(_player.is_invincible(), "is_invincible()은 _is_invincible 반환")

	_player._is_invincible = false
	assert_false(_player.is_invincible(), "is_invincible()은 _is_invincible 반환")

func test_is_dash_ready_false_while_dashing() -> void:
	_player._is_dashing = true
	_player._cooldown_timer = 0.0

	assert_false(_player.is_dash_ready(), "대시 중에는 is_dash_ready()가 false")
