extends CanvasLayer

var webpage_data = ""
var response_code_data = 200

onready var html_renderer = $BackGround/UIContainer/VerticalContainer/WebpageContainer/Background/HTMLRender

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

func _on_new_page_pressed():
	var uniform_resource_locator = $BackGround/UIContainer/VerticalContainer/BarContainer/BarDivider/PageName.text
	$HTTPRequest.request(uniform_resource_locator)
	html_renderer.set_title("Loading Page...")

func _on_request_completed(result, response_code, headers, body):
	webpage_data = body.get_string_from_ascii()
	response_code_data = response_code
	
	html_renderer.set_title("Rendering Page...")
	
	render()
	
func render():
	html_renderer.free_children()
	
	var parsed = $HTMLParser.parse_HTML(webpage_data)
	
	var is_script = false
	
	for item in parsed:
		if item[1] == "str" and is_script == false:
			html_renderer.add_label(item[0])
		else:
			if item[0] == "script":
				is_script = true
			elif item[0] == "/script":
				is_script = false
				
	html_renderer.set_title("Page Loaded!")
