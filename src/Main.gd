extends Control

var egg_scene = preload("res://src/Actors/Egg/Egg.tscn")

const pattern_path: = "res://import/Egg/Pattern"
var pattern_files: Array
var egg_caught: = {}

var rng: = RandomNumberGenerator.new()

var paused: = true

var is_fake_game_over: = false
var was_fake_game_over: = false
var fake_game_over_chance: = 0.1

const time_template: = "%d:%02d"
const base_clock_time: = 90
const minimum_clock_time: = 30
var clock_adjust_threshold: int


func _ready() -> void:
    rng.randomize()
    pattern_files = list_files_in_directory(pattern_path)
    clock_adjust_threshold = pattern_files.size() * 2 / 3

    for chicken in get_tree().get_nodes_in_group("chicken"):
        chicken.connect("spawn_egg", self, "_egg_lifecycle", [chicken])


func _process(delta: float) -> void:
    $ClockLabel.text = format_time(int(round($GameTimer.time_left)))


func _on_GameTimer_timeout() -> void:
    game_over()


func _egg_lifecycle(chicken: Chicken) -> void:
    # Create an egg with one of the patterns.
    var pattern_choice = rng.randi_range(0, pattern_files.size() - 1)
    var pattern_file = "%s/%s" % [pattern_path, pattern_files[pattern_choice]]

    var new_egg = egg_scene.instance()
    new_egg.init(pattern_file)
    new_egg.position = Vector2(chicken.position.x, chicken.position.y + 40)
    $Game.add_child(new_egg)

    # When the egg is caught, check for a victory or game over
    yield(new_egg, "caught")
    if egg_caught.has(pattern_file):
        # TODO
        print("GAME OVER, score: %d" % egg_caught.size())
        game_over()
        return

    # If there is a fake game over and a new egg is caught, end the fake
    print("is_fake_game_over: %s" % is_fake_game_over)
    if is_fake_game_over:
        end_fake_game_over()

    egg_caught[pattern_file] = true
    if egg_caught.size() == pattern_files.size():
        print("YOU WON! You found all %d eggs" % pattern_files.size())
        game_won()
        return

    if not was_fake_game_over and rng.randf_range(0.0, 1.0) < fake_game_over_chance:
        fake_game_over()
        return


func format_time(sec: int) -> String:
    return time_template % [floor(sec / 60), sec % 60]


func list_files_in_directory(path: String) -> Array:
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


func game_over() -> void:
    if paused:
        return

    if is_fake_game_over:
        end_fake_game_over()

    var time_left: = format_time(int(round($GameTimer.time_left)))
    pause()
    $Screens/BlurEffect.show()
    $Screens/GameOverScreen.display(
        pattern_files.size(),
        egg_caught.size(),
        time_left,
        was_fake_game_over
    )
    adjust_clock()


func game_won() -> void:
    if paused:
        return

    var time_left: = format_time(int(round($GameTimer.time_left)))
    pause()
    $Screens/BlurEffect.show()
    $Screens/GameWonScreen.display(pattern_files.size(), time_left)
    adjust_clock()


func fake_game_over() -> void:
    if paused:
        return

    is_fake_game_over = true
    was_fake_game_over = true
    print("is_fake_game_over: %s" % is_fake_game_over)
    $Screens/BlurEffect.show()
    $Screens/FakeGameOverScreen.show()


func end_fake_game_over() -> void:
    is_fake_game_over = false
    print("is_fake_game_over: %s" % is_fake_game_over)
    $Screens/BlurEffect.hide()
    $Screens/FakeGameOverScreen.hide()


func start_game() -> void:
    reset()
    unpause()


func pause() -> void:
    paused = true
    $GameTimer.stop()
    $ClockLabel.hide()
    get_tree().call_group("chicken", "pause", true)


func unpause() -> void:
    paused = false
    $GameTimer.start()
    $ClockLabel.show()
    get_tree().call_group("chicken", "pause", false)


func reset() -> void:
    if not paused:
        pause()

    egg_caught = {}
    is_fake_game_over = false
    was_fake_game_over = false
    for element in $Screens.get_children():
        element.hide()


func adjust_clock() -> void:
    if egg_caught.size() >= clock_adjust_threshold:
        if $GameTimer.wait_time > minimum_clock_time:
            $GameTimer.wait_time -= 10 + (egg_caught.size() - clock_adjust_threshold) * 2
    else:
        $GameTimer.wait_time = base_clock_time
