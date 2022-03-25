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
	
	var anchor_url = ""
	var attribute_next = false
	
	for item in parsed:
		if item[1] == "str" and is_script == false and is_anchor == false:
			html_renderer.add_label(item[0], false, null)
		elif item[1] == "str" and is_script == false and is_anchor == true:
			html_renderer.add_label(item[0], true, anchor_url)
		elif item[1] == "tag":
			# Page Breaks (Block Elements)
			if item[0] == "br":
				html_renderer.add_label("", false, null)
			elif item[0] == "/p":
				html_renderer.add_label("", false, null)
			elif item[0] == "/div":
				html_renderer.add_label("", false, null)
			
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
				anchor_url = ""
		elif item[1] == "attribute":
			if item[0] == "href" and is_anchor:
				attribute_next = true
		elif item[1] == "attribute_data" and is_anchor and attribute_next:
			anchor_url = item[0]
				
	html_renderer.set_title("Page Loaded!")


func _on_HTMLRender_go_to_link(link):
	$BackGround/UIContainer/VerticalContainer/BarContainer/BarDivider/PageName.text = link
	_on_new_page_pressed()
