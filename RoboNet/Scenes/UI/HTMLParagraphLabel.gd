extends Label


class_name HTMLLabel

export var is_link = false
export var go_to_link = ""

signal go_to_link(link)

func _process(delta):
	if is_link:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		mouse_filter = Control.MOUSE_FILTER_STOP
		



func _on_HTMLParagraphLabel_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			emit_signal("go_to_link", go_to_link)
			print("CLICK")
