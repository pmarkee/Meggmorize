extends Control

signal finished(win, eggs_found, eggs_total, time_left)

var egg_scene = preload("res://src/Actors/Egg/Egg.tscn")

const _pattern_path: = "res://import/Egg/Pattern"
var _pattern_files: Array
var egg_caught: = {}

var rng: = RandomNumberGenerator.new()


func _ready() -> void:
    rng.randomize()
    _pattern_files = _list_files_in_directory(_pattern_path)

    for chicken in get_tree().get_nodes_in_group("chicken"):
        chicken.connect("spawn_egg", self, "_on_Chicken_spawn_egg")


func _on_Chicken_spawn_egg(chicken: Chicken) -> void:á
    # Create an egg with one of the patterns.
    var pattern_choice = rng.randi_range(0, _pattern_files.size() - 1)
    var pattern_file = "%s/%s" % [_pattern_path, _pattern_files[pattern_choice]]

    var new_egg = egg_scene.instance()
    new_egg.init(pattern_file)
    new_egg.position = Vector2(chicken.position.x, chicken.position.y + 40)
    add_child(new_egg)

    # When the egg is caught, check for a victory or game over
    yield(new_egg, "caught")
    if egg_caught.has(pattern_file):
        # TODO
        print("GAME OVER, score: %d" % egg_caught.size())
        emit_signal("finished", false, egg_caught.size(), _pattern_files.size(), 0)

    egg_caught[pattern_file] = true
    if egg_caught.size() == _pattern_files.size():
        print("YOU WON! You found all %d eggs" % _pattern_files.size())
        emit_signal("finished", true, egg_caught.size(), _pattern_files.size(), 0)


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
