extends GutTest
## GameManager 상태 전환 단위 테스트.

var _gm: Node

func before_each() -> void:
	_gm = preload("res://scripts/autoload/game_manager.gd").new()
	add_child(_gm)

func after_each() -> void:
	_gm.queue_free()

func test_initial_state_is_menu() -> void:
	assert_eq(_gm.current_state, _gm.State.MENU, "초기 상태는 MENU")

func test_valid_transition_menu_to_base() -> void:
	var result = _gm.transition_to(_gm.State.BASE)
	assert_true(result, "MENU → BASE 전환 성공")
	assert_eq(_gm.current_state, _gm.State.BASE)

func test_valid_transition_base_to_dungeon() -> void:
	_gm.transition_to(_gm.State.BASE)
	var result = _gm.transition_to(_gm.State.DUNGEON)
	assert_true(result, "BASE → DUNGEON 전환 성공")
	assert_eq(_gm.current_state, _gm.State.DUNGEON)

func test_invalid_transition_menu_to_dungeon() -> void:
	var result = _gm.transition_to(_gm.State.DUNGEON)
	assert_false(result, "MENU → DUNGEON 전환 차단")
	assert_eq(_gm.current_state, _gm.State.MENU)

func test_same_state_transition_returns_false() -> void:
	var result = _gm.transition_to(_gm.State.MENU)
	assert_false(result, "동일 상태 전환 거부")

func test_pause_and_resume() -> void:
	_gm.transition_to(_gm.State.BASE)
	_gm.transition_to(_gm.State.DUNGEON)
	_gm.pause()
	assert_eq(_gm.current_state, _gm.State.PAUSED)
	_gm.resume()
	assert_eq(_gm.current_state, _gm.State.DUNGEON, "resume() 후 이전 상태 복구")
