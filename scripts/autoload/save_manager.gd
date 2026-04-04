extends Node
## JSON 기반 세이브/로드 매니저.

const SAVE_PATH: String = "user://save_data.json"

func save_game() -> bool:
	var data: Dictionary = PlayerData.to_save_dict()
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("SaveManager: Cannot open save file — %s" % FileAccess.get_open_error())
		return false
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	EventBus.save_completed.emit()
	return true

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("SaveManager: Cannot open save file — %s" % FileAccess.get_open_error())
		return false
	var text: String = file.get_as_text()
	file.close()
	var result = JSON.parse_string(text)
	if result == null or not result is Dictionary:
		push_error("SaveManager: Invalid or corrupted save file")
		return false
	PlayerData.load_from_dict(result)
	EventBus.load_completed.emit()
	return true

func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
