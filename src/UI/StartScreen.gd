extends Control
class_name StartScreen

signal start_game

func _on_StartGameButton_pressed() -> void:
    emit_signal("start_game")
