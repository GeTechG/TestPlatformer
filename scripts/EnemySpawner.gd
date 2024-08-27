extends Node
class_name EnemySpawner

signal spawn_enemy(initPosition)

export var _worldSpawnerPath: NodePath
onready var worldSpawner: WorldGenerator = get_node(_worldSpawnerPath)

export var enemyPrefab: PackedScene

export var _enemiesPath: NodePath
onready var enemies: Node = get_node(_enemiesPath)

export var maxEnemies: int = 2

var enemiesCount: int = 0

func _on_EnemySpawner_spawn_enemy(initPosition: Vector2) -> void:
	if enemiesCount < maxEnemies:
		var newEnemy: KinematicBody2D = enemyPrefab.instance()
		newEnemy.position = initPosition
		enemies.add_child(newEnemy)
		enemiesCount += 1

func spawn_enemies() -> void:
	for x in range(worldSpawner.worldSize.x):
		if randi() % 20 == 0:
			var currentHeight: int = worldSpawner.get_height_by_x(x)
			var enemyPosition: Vector2 = worldSpawner.tilemap.map_to_world(Vector2(x, worldSpawner.worldSize.y - (currentHeight + 2)))
			self.emit_signal("spawn_enemy", enemyPosition)
