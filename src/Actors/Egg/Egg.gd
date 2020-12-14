extends "res://src/Actors/Actor.gd"
class_name Egg

signal caught(kind)

const _pattern_path: = "res://import/Egg/Pattern"
var _texture_path: String

var rng = RandomNumberGenerator.new()


func _ready() -> void:
    rng.randomize()

    var pattern_files = _list_files_in_directory(_pattern_path)
    var pattern_choice = rng.randi_range(0, pattern_files.size() - 1)
    _texture_path = pattern_files[pattern_choice]

    $Body/Pattern.texture = load("%s/%s" % [_pattern_path, _texture_path])


func _physics_process(delta: float) -> void:
    _velocity = move_and_slide(
        calculate_move_velocity(_velocity, get_direction(), speed),
        FLOOR_NORMAL
    )


func _on_BucketDetector_area_entered(area: Area2D) -> void:
    emit_signal("caught", _texture_path)
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



func _list_files_in_directory(path: String) -> Array:
    var files = []
    var dir = Directory.new()
    dir.open(path)
    dir.list_dir_begin()

    while true:
        var file = dir.get_next()
        if file == "":
            break
        elif file.ends_with(".png"):
            files.append(file)

    dir.list_dir_end()

    return files


func _on_VisibilityNotifier2D_screen_exited() -> void:
    queue_free()
