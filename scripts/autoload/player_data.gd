extends Node
## 플레이어 데이터. 런 데이터(휘발)와 영속 데이터를 분리한다.

# --- 런 데이터 (사망 시 소멸) ---
var run_inventory: Array = []
var run_skills: Array = []
var current_floor: int = 0
var current_level: int = 1
var current_health: int = 100
var max_health: int = 100

# --- 영속 데이터 (기지/해금/화폐) ---
var gold: int = 0
var abyss_stone: int = 0
var unlocked_buildings: Array[String] = []
var base_layout: Dictionary = {}

func reset_run_data() -> void:
	run_inventory.clear()
	run_skills.clear()
	current_floor = 0
	current_level = 1
	current_health = max_health

func to_save_dict() -> Dictionary:
	return {
		"gold": gold,
		"abyss_stone": abyss_stone,
		"unlocked_buildings": unlocked_buildings,
		"base_layout": base_layout,
		"version": 1,
	}

func load_from_dict(data: Dictionary) -> void:
	gold = data.get("gold", 0)
	abyss_stone = data.get("abyss_stone", 0)
	unlocked_buildings.assign(data.get("unlocked_buildings", []))
	base_layout = data.get("base_layout", {})
