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

static func remove_all_signals(node: Node) -> void:
	var signals = node.get_signal_list();
	for s in signals:
		var connections = node.get_signal_connection_list(s.name);
		
		for c in connections:
			node.disconnect(c.signal, c.target, c.method)

static func create_img_texture_from_img(img_path: String) -> ImageTexture:
	var img = Image.new()
	var itex = ImageTexture.new()
	
	img.load(img_path)
	itex.create_from_image(img)
	
	return itex

static func has_punctuation(s: String) -> bool:
	var punctuation : Array = ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")",
	"~", "`", "{", "}", "[", "]", "|", "\\", ":", ";", "\"", "'", "<", ",", ">",
	".", "/", "?", "。", " ", "-", "–", "—", "_", "+", "=", "≠", "≈", "≥", "≤", "±",
	"±", "×", "⋅", "÷", "∠", "∥", "⊥", "Δ", "~", "≅", "π", "©", "≪", "≫", "×", "∑",
	"♪", "♩"]
	
	for ch in s:
		if punctuation.has(ch):
			return true
		
	return false

static func has_forbidden_words(s: String) -> bool:
	var forbidden : Array = [
		"admin", "official", "staff", "员工", "职员", "官方",
		"正式", "員工", "職員", "工作", "仕事", "adm1n", "off1c",
	]
	
	for f in forbidden:
		if f in s:
			return true
	
	return false

static func print_error_code(e) -> void:
	if e != OK:
		print(e)
