extends Control

var HTML_label = preload("res://Scenes/UI/HTMLParagraphLabel.tscn");

func set_title(text):
	$Container/TitleLabel.text = text

func add_label(text, is_link):
	var label = HTML_label.instance()
	
	label.text = text.xml_unescape()
	
	if is_link:
		label.add_color_override("font_color", Color.blue)
	
	$Container/WebpageContainer/Scrolling/VerticalSplitter.add_child(label)
	
func free_children():
	for child in $Container/WebpageContainer/Scrolling/VerticalSplitter.get_children():
		child.queue_free()
