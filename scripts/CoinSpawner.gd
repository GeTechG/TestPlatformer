extends Node

export var CELL_SIZE: int = 64
export var coinPrefab: PackedScene
export var _coinsPath: NodePath
export var _worldSpawnerPath: NodePath

onready var coins: Node = get_node(_coinsPath)
onready var worldSpawner: WorldGenerator = get_node(_worldSpawnerPath)

func spawn_coins(count: int) -> void:
	for i in range(count):
		var currentHeight: int = worldSpawner.get_height_by_x(i * 5)
		var new_coin: Node2D = coinPrefab.instance()
		new_coin.position = Vector2(i * 5 * CELL_SIZE, (worldSpawner.worldSize.y - currentHeight) * CELL_SIZE)
		coins.add_child(new_coin)
