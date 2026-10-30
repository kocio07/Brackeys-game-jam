extends ProgressBar

func _ready() -> void:
	max_value = Global.boss_max_hp
	value = Global.boss_current_hp
	
func _process(_delta: float) -> void:
	max_value = Global.boss_max_hp
	value = Global.boss_current_hp
