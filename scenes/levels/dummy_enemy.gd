extends StaticBody2D
## 더미 적. 테스트 전투용. "damageable" 그룹 소속.

var health: int = 100
var _last_damage_taken: int = 0


func take_damage(amount: int) -> void:
	_last_damage_taken = amount
	health -= amount
	EventBus.enemy_damaged.emit(self, amount, global_position)
	if health <= 0:
		queue_free()
