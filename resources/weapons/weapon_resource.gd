class_name WeaponResource
extends Resource
## 무기 데이터 리소스. 공격 패턴, 데미지, 사거리 등을 정의한다.

enum AttackPattern { SWORD, BOW, STAFF }

@export var weapon_name: String = ""
@export var damage: int = 10
@export var attack_speed: float = 1.0   # 초당 공격 횟수
@export var attack_range: float = 64.0  # 감지/공격 사거리
@export var attack_pattern: AttackPattern = AttackPattern.SWORD

# 검 전용
@export var sword_angle_deg: float = 30.0   # 반각 (총 60°)

# 활/지팡이 공통
@export var projectile_speed: float = 300.0

# 관통 (지팡이=3, 나머지=1)
@export var pierce_count: int = 1
