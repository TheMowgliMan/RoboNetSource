extends Control

var HTML_label = preload("res://Scenes/UI/HTMLParagraphLabel.tscn");

func set_title(text):
	$Container/TitleLabel.text = text

func add_label(text):
	var label = HTML_label.instance()
	
	label.text = text.xml_unescape()
	
	$Container/WebpageContainer/Scrolling/VerticalSplitter.add_child(label)
	
func free_children():
	for child in $Container/WebpageContainer/Scrolling/VerticalSplitter.get_children():
		child.queue_free()
