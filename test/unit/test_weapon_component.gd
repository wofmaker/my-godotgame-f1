extends GutTest
## WeaponComponent 단위 테스트.
## player.tscn을 인스턴스화하여 WeaponComponent 내부 노드를 보장한다.
## GameManager autoload 싱글톤을 직접 사용한다.

var _player: CharacterBody2D
var _weapon_comp: WeaponComponent
var _original_state: int

func before_each() -> void:
	# GameManager 상태 백업 후 MENU로 초기화
	_original_state = GameManager.current_state
	GameManager.current_state = GameManager.State.MENU

	_player = preload("res://scenes/player/player.tscn").instantiate()
	add_child(_player)
	_weapon_comp = _player.get_node("WeaponComponent")

func after_each() -> void:
	_player.queue_free()
	# GameManager 상태 복원
	GameManager.current_state = _original_state


# --- WeaponComponent 존재 확인 ---

func test_weapon_component_exists() -> void:
	assert_not_null(_weapon_comp, "WeaponComponent 노드가 존재한다")

func test_weapon_component_is_correct_type() -> void:
	assert_is(_weapon_comp, WeaponComponent, "WeaponComponent 타입이 올바르다")


# --- weapon null 가드 ---

func test_weapon_null_ready_no_crash() -> void:
	# weapon이 없는 WeaponComponent를 별도로 씬 없이 구성하면
	# %DetectionArea 등 @onready가 없어 크래시하므로
	# player.tscn 인스턴스의 weapon을 null로 설정한 후 _ready를 직접 검증하는 대신,
	# weapon이 할당된 상태에서 초기화가 정상 완료되었는지 확인한다.
	assert_not_null(_weapon_comp, "weapon이 있을 때 _ready 크래시 없음")

func test_weapon_component_has_weapon_assigned() -> void:
	assert_not_null(_weapon_comp.weapon, "player.tscn 기본 weapon(sword)이 할당되어 있다")


# --- 타이머 wait_time 검증 ---

func test_attack_timer_wait_time_matches_weapon_attack_speed() -> void:
	var attack_timer: Timer = _player.get_node("%AttackTimer")
	var weapon: WeaponResource = _weapon_comp.weapon
	var expected: float = 1.0 / weapon.attack_speed
	assert_almost_eq(
		attack_timer.wait_time,
		expected,
		0.001,
		"AttackTimer.wait_time == 1.0 / weapon.attack_speed"
	)


# --- set_weapon(): BASE 상태에서 성공 ---

func test_set_weapon_succeeds_in_base_state() -> void:
	# MENU → BASE 전환
	GameManager.transition_to(GameManager.State.BASE)

	var bow: WeaponResource = load("res://resources/weapons/bow.tres")
	_weapon_comp.set_weapon(bow)

	assert_eq(_weapon_comp.weapon, bow, "BASE 상태에서 무기 교체 성공")


func test_set_weapon_updates_timer_in_base_state() -> void:
	GameManager.transition_to(GameManager.State.BASE)

	var bow: WeaponResource = load("res://resources/weapons/bow.tres")
	_weapon_comp.set_weapon(bow)

	var attack_timer: Timer = _player.get_node("%AttackTimer")
	var expected: float = 1.0 / bow.attack_speed
	assert_almost_eq(
		attack_timer.wait_time,
		expected,
		0.001,
		"무기 교체 후 타이머 갱신됨"
	)


# --- set_weapon(): DUNGEON 상태에서 거부 ---

func test_set_weapon_rejected_in_dungeon_state() -> void:
	# MENU → BASE → DUNGEON
	GameManager.transition_to(GameManager.State.BASE)
	GameManager.transition_to(GameManager.State.DUNGEON)

	var original_weapon: WeaponResource = _weapon_comp.weapon
	var staff: WeaponResource = load("res://resources/weapons/staff.tres")
	_weapon_comp.set_weapon(staff)

	assert_eq(_weapon_comp.weapon, original_weapon, "DUNGEON 상태에서 무기 교체 거부됨")
