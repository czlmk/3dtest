extends CharacterBody3D

#emitted when player jump on mob
signal squashed
#min speed of mob m/s
@export var min_speed = 10

#max speed of mob m/s
@export var max_speed = 18


func _physics_process(_delta):
	move_and_slide()
	
	
func initialize(start_position, player_position):
	#position mob by placingt it at start pos
	#rotate towards player_pos to look at player
	
	#ignore y axis to keep mob flat
	var flat_player_position = player_position
	
	#set player's y pos to same as mob's starting pos

	flat_player_position.y = start_position.y
	look_at_from_position(start_position, flat_player_position, Vector3.UP)
	#Rotate mob randomly within range of -45 and +45
	#so it doesn't move directly towards player
	rotate_y(randf_range(-PI/4, PI/4))
	
	#calculate random speed (int)
	var random_speed = randi_range(min_speed, max_speed)
	
	#calculate forward velocity representing speed
	velocity = Vector3.FORWARD * random_speed
	
	#then rotate velocity vector based on mob's Y rotation
	#in order to move in direction the mob is looking
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	$AnimationPlayer.speed_scale = random_speed / min_speed

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
	
func squash():
	squashed.emit()
	queue_free()
