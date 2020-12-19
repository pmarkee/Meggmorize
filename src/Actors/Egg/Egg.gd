extends "res://src/Actors/Actor.gd"
class_name Egg

signal caught


func init(pattern_file: String) -> void:
    $Body/Pattern.texture = load(pattern_file)


func _physics_process(delta: float) -> void:
    _velocity = move_and_slide(
        calculate_move_velocity(_velocity),
        FLOOR_NORMAL
    )


func _on_BucketDetector_area_entered(area: Area2D) -> void:
    emit_signal("caught")
    queue_free()


func calculate_move_velocity(
        linear_velocity: Vector2
    ) -> Vector2:
    var ret = linear_velocity
    ret.y += gravity * get_physics_process_delta_time()
    return ret


func _on_VisibilityNotifier2D_screen_exited() -> void:
    queue_free()
