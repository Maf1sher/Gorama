extends Node

const item_folder = "res://resources/items/"

var all_items: Array[ItemData] = []

func _ready():
	scan_directory_recursive(item_folder)

func scan_directory_recursive(path: String):
	var dir = DirAccess.open(path)
	if not dir:
		push_error("The folder cannot be opened.: " + path)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if file_name != "." and file_name != "..":
			var full_path = path.path_join(file_name)
			
			if dir.current_is_dir():
				scan_directory_recursive(full_path)
			else:
				try_load_item(full_path)
		
		file_name = dir.get_next()

func try_load_item(file_path: String):
	if not is_valid_item_file(file_path):
		return
		
	var clean_path = get_clean_resource_path(file_path)
	var resource = load(clean_path)
	
	if resource is ItemData:
		all_items.append(resource)

func is_valid_item_file(file_path: String) -> bool:
	return file_path.ends_with(".tres") or file_path.ends_with(".remap")

func get_clean_resource_path(file_path: String) -> String:
	return file_path.replace(".remap", "")
