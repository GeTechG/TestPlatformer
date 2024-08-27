extends Node
class_name WorldGenerator

export var _tilemapPath: NodePath
onready var tilemap: TileMap = get_node(_tilemapPath)

export var worldSize: Vector2
export var noise: OpenSimplexNoise

func get_height_by_x(x: int) -> int:
	return int(floor((1 + noise.get_noise_1d(x)) / 2 * worldSize.y))

func generate_tileset() -> void:
	for x in range(worldSize.x):
		var currentHeight: int = get_height_by_x(x)
		for y in range(currentHeight):
			var cell_x: int = x
			var cell_y: int = int(worldSize.y - y)
			tilemap.set_cell(cell_x, cell_y, 0)
			if randi() % 10 == 0:
				tilemap.set_cell(cell_x, cell_y - 1, 1)
