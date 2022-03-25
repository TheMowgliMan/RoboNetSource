extends Node

class_name HTMLParser

export var parsed_data = {"tag":null, "content":null, "attributes":null}
var data = ""

func is_HTML(string):
	if string.to_lower().starts_with("<!doctype html>"):
		return "HTML5"
	elif string.to_lower().starts_with("<!doctype html"):
		return "HTML"
	else:
		return "Plain Text"
		
func parse_HTML(string):
	# Part One: Tokenize
	
	# 'c' is a temporary character variable
	
	var temp = ""
	var current_temp = "str"
	
	var skipping_attributes = false
	
	var tokens = []
	
	for c in string:
		if not skipping_attributes:
			if c == " " and current_temp == "attribute":
				if temp != "":
					tokens.append([temp, current_temp])
				temp = ""
				current_temp = "attribute" # Possibly Redundant
			elif c == "=" and current_temp == "attribute":
				if temp != "":
					tokens.append([temp, current_temp])
				temp = ""
				current_temp = "attribute"
			elif c == "\"" and current_temp == "attribute":
				if temp != "":
					tokens.append([temp, current_temp])
				temp = ""
				current_temp = "attribute_data"
			elif c == "\"" and current_temp == "attribute_data":
				if temp != "":
					tokens.append([temp, current_temp])
				temp = ""
				current_temp = "attribute" # Possibly Redundant
			elif c == "<":
				if temp != "":
					tokens.append([temp, current_temp])
				temp = ""
				current_temp = "tag"
			elif c == ">":
				if temp != "":
					tokens.append([temp, current_temp])
				temp = ""
				current_temp = "str"
			elif c == " " and current_temp == "tag":
				if temp != "":
					tokens.append([temp, current_temp])
				temp = ""
				current_temp = "attribute"
			elif not c in ["<", ">", "\n", "/n", "\t"]:
				temp = temp + c
		else:
			if c == ">":
				skipping_attributes = false
	
	print(tokens)
	return tokens
	
func _ready():
	parse_HTML('<a class="h3" href="https://www.openttd.org">hello</a>')
