extends GutTest
## WeaponResource 단위 테스트.
## 기본값 및 각 무기 .tres 파일의 필드값을 검증한다.


# --- 기본값 검증 ---

func test_default_damage_is_ten() -> void:
	var res: WeaponResource = WeaponResource.new()
	assert_eq(res.damage, 10, "기본 damage는 10")

func test_default_attack_speed_is_one() -> void:
	var res: WeaponResource = WeaponResource.new()
	assert_eq(res.attack_speed, 1.0, "기본 attack_speed는 1.0")

func test_default_attack_range_is_64() -> void:
	var res: WeaponResource = WeaponResource.new()
	assert_eq(res.attack_range, 64.0, "기본 attack_range는 64.0")

func test_default_attack_pattern_is_sword() -> void:
	var res: WeaponResource = WeaponResource.new()
	assert_eq(res.attack_pattern, WeaponResource.AttackPattern.SWORD, "기본 패턴은 SWORD")

func test_default_pierce_count_is_one() -> void:
	var res: WeaponResource = WeaponResource.new()
	assert_eq(res.pierce_count, 1, "기본 pierce_count는 1")


# --- sword.tres ---

func test_sword_attack_pattern_is_sword() -> void:
	var sword: WeaponResource = load("res://resources/weapons/sword.tres")
	assert_eq(sword.attack_pattern, WeaponResource.AttackPattern.SWORD, "sword 패턴은 SWORD")

func test_sword_attack_range_is_64() -> void:
	var sword: WeaponResource = load("res://resources/weapons/sword.tres")
	assert_eq(sword.attack_range, 64.0, "sword attack_range는 64.0")

func test_sword_angle_deg_is_30() -> void:
	var sword: WeaponResource = load("res://resources/weapons/sword.tres")
	assert_eq(sword.sword_angle_deg, 30.0, "sword sword_angle_deg는 30.0")

func test_sword_attack_speed_greater_than_zero() -> void:
	var sword: WeaponResource = load("res://resources/weapons/sword.tres")
	assert_gt(sword.attack_speed, 0.0, "sword attack_speed > 0")


# --- bow.tres ---

func test_bow_attack_pattern_is_bow() -> void:
	var bow: WeaponResource = load("res://resources/weapons/bow.tres")
	assert_eq(bow.attack_pattern, WeaponResource.AttackPattern.BOW, "bow 패턴은 BOW")

func test_bow_attack_range_is_300() -> void:
	var bow: WeaponResource = load("res://resources/weapons/bow.tres")
	assert_eq(bow.attack_range, 300.0, "bow attack_range는 300.0")

func test_bow_projectile_speed_is_400() -> void:
	var bow: WeaponResource = load("res://resources/weapons/bow.tres")
	assert_eq(bow.projectile_speed, 400.0, "bow projectile_speed는 400.0")

func test_bow_pierce_count_is_one() -> void:
	var bow: WeaponResource = load("res://resources/weapons/bow.tres")
	assert_eq(bow.pierce_count, 1, "bow pierce_count는 1")

func test_bow_attack_speed_greater_than_zero() -> void:
	var bow: WeaponResource = load("res://resources/weapons/bow.tres")
	assert_gt(bow.attack_speed, 0.0, "bow attack_speed > 0")


# --- staff.tres ---

func test_staff_attack_pattern_is_staff() -> void:
	var staff: WeaponResource = load("res://resources/weapons/staff.tres")
	assert_eq(staff.attack_pattern, WeaponResource.AttackPattern.STAFF, "staff 패턴은 STAFF")

func test_staff_attack_range_is_250() -> void:
	var staff: WeaponResource = load("res://resources/weapons/staff.tres")
	assert_eq(staff.attack_range, 250.0, "staff attack_range는 250.0")

func test_staff_pierce_count_is_three() -> void:
	var staff: WeaponResource = load("res://resources/weapons/staff.tres")
	assert_eq(staff.pierce_count, 3, "staff pierce_count는 3")

func test_staff_attack_speed_greater_than_zero() -> void:
	var staff: WeaponResource = load("res://resources/weapons/staff.tres")
	assert_gt(staff.attack_speed, 0.0, "staff attack_speed > 0")
