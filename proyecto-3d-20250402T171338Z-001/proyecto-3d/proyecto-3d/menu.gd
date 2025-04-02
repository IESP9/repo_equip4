extends Control


func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/nivel.tscn")


func _on_controles_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_de_controels.tscn")


func _on_salir_pressed() -> void:
	get_tree().quit()
