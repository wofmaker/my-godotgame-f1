extends GutTest
## SaveManager 단위 테스트.

var _sm: Node
var _pd: Node

func before_each() -> void:
	_pd = preload("res://scripts/autoload/player_data.gd").new()
	_pd.name = "PlayerData"
	get_tree().root.add_child(_pd)
	_sm = preload("res://scripts/autoload/save_manager.gd").new()
	add_child(_sm)

func after_each() -> void:
	_sm.queue_free()
	_pd.queue_free()
	# 테스트 세이브 파일 정리
	if FileAccess.file_exists("user://save_data.json"):
		DirAccess.remove_absolute("user://save_data.json")

func test_save_creates_file() -> void:
	_pd.gold = 42
	var result = _sm.save_game()
	assert_true(result, "저장 성공")
	assert_true(FileAccess.file_exists("user://save_data.json"), "파일 존재")

func test_load_restores_saved_data() -> void:
	_pd.gold = 123
	_sm.save_game()
	_pd.gold = 0
	var result = _sm.load_game()
	assert_true(result, "로드 성공")
	assert_eq(_pd.gold, 123, "저장된 값 복원")

func test_load_nonexistent_returns_false() -> void:
	var result = _sm.load_game()
	assert_false(result, "파일 없으면 false")

func test_delete_save_removes_file() -> void:
	_sm.save_game()
	_sm.delete_save()
	assert_false(FileAccess.file_exists("user://save_data.json"), "파일 삭제됨")
