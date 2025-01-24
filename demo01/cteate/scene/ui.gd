extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_message(text):
	$Msg.text = text
	$Msg.show()
	$MsgTimer.start()

func show_game_over():
	show_message("Game Over!")
	await $MsgTimer.timeout
	
	$Msg.text = "Dodge The Creeps!"
	$Msg.show()
	await get_tree().create_timer(1.0).timeout
	$StartBtn.show()

func update_score(score):
	$Score.text = str(score)
	

func _on_start_btn_pressed() -> void:
	$StartBtn.hide()
	start_game.emit()


func _on_msg_timer_timeout() -> void:
	$Msg.hide()
