extends Label

var time_elapsed: float = 0.0
var is_running: bool = true

func _process(delta: float) -> void:
	if is_running:
		time_elapsed += delta
		text = format_time(time_elapsed)
		
func format_time(seconds: float) -> String:
	var minutes: int = int(seconds / 60)
	var remaining_sec: int = int(seconds) % 60
	var mili_sec: int = int((seconds - int(seconds)) * 100)
	return "%02d:%02d.%02d" % [minutes, remaining_sec, mili_sec]
