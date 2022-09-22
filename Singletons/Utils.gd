extends Node

class_name Utils

#static func get_all_children_names(node):
#	var names = []
#	for child in node.get_children():
#		names.append(child.name)
#
#	return names

static func generate_unique_string(length: int) -> String:
	var ascii_letters_and_digits = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	
	var result = ""
	for _i in range(length):
		result += ascii_letters_and_digits[randi() % ascii_letters_and_digits.length()]
		
	return result
