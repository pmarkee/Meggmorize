extends "res://src/Actors/Actor.gd"


func _physics_process(delta: float) -> void:
    position.x = get_viewport().get_mouse_position().x
