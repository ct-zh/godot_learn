# godot 学习笔记

官方文档: https://docs.godotengine.org/zh-cn/4.x


## 基本概念
- godot有四个关键概念: 场景、节点、场景树与信号; 「场景」可以指任意某个抽象的东西;「节点」是godot最小的单元, 一个节点可以代表某个场景在某个方面的属性, 因此一个或多个节点组成一个场景; 而多个场景彼此嵌套构建成一个树形结构便称为「场景树」; 节点之间通过「信号」来进行通信;

- 组织项目: 设置游戏窗口大小、拉伸模式;

- 斜向的向量计算需要归一化， 不然斜着走的速度会比单方向直行更快
	- `Vector2.normalized()`
- 分组对同一节点生成的场景进行批量操作

## 节点

- [Label](https://docs.godotengine.org/zh-cn/4.x/classes/class_label.html#class-label) 文本Node
-  [Button](https://docs.godotengine.org/zh-cn/4.x/classes/class_button.html#class-button) 按钮Node
-  [ColorRect](https://docs.godotengine.org/zh-cn/4.x/classes/class_colorrect.html#class-colorrect) 颜色Node
- TextureRect 背景图片Node
-  [AudioStreamPlayer](https://docs.godotengine.org/zh-cn/4.x/classes/class_audiostreamplayer.html#class-audiostreamplayer) 音效Node
- area2D: 碰撞Node，子节点添加CollisionShapre2D或者CollisionPolygon2D, 检测其他CollisionObject2D进入或者退出区域；
	- 注意创建Node后在操作栏选择【编辑所选节点】，控制所选节点与子节点组合
- AnimatedSprite2D: 动画Node
- **RigidBody2D**: 带物理效果的Node， 与Area2D区别为Area2D由玩家支配，而该Node由物理引擎支配
- VisibleOnScreenNotifier2D： 超出屏幕发出型号Node
- Timer：计时器
- [Marker2D](https://docs.godotengine.org/zh-cn/4.x/classes/class_marker2d.html#class-marker2d) 同Node2d， 多了一个位置提示（始终在 2D 编辑器中显示十字）
- [Path2D](https://docs.godotengine.org/zh-cn/4.x/classes/class_path2d.html#class-path2d)： 移动路径Node
	- [PathFollow2D](https://docs.godotengine.org/zh-cn/4.x/classes/class_pathfollow2d.html#class-pathfollow2d) ： path2D的取样器

## 常见节点组合
- 带碰撞的角色 Area2D, 子节点AnimatedSprite2D提供动画，CollisionShape2D提供碰撞判断
- 怪物、箱子、需要遵循物理规则的物品：RigidBody2D， 子节点同Area2D