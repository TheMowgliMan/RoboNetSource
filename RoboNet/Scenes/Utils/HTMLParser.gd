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
			if c == "<":
				if temp != "":
					tokens.append([temp, current_temp])
				temp = ""
				current_temp = "tag"
			if c == ">":
				if temp != "":
					tokens.append([temp, current_temp])
				temp = ""
				current_temp = "str"
			if c == " " and current_temp == "tag":
				if temp != "":
					tokens.append([temp, current_temp])
				temp = ""
				current_temp = "str"
				
				skipping_attributes = true
			elif not c in ["<", ">", "\n", "/n", "\t"]:
				temp = temp + c
		else:
			if c == ">":
				skipping_attributes = false
	
	print(tokens)
	return tokens
