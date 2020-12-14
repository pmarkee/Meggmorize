extends "res://src/Actors/Actor.gd"

export(float, 0, 200) var MOVEMENT_LIMIT: = 50.0

# func _physics_process(delta: float) -> void:
#     _velocity = move_and_slide(
#         calculate_move_velocity(_velocity, get_direction(), speed),
#         FLOOR_NORMAL
#     )


func _physics_process(delta: float) -> void:
    position.x = get_viewport().get_mouse_position().x

# func get_direction() -> Vector2:
#     return Vector2(
#         Input.get_action_strength("move_right") -
#         Input.get_action_strength("move_left"),
#         0.0
#     )


func get_direction() -> Vector2:
    var delta = get_viewport().get_mouse_position() - position
    return Vector2(
        delta.normalized().x if abs(delta.x) > MOVEMENT_LIMIT else 0.0,
        0.0
    )


func calculate_move_velocity(
        linear_velocity: Vector2,
        direction: Vector2,
        speed: Vector2
    ) -> Vector2:
    return speed * direction
