extends CharacterBody3D

signal hit

# 
@export var speed = 14

@export var fall_acceleration = 75

@export var jump_impulse = 20

@export var bounce_impluse = 16

var target_velocity = Vector3.ZERO


func _physics_process(delta: float) -> void:
	# 初始化方向向量为零
	var direction = Vector3.ZERO
	
	# 检查是否按下了"向右移动"键
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	# 检查是否按下了"向左移动"键
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	# 检查是否按下了"向后移动"键
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	# 检查是否按下了"向前移动"键
	if Input.is_action_pressed("move_forward"):
		direction.z -=1	
	
	# 如果方向向量不为零，则进行归一化并更新角色的朝向
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pviot.basis = Basis.looking_at(direction)
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1
	
	# 根据方向向量和速度计算目标速度
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# 如果角色不在地板上，则增加向下的加速度
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration*delta)
	
	# 如果角色在地板上并按下了"跳跃"键，则施加跳跃冲量
	if is_on_floor() and Input.is_action_pressed("jump"):
		target_velocity.y = jump_impulse
	
	# 获取这段时间内所有的碰撞信息
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		
		# 如果碰撞体为空，则继续
		if collision.get_collider() == null:
			continue
		
		# 如果碰撞体属于"mobs"组
		if collision.get_collider().is_in_group("mobs"):
			var mob = collision.get_collider()
			print("角色位置：", position, " 怪物位置：", mob.position)
			# 如果从上方击中怪物
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				print("击中")
				mob.squash()
				# 施加反弹冲量
				target_velocity.y = bounce_impluse
				break
				
	# 更新角色的速度
	velocity = target_velocity
	# 如果目标速度的y分量大于0，打印移动信息
	if target_velocity.y > 0:
		print("移动位置：", velocity.y, " 当前坐标：", position)

	# 执行移动和滑动
	move_and_slide()
	
	$Pviot.rotation.x = PI / 6 * velocity.y / jump_impulse


func _on_mob_detector_body_entered(body: Node3D) -> void:
	print("发生碰撞！")
	die()
	
	
func die():
	hit.emit()
	queue_free()
