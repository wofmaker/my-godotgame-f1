extends GutTest
## Projectile 단위 테스트.
## projectile.tscn을 인스턴스화하여 activate/deactivate 및 이동 로직을 검증한다.

var _proj: Area2D

func before_each() -> void:
	_proj = preload("res://scenes/main/projectile.tscn").instantiate()
	add_child(_proj)
	# 초기 상태는 deactivate (풀 패턴 기준)
	_proj.deactivate()

func after_each() -> void:
	_proj.queue_free()


# --- 씬 인스턴스화 검증 ---

func test_projectile_scene_instantiates() -> void:
	assert_not_null(_proj, "projectile.tscn 인스턴스화 성공")

func test_projectile_has_default_speed() -> void:
	assert_eq(_proj.speed, 300.0, "기본 speed는 300.0")

func test_projectile_has_default_damage() -> void:
	assert_eq(_proj.damage, 10, "기본 damage는 10")

func test_projectile_has_default_max_pierce() -> void:
	assert_eq(_proj.max_pierce, 1, "기본 max_pierce는 1")


# --- activate / deactivate 상태 전환 ---

func test_deactivate_sets_invisible() -> void:
	_proj.deactivate()
	assert_false(_proj.visible, "deactivate 후 visible은 false")

func test_activate_sets_visible() -> void:
	_proj.activate()
	assert_true(_proj.visible, "activate 후 visible은 true")

func test_deactivate_disables_physics_process() -> void:
	_proj.activate()
	_proj.deactivate()
	assert_false(_proj.is_physics_processing(), "deactivate 후 physics process 비활성화")

func test_activate_enables_physics_process() -> void:
	_proj.activate()
	assert_true(_proj.is_physics_processing(), "activate 후 physics process 활성화")

func test_deactivate_resets_travelled() -> void:
	_proj.travelled = 100.0
	_proj.deactivate()
	assert_eq(_proj.travelled, 0.0, "deactivate 후 _travelled 초기화")


# --- launch() 설정 검증 ---

func test_launch_sets_direction() -> void:
	_proj.launch(Vector2.RIGHT, 300.0)
	assert_eq(_proj._direction, Vector2.RIGHT, "launch 후 _direction 설정됨")

func test_launch_normalizes_direction() -> void:
	_proj.launch(Vector2(3.0, 4.0), 300.0)
	assert_almost_eq(_proj._direction.length(), 1.0, 0.001, "launch 후 방향 벡터 정규화됨")

func test_launch_resets_travelled() -> void:
	_proj.travelled = 50.0
	_proj.launch(Vector2.RIGHT, 300.0)
	assert_eq(_proj.travelled, 0.0, "launch 후 _travelled 초기화")

func test_launch_sets_max_range() -> void:
	_proj.launch(Vector2.RIGHT, 250.0)
	assert_eq(_proj._max_range, 250.0, "launch 후 _max_range 설정됨")


# --- _physics_process 후 position 변경 ---

func test_physics_process_moves_projectile() -> void:
	_proj.launch(Vector2.RIGHT, 300.0)
	_proj.activate()
	var initial_pos: Vector2 = _proj.position

	_proj._physics_process(0.1)

	assert_ne(_proj.position, initial_pos, "physics_process 후 position이 변경됨")

func test_physics_process_moves_in_correct_direction() -> void:
	_proj.launch(Vector2.RIGHT, 300.0)
	_proj.activate()
	_proj.position = Vector2.ZERO

	_proj._physics_process(0.1)

	assert_gt(_proj.position.x, 0.0, "오른쪽 방향으로 이동")
	assert_almost_eq(_proj.position.y, 0.0, 0.001, "y 위치는 변화 없음")

func test_physics_process_increases_travelled() -> void:
	_proj.launch(Vector2.RIGHT, 300.0)
	_proj.activate()

	_proj._physics_process(0.1)

	assert_gt(_proj.travelled, 0.0, "_travelled 증가")


# --- max_range 도달 시 deactivate ---

func test_deactivate_when_max_range_reached() -> void:
	_proj.launch(Vector2.RIGHT, 10.0)
	_proj.activate()

	# 충분히 큰 delta로 max_range 초과
	_proj._physics_process(1.0)

	assert_false(_proj.visible, "max_range 도달 후 visible==false (deactivate)")

func test_deactivate_stops_physics_process_at_max_range() -> void:
	_proj.launch(Vector2.RIGHT, 10.0)
	_proj.activate()

	_proj._physics_process(1.0)

	assert_false(_proj.is_physics_processing(), "max_range 도달 후 physics process 비활성화")
