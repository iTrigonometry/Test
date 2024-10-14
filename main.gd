extends Node

@export var mob_scene: PackedScene
var score
var start_speed = 10.0
signal game_over

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	



func new_game() -> void:
	score = 10
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()
	
	
func _on_score_timer_timeout() -> void:
	score -= 1
	$HUD.update_score(score)
	


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	


func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	var velocity = Vector2(start_speed, 0.0)
	start_speed += 1
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
	
	if score <= 0:
		game_over.emit()


func _on_hud_start_game() -> void:
	new_game()


func _on_player_hit() -> void:
	score += 1
	$HUD.update_score(score)
	

func _on_game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
	
