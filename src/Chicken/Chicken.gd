extends StaticBody2D
class_name Chicken

signal spawn_egg(chicken)

export(float, 0, 100) var MIN_WAIT_TIME = 3.0
export(float, 1, 100) var MAX_WAIT_TIME = 6.0


func _ready() -> void:
    assert(MIN_WAIT_TIME < MAX_WAIT_TIME)
    randomize()
    timer_loop()


func _on_AnimatedSprite_animation_finished() -> void:
    print("%s animation finished" % self)


func timer_loop() -> void:
    while true:
        yield(get_tree().create_timer(rand_range(MIN_WAIT_TIME, MAX_WAIT_TIME)), "timeout")
        $AnimatedSprite.play("lay")
        yield($AnimatedSprite, "animation_finished")
        $AnimatedSprite.stop()
        $AudioStreamPlayer2D.play()
        emit_signal("spawn_egg", self)
