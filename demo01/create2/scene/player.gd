extends CharacterBody3D

signal hit

# 
@export var speed = 14

@export var fall_acceleration = 75

@export var jump_impulse = 20

@export var bounce_impluse = 16

var target_velocity = Vector3.ZERO


func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -=1	
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pviot.basis = Basis.looking_at(direction)
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# 不在地板上则增加向下的加速度
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration*delta)
	
	if is_on_floor() and Input.is_action_pressed("jump"):
		target_velocity.y = jump_impulse
	
	# 获取这段时间所有的碰撞信息
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		
		if collision.get_collider() == null:
			continue
		
		if collision.get_collider().is_in_group("mobs"):
			var mob = collision.get_collider()
			print("角色位置：", position, " 怪物位置：", mob.position)
			if Vector3.UP.dot(collision.get_normal()) > 0.1: # 从上方击中
				print("击中")
				mob.squash()
				target_velocity.y = bounce_impluse
				break
				
	# 移动
	velocity = target_velocity
	if target_velocity.y > 0:
		print("移动位置：", velocity.y, " 当前坐标：", position)

	move_and_slide()


func _on_mob_detector_body_entered(body: Node3D) -> void:
	print("发生碰撞！")
	die()
	
	
func die():
	hit.emit()
	queue_free()
