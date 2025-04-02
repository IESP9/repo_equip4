extends Control


func _on_torna_a_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
