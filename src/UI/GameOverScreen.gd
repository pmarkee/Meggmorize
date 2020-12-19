extends Control
class_name GameOverScreen

signal restart

const template: = "GAME OVER! You caught %d of %d eggs. Time left: %d"
const eggs_caught_template: = "You caught %d of %d eggs."
const time_left_template: = "Time left: %d"

onready var for_real_label = $CenterContainer/VBoxContainer/ForRealLabel
onready var eggs_caught_label = $CenterContainer/VBoxContainer/EggsCaughtLabel
onready var time_left_label = $CenterContainer/VBoxContainer/TimeLeftLabel


func _on_RestartButton_pressed() -> void:
    emit_signal("restart")


func display(
        number_total: int,
        number_caught: int,
        time_left: int,
        was_fake_game_over: bool
    ) -> void:
    update_elements(number_total, number_caught, time_left, was_fake_game_over)
    show()


func update_elements(
        number_total: int,
        number_caught: int,
        time_left: int,
        was_fake_game_over: bool
    ) -> void:
    if was_fake_game_over:
        for_real_label.show()
    else:
        for_real_label.hide()

    eggs_caught_label.text = eggs_caught_template % [number_caught, number_total]
    time_left_label = time_left_template % time_left
