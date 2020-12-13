extends RigidBody2D
class_name Egg

const _pattern_path: = "res://import/Egg/Pattern"
var rng = RandomNumberGenerator.new()

var drag_possible: = false
var drag_active: = false
var drag_force: = 300


func _ready() -> void:
    rng.randomize()

    var pattern_files = _list_files_in_directory(_pattern_path)
    var pattern_choice = rng.randi_range(0, pattern_files.size() - 1)

    $Body/Pattern.texture = load("%s/%s" % [_pattern_path, pattern_files[pattern_choice]])


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
    if Input.is_action_pressed("mouse_left") and drag_possible:
        if drag_possible and not drag_active:
            drag_active = true
            $DragTimer.start()

        var direction: = (get_viewport().get_mouse_position() - position).normalized()
        applied_force = direction * drag_force
    elif Input.is_action_just_released("mouse_left") and drag_active:
        disable_drag()
        $DragTimer.stop()
    else:
        applied_force = Vector2.ZERO


func _on_Egg_mouse_entered() -> void:
    if not drag_active:
        drag_possible = true


func _on_Egg_mouse_exited() -> void:
    if not drag_active:
        drag_possible = false


func _on_DragTimer_timeout() -> void:
    disable_drag()


func disable_drag() -> void:
    print("disabling drag")
    drag_active = false
    drag_possible = false


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
