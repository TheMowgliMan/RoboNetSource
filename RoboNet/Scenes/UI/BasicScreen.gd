extends CanvasLayer

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

func _on_new_page_pressed():
	$HTTPRequest.request($BackGround/UIContainer/VerticalContainer/BarContainer/BarDivider/PageName.text)

func _on_request_completed(result, response_code, headers, body):
	print(body)
