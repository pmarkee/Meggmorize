extends KinematicBody2D

const FLOOR_NORMAL: = Vector2.UP
var _velocity: = Vector2.ZERO
var speed: = Vector2(500, 0)


func _physics_process(delta: float) -> void:
    _velocity = move_and_slide(
        calculate_move_velocity(_velocity, get_direction(), speed),
        FLOOR_NORMAL
    )


func get_direction() -> Vector2:
    return Vector2(
        Input.get_action_strength("move_right") -
        Input.get_action_strength("move_left"),
        0.0
    )


func calculate_move_velocity(
        linear_velocity: Vector2,
        direction: Vector2,
        speed: Vector2
    ) -> Vector2:
    return speed * direction
