extends Node
## 게임 전역 상태 머신.

enum State { MENU, BASE, DUNGEON, PAUSED }

var current_state: State = State.MENU
var _previous_state: State = State.MENU

## 허용된 전환 맵
const VALID_TRANSITIONS: Dictionary = {
	State.MENU: [State.BASE],
	State.BASE: [State.DUNGEON, State.PAUSED, State.MENU],
	State.DUNGEON: [State.BASE, State.PAUSED],
	State.PAUSED: [State.BASE, State.DUNGEON, State.MENU],
}

func transition_to(new_state: State) -> bool:
	if current_state == new_state:
		return false
	if new_state not in VALID_TRANSITIONS.get(current_state, []):
		push_warning("GameManager: Invalid transition %s -> %s" % [State.keys()[current_state], State.keys()[new_state]])
		return false
	_previous_state = current_state
	current_state = new_state
	EventBus.game_state_changed.emit(_previous_state, new_state)
	return true

func pause() -> void:
	if current_state != State.PAUSED:
		transition_to(State.PAUSED)
		get_tree().paused = true

func resume() -> void:
	if current_state == State.PAUSED:
		transition_to(_previous_state)
		get_tree().paused = false
