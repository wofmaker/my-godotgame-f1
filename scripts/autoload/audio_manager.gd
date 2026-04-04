extends Node
## 오디오 매니저 스텁. 실제 구현은 F-21에서.

@export var bgm_volume: float = 0.8
@export var sfx_volume: float = 1.0

var _current_bgm: String = ""

func play_bgm(track_name: String) -> void:
	_current_bgm = track_name

func stop_bgm() -> void:
	_current_bgm = ""

func play_sfx(sfx_name: String) -> void:
	pass

func set_bgm_volume(volume: float) -> void:
	bgm_volume = clampf(volume, 0.0, 1.0)

func set_sfx_volume(volume: float) -> void:
	sfx_volume = clampf(volume, 0.0, 1.0)
