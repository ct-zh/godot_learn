extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func new_game() -> void:
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	get_tree().call_group("mobs", "queue_free")
	$BGM.play()


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$BGM.stop()
	$DeathSound.play()
	


func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	
	# 随机赋值给 MobPath/MobSpawnLocation 生成一个起始位置 
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# PI = 180度， PI/2 = 90度， 让怪物初始方向垂直生成线出现
	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position
	
	# 随机方向
	direction += randf_range(-PI/4, PI/4)
	mob.rotation = direction
	
	# 创建一个 Vector2 类型的速度向量，x 分量在 150 到 250 之间随机生成，y 分量为 0。
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	# 然后，将这个速度向量根据怪物的方向进行旋转，并赋值给 mob 的 linear_velocity 属性，以设置怪物的移动速度。
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	
	
