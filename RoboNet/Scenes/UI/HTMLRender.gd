extends Control

var HTML_label = preload("res://Scenes/UI/HTMLParagraphLabel.tscn");

signal go_to_link(link)

func set_title(text):
	$Container/TitleLabel.text = text

func add_label(text, is_link):
	var label = HTML_label.instance()
	
	label.text = text.xml_unescape()
	
	if is_link:
		label.add_color_override("font_color", Color.blue)
		label.connect("go_to_link", self, "_on_link_clicked")
	
	$Container/WebpageContainer/Scrolling/VerticalSplitter.add_child(label)
	
func free_children():
	for child in $Container/WebpageContainer/Scrolling/VerticalSplitter.get_children():
		child.queue_free()

func _on_link_clicked(link):
	emit_signal("go_to_link", link)
