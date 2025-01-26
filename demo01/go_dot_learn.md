# godot 学习笔记

官方文档: https://docs.godotengine.org/zh-cn/4.x


## 基本概念
- godot有四个关键概念: 场景、节点、场景树与信号; 「场景」可以指任意某个抽象的东西;「节点」是godot最小的单元, 一个节点可以代表某个场景在某个方面的属性, 因此一个或多个节点组成一个场景; 而多个场景彼此嵌套构建成一个树形结构便称为「场景树」; 节点之间通过「信号」来进行通信;

- 组织项目: 设置游戏窗口大小、拉伸模式;

- 斜向的向量计算需要归一化， 不然斜着走的速度会比单方向直行更快
	- `Vector2.normalized()`
- 分组对同一节点生成的场景进行批量操作

- Camera3D 正交投影
	- 所有的投影线都是平行的。这意味着物体的大小不会随着距离相机的远近而变化。不会产生透视效果，因此物体的形状和比例在不同距离下保持不变;
	- 常用于需要精确对齐和比例的场景，非常适合于3D视图的2D游戏、图形界面和某些类型的3D游戏（如策略游戏或建筑模拟）; 在godot中通常通过设置size来决定视窗的大小;
- Camera3D 透视投影
	- 模拟了人眼观察物体的方式, 所有的投影线会汇聚到一个或多个消失点上, 近大远小;提供深度感，使得场景看起来更真实;
	- 应用于3D游戏、动画和虚拟现实等场景; 通过通常设置POV来控制视角和可见范围;

## 节点

### 通用节点
- [Label](https://docs.godotengine.org/zh-cn/4.x/classes/class_label.html#class-label) 文本Node
-  [Button](https://docs.godotengine.org/zh-cn/4.x/classes/class_button.html#class-button) 按钮Node
-  [ColorRect](https://docs.godotengine.org/zh-cn/4.x/classes/class_colorrect.html#class-colorrect) 颜色Node
- TextureRect 背景图片Node
-  [AudioStreamPlayer](https://docs.godotengine.org/zh-cn/4.x/classes/class_audiostreamplayer.html#class-audiostreamplayer) 音效Node

### 2D常用节点
- area2D: 碰撞Node，子节点添加CollisionShapre2D或者CollisionPolygon2D, 检测其他CollisionObject2D进入或者退出区域；一般用于玩家控制的场景;
	- 注意创建Node后在操作栏选择【编辑所选节点】，控制所选节点与子节点组合
- AnimatedSprite2D: 动画Node
- **RigidBody2D**: 带物理效果的Node， 与Area2D区别为Area2D由玩家支配，而该Node由物理引擎支配
- VisibleOnScreenNotifier2D： 超出屏幕发出型号Node
- Timer：计时器
- [Marker2D](https://docs.godotengine.org/zh-cn/4.x/classes/class_marker2d.html#class-marker2d) 同Node2d， 多了一个位置提示（始终在 2D 编辑器中显示十字）
- [Path2D](https://docs.godotengine.org/zh-cn/4.x/classes/class_path2d.html#class-path2d)： 移动路径Node, 可以设定怪物生成范围、移动路径等;
	- [PathFollow2D](https://docs.godotengine.org/zh-cn/4.x/classes/class_pathfollow2d.html#class-pathfollow2d) ： path2D的取样器

### 3D常用节点
-  [StaticBody3D](https://docs.godotengine.org/zh-cn/4.x/classes/class_staticbody3d.html#class-staticbody3d):  常用地板、墙壁或天花板等静态碰撞器;使用 [CollisionShape3D](https://docs.godotengine.org/zh-cn/4.x/classes/class_collisionshape3d.html#class-collisionshape3d)定义碰撞区域
- [DirectionalLight3D](https://docs.godotengine.org/zh-cn/4.x/classes/class_directionallight3d.html#class-directionallight3d) 光源
-  [CharacterBody3D](https://docs.godotengine.org/zh-cn/4.x/classes/class_characterbody3d.html#class-characterbody3d) 对应2D的 Area2D 与 RigidBody 节点, 可以移动并与环境发生碰撞
	- [CollisionShape3D](https://docs.godotengine.org/zh-cn/4.x/classes/class_collisionshape3d.html#class-collisionshape3d) 为其添加碰撞区域
-  [VisibleOnScreenNotifier3D](https://docs.godotengine.org/zh-cn/4.x/classes/class_visibleonscreennotifier3d.html#class-visibleonscreennotifier3d) 屏幕外时移除


## 常见节点组合

- 带碰撞的角色 Area2D, 子节点AnimatedSprite2D提供动画，CollisionShape2D提供碰撞判断

- 怪物、箱子、需要遵循物理规则的物品：RigidBody2D， 子节点同Area2D


## demo
- 如何支持角色操作: 
	-  「项目设置」- 「输入映射」为特定动作创建标签,再键入对应的输入动作; 一个标签可以对应多个输入的动作, 比如 W 与 上方向键 都可以对应 move_up 标签
	-  用 `Input.is_action_press("标签名")` 抓取指定操作;

- 如何支持角色移动:
	- 初始化方向:  2D用 Vector2.ZERO, 3D 用 Vector3.ZERO
	- 根据按键给指定方向增加向量; 注意 2D 加减x轴、y轴, 而 3D通常是加减 x 轴 与 z 轴; ( y轴是高度 )
	- 对不为零的向量做归一化处理:  direction = direction.normalized(), 防止侧向移动速度增加
	- 可能需要修改角色的朝向, 开始播放动画:
		- 2D 角色播放动画 `$AnimatedSprite2D.animation = "walk"`; 翻转纸片人方向 `$AnimatedSprite2D.flip_v`、`$AnimatedSprite2D.flip_h`
		- 3D角色修改朝向 `$Pviot.basis = Basis.looking_at(direction)`
	- 3D角色还需要计算y轴的内容
		- 不在地板上, 增加向下的加速度
		- 按了跳跃键, 增加向上的冲量
		- 角色的冲刺跳跃动作可能还要附带轻微的旋转 `$Pviot.rotation.x = PI / 6 * velocity.y / jump_impulse`
	- 对向量乘以速度, 即可得到移动的路程
		- 2D `position += velocity * delta`
			- 保证不越边界 `position = position.clamp(Vector2.ZERO, screen_size)`
		- 3D 直接赋值给 velocity, 执行`move_and_slide()`方法, 该方法可以让你顺利地移动一个角色。如果它在运动过程中撞到了墙，引擎会试着为你把它进行平滑处理;

- 编写怪物生成与移动:
	1. 初始化小怪实例;
	2. 随机生成一个起始位置:
		- 使用Path2D或者Path3D创建一条路径, 再使用 pathFollow 2D/3D 对这条路径进行采样
		- `var mob_spawn_location = $MobPath/MobSpawnLocation` 然后 `mob_spawn_location.progress_ratio = randf()` 得到一个path路径上随机的一个点
	3. 调整怪物朝向
		- 2D `mob.rotation = mob_spawn_location.rotation + PI / 2 + randf_range(-PI/4, PI/4)`
		- 3D `look_at_from_position(start_position, player_position, Vector3.UP)`
	4. 给怪物一个随机速度与随机方向
		- 2D `mob.linear_velocity = velocity.rotated(direction)`
		- 3D  `velocity = Vector3.FORWARD * random_speed`
	5. 最后记得add_child(mob) 将其添加到场景树;
	6. 还可以根据速度大小加快/减慢 移动动画的播放速度


