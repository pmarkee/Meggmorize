extends Control
class_name GameOverScreen

signal restart

const template: = "GAME OVER! You caught %d of %d eggs. Time left: %d"
const eggs_caught_template: = "You caught %d of %d eggs."
const time_left_template: = "Time left: %d"


func _on_RestartButton_pressed() -> void:
    emit_signal("restart")


func display(number_total: int, number_caught: int, time_left: int) -> void:
    update_elements(number_total, number_caught, time_left)
    show()


func update_elements(number_total: int, number_caught: int, time_left: int) -> void:
    $CenterContainer/VBoxContainer/EggsCaughtLabel.text = eggs_caught_template % [number_caught, number_total]
    $CenterContainer/VBoxContainer/TimeLeftLabel.text = time_left_template % time_left
