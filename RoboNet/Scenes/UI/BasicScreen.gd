extends CanvasLayer

var webpage_data = ""
var response_code_data = 200

var google_url = "https://www.google.com/search?q="

onready var html_renderer = $BackGround/UIContainer/VerticalContainer/WebpageContainer/Background/HTMLRender

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

func _on_new_page_pressed():
	var uniform_resource_locator = $BackGround/UIContainer/VerticalContainer/BarContainer/BarDivider/PageName.text
	
	if not uniform_resource_locator.begins_with("https://") or not uniform_resource_locator.begins_with("http://"):
		uniform_resource_locator = google_url + uniform_resource_locator.http_escape()
	
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
	var is_anchor = false
	
	for item in parsed:
		if item[1] == "str" and is_script == false and is_anchor == false:
			html_renderer.add_label(item[0], false)
		elif item[1] == "str" and is_script == false and is_anchor == true:
			html_renderer.add_label(item[0], true)
		else:
			# Page Breaks (Block Elements)
			if item[0] == "br":
				html_renderer.add_label("", false)
			elif item[0] == "/p":
				html_renderer.add_label("", false)
			elif item[0] == "/div":
				html_renderer.add_label("", false)
			
			# Script/Style Detection
			if item[0] == "script" or item[0] == "style":
				is_script = true
			elif item[0] == "/script" or item[0] == "/style":
				is_script = false
				
			# Anchor Detection
			if item[0] == "a":
				is_anchor = true
			elif item[0] == "/a":
				is_anchor = false
				
	html_renderer.set_title("Page Loaded!")
