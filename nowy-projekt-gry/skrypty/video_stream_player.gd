extends VideoStreamPlayer
@onready var realbutton: Button = $"../Button"
@onready var text: Label = $"../Label"
@onready var rickroll: VideoStreamPlayer = $"."

func _on_finished() -> void:
	rickroll.hide()
	text.show()
	realbutton.show()
	
	
