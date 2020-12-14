extends Node2D

var egg_scene = preload("res://src/Actors/Egg/Egg.tscn")

var egg_caught: = {}

func _ready() -> void:
    for chicken in get_tree().get_nodes_in_group("chicken"):
        chicken.connect("spawn_egg", self, "_on_Chicken_spawn_egg")


func _on_Chicken_spawn_egg(chicken: Chicken) -> void:
    var new_egg = egg_scene.instance()
    new_egg.position = Vector2(chicken.position.x, chicken.position.y + 200)
    new_egg.connect("caught", self, "_on_Egg_caught")
    add_child(new_egg)


func _on_Egg_caught(kind: String) -> void:
    if egg_caught.has(kind):
        # TODO
        print("GAME OVER, score: %d" % egg_caught.size())
    egg_caught[kind] = true
