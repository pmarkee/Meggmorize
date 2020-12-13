extends KinematicBody2D
class_name Egg

const _pattern_path: = "res://import/Egg/Pattern"
var rng = RandomNumberGenerator.new()


func _ready() -> void:
    rng.randomize()

    var pattern_files = _list_files_in_directory(_pattern_path)
    var pattern_choice = rng.randi_range(0, pattern_files.size() - 1)
    
    print(pattern_files)
    print(pattern_files[pattern_choice])
    print("%s/%s" % [_pattern_path, pattern_files[pattern_choice]])
    # TODO
    $Body/Pattern.texture = load("%s/%s" % [_pattern_path, pattern_files[pattern_choice]])


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
