extends Node
## 메인 씬. 게임 진입점.

func _ready() -> void:
	SaveManager.load_game()
	# 초기 상태가 이미 MENU이므로, 시그널을 명시적으로 emit하여
	# MENU 상태에 반응하는 UI 시스템이 초기화될 수 있게 한다.
	EventBus.game_state_changed.emit(-1, GameManager.State.MENU)
