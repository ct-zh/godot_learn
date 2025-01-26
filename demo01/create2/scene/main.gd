extends Node

@export var mob_sence: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UserInterface/Retry.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# 刷怪逻辑
# 1. 实例化小怪
# 2. 在生成路径上随机选取位置
# 3. 获取玩家位置
# 4. 调用初始化方法初始化小怪方位
# 5. 将实例添加进Main
func _on_mob_timer_timeout() -> void:
	var mob = mob_sence.instantiate()
	
	var mob_spawn_location = $SpawnPath/SpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	
	mob.initialize(mob_spawn_location.position, player_position)
	
	add_child(mob)
	
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())
	


func _on_player_hit() -> void:
	$MobTimer.stop()
	$UserInterface/Retry.show()
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()
