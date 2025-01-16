extends Node

@export var mob_scene: PackedScene

func _ready():
	$UserInterface/Retry.hide()
	
func _on_mob_timer_timeout() -> void:
	#create new instance of mob
	var mob = mob_scene.instantiate()
	
	#choose random location on spawnpath
	#store reference to the spawnlocation node
	
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	#give random offset
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	
	#spawn mob by adding to main scene
	add_child(mob)
	
	#connect mob to score label to update score
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())
	
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()
func _on_player_hit() -> void:
	$MobTimer.stop() # Replace with function body.
	$UserInterface/Retry.show()
