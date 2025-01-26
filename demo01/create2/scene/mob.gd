extends CharacterBody3D

signal squashed

@export var max_speed = 18
@export var min_speed = 10

func _physics_process(delta: float) -> void:
	move_and_slide()


func initialize(start_position, player_position):
	# 从起始位置朝向玩家位置进行旋转
	look_at_from_position(start_position, player_position, Vector3.UP)
	# 随机旋转Y轴方向一定角度
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	# 生成一个随机速度在最小和最大速度之间
	var random_speed = randi_range(min_speed, max_speed)
	# 设置初始速度为前方向乘以随机速度
	velocity = Vector3.FORWARD * random_speed
	# 根据Y轴旋转调整速度方向
	velocity = velocity.rotated(Vector3.UP, rotation.y)

	$AnimationPlayer.speed_scale = random_speed / min_speed

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()

func squash():
	squashed.emit()
	queue_free()
