extends Control
class_name GameWonScreen

signal restart

const template: = "YOU WON! You caught all %d eggs. Time left: %d"
const eggs_caught_template: = "You caught all %d eggs."
const time_left_template: = "Time left: %s"


func _on_RestartButton_pressed() -> void:
    emit_signal("restart")


func display(number_total: int, time_left: String) -> void:
    update_elements(number_total, time_left)
    show()


func update_elements(number_total: int, time_left: String) -> void:
    $CenterContainer/VBoxContainer/EggsCaughtLabel.text = eggs_caught_template % number_total
    $CenterContainer/VBoxContainer/TimeLeftLabel.text = time_left_template % time_left
