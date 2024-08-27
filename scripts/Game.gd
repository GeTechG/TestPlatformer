extends Node

export var needCollect: int
export var coinPrefab: PackedScene
export var enemyPrefab: PackedScene

var data: Dictionary = {
	"collected": 0
}

var game_over: bool = false

func _ready() -> void:
	randomize()
	var loaded: bool = loadd()
	if not loaded:
		$WorldGenerator.noise.seed = randi()
		$EnemySpawner.spawn_enemies()
		$CoinSpawner.spawn_coins(needCollect)
	$WorldGenerator.generate_tileset()
	$CanvasLayer/GameOver.visible = false
	$CanvasLayer/YouWon.visible = false
	$CanvasLayer/collectInfo.update_info(needCollect, data.collected)

func _on_Player_dead() -> void:
	$CanvasLayer/GameOver.visible = true
	_game_over()
	_remove_save_file()

func _on_Player_collect() -> void:
	data.collected += 1
	$CanvasLayer/collectInfo.update_info(needCollect, data.collected)
	if data.collected >= needCollect:
		_game_over()
		_remove_save_file()
		$CanvasLayer/YouWon.visible = true

func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()
	get_tree().paused = false
	_remove_save_file()

func _on_exit_pressed() -> void:
	get_tree().quit()

func save() -> void:
	var saveFile: File = File.new()
	saveFile.open("user://save.dat", File.WRITE)
	saveFile.store_64($WorldGenerator.noise.seed)
	saveFile.store_8(data.collected)
	
	saveFile.store_8($Coins.get_children().size())
	for coin in $Coins.get_children():
		saveFile.store_var(coin.position)
	
	var enemies: Array = get_tree().get_nodes_in_group("enemies")
	saveFile.store_8(enemies.size())
	for enemy in enemies:
		saveFile.store_var(enemy.position)
	
	saveFile.store_var($Player.position)
	saveFile.close()

func loadd() -> bool:
	var saveFile: File = File.new()
	if saveFile.file_exists("user://save.dat"):
		saveFile.open("user://save.dat", File.READ)
		
		$WorldGenerator.noise.seed = saveFile.get_64()
		data.collected = saveFile.get_8()
		
		var coin_count: int = saveFile.get_8()
		for _i in range(coin_count):
			var coin_position: Vector2 = saveFile.get_var()
			var coin: Node2D = coinPrefab.instance()
			coin.position = coin_position
			$Coins.add_child(coin)
		
		var enemy_count: int = saveFile.get_8()
		for _i in range(enemy_count):
			var enemy_position: Vector2 = saveFile.get_var()
			var enemy: KinematicBody2D = enemyPrefab.instance()
			enemy.position = enemy_position
			$Enemies.add_child(enemy)
		
		$Player.position = saveFile.get_var()
		saveFile.close()
		return true
	return false

func _on_saveTimer_timeout() -> void:
	if not game_over:
		save()
	else:
		_remove_save_file()

func _game_over() -> void:
	get_tree().paused = true
	game_over = true

func _remove_save_file() -> void:
	var dir: Directory = Directory.new()
	dir.remove("user://save.dat")
