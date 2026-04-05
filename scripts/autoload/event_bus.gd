extends Node
## 전역 시그널 버스. 노드 간 직접 의존을 제거한다.

# 게임 상태
signal game_state_changed(old_state: int, new_state: int)

# 플레이어
signal player_died
signal player_health_changed(current: int, max_val: int)
signal player_level_changed(level: int)

# 던전
signal dungeon_floor_changed(floor_num: int)
signal room_cleared(room_id: int)
signal alarm_gauge_changed(value: float)

# 기지
signal base_building_placed(building_type: String, position: Vector2i)
signal currency_changed(gold: int, abyss_stone: int)

# 세이브
signal save_completed
signal load_completed

# 전투
signal weapon_attack_performed(attack_pattern: int, position: Vector2)
signal enemy_damaged(enemy: Node, damage: int, position: Vector2)
signal weapon_changed(weapon: Resource)
