extends "res://src/Actors/Actor.gd"
class_name Egg

signal caught(kind)

var _pattern_file: String setget init


func init(pattern_file: String) -> void:
    _pattern_file = pattern_file


func _ready() -> void:
    $Body/Pattern.texture = load(_pattern_file)


func _physics_process(delta: float) -> void:
    _velocity = move_and_slide(
        calculate_move_velocity(_velocity, get_direction(), speed),
        FLOOR_NORMAL
    )


func _on_BucketDetector_area_entered(area: Area2D) -> void:
    emit_signal("caught", _pattern_file)
    queue_free()


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
    var ret = linear_velocity
    ret.y += gravity * get_physics_process_delta_time()
    return ret


func _on_VisibilityNotifier2D_screen_exited() -> void:
    queue_free()
