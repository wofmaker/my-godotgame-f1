extends GutTest
## PlayerData 단위 테스트.

var _pd: Node

func before_each() -> void:
	_pd = preload("res://scripts/autoload/player_data.gd").new()
	add_child(_pd)

func after_each() -> void:
	_pd.queue_free()

func test_initial_gold_is_zero() -> void:
	assert_eq(_pd.gold, 0)

func test_reset_run_data_clears_inventory() -> void:
	_pd.run_inventory.append("item_a")
	_pd.run_skills.append("skill_b")
	_pd.current_floor = 3
	_pd.current_level = 5
	_pd.reset_run_data()
	assert_eq(_pd.run_inventory.size(), 0, "인벤토리 초기화")
	assert_eq(_pd.run_skills.size(), 0, "스킬 초기화")
	assert_eq(_pd.current_floor, 0, "층 초기화")
	assert_eq(_pd.current_level, 1, "레벨 초기화")

func test_to_save_dict_contains_required_keys() -> void:
	_pd.gold = 100
	_pd.abyss_stone = 5
	var data: Dictionary = _pd.to_save_dict()
	assert_has(data, "gold")
	assert_has(data, "abyss_stone")
	assert_has(data, "unlocked_buildings")
	assert_has(data, "base_layout")
	assert_has(data, "version")
	assert_eq(data["gold"], 100)

func test_load_from_dict_restores_data() -> void:
	var data = {"gold": 200, "abyss_stone": 10, "unlocked_buildings": ["forge"], "base_layout": {}, "version": 1}
	_pd.load_from_dict(data)
	assert_eq(_pd.gold, 200)
	assert_eq(_pd.abyss_stone, 10)
	assert_eq(_pd.unlocked_buildings.size(), 1)

func test_load_from_dict_defaults_missing_keys() -> void:
	var data = {}
	_pd.load_from_dict(data)
	assert_eq(_pd.gold, 0, "누락 키는 기본값 0")

func test_reset_does_not_affect_persistent_data() -> void:
	_pd.gold = 500
	_pd.reset_run_data()
	assert_eq(_pd.gold, 500, "영속 데이터 보존")
