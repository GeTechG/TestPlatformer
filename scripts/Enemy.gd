extends KinematicBody2D
class_name Enemy

export var _checkWallPath: NodePath
onready var checkWall: RayCast2D = get_node(_checkWallPath)

export var SPEED: int = 120
export var JUMP_POWER: int = 900
export var GRAVITY: int = 1500

var velocity: Vector2 = Vector2.ZERO
var direction: float

func _ready() -> void:
	change_direction()

func change_direction() -> void:
	direction = 1 - 2 * (randi() % 2)
	checkWall.cast_to.x = abs(checkWall.cast_to.x) * direction

func jump() -> void:
	velocity.y -= JUMP_POWER

func _physics_process(delta: float) -> void:
	velocity.x = direction * SPEED * delta * 100
	velocity.y += GRAVITY * delta
	
	if is_on_floor() and checkWall.is_colliding():
		jump()
	
	velocity = move_and_slide(velocity, Vector2.UP, true)
