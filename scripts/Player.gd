extends KinematicBody2D
class_name Player

signal dead
signal collect

export var SPEED: int = 120
export var JUMP_POWER: int = 800
export var GRAVITY: int = 1000

var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var input_direction: float = Input.get_axis("ui_left", "ui_right")
	velocity.x = input_direction * SPEED * delta * 100
	velocity.y += GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2.UP, true)
	
	if get_slide_count() > 1:
		for slide_index in range(get_slide_count()):
			var collision: KinematicCollision2D = get_slide_collision(slide_index)
			if collision.collider is Enemy:
				emit_signal("dead")

func _input(_event):
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y -= JUMP_POWER;
