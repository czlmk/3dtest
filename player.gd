extends CharacterBody3D
#emitted when player hit by mob
signal hit
#player speed m/s
@export var speed = 14

#down acc, m/s
@export var falll_acceleration = 75

#jump impulse applied to character upon jumping m/s
@export var jump_impulse = 20

#vertical impulse when bouncing over mob m/s
@export var bounce_impulse = 16
var target_velocity = Vector3.ZERO

func _physics_process(delta):
	#local variable for input direction
	var direction = Vector3.ZERO
	
	#check input and update
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		#setting basis property affect rotation of node
		$Pivot.look_at(position + direction, Vector3.UP)
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1
	
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse
	
	#ground velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	#vertical velocity
	if not is_on_floor(): #if in air, fall to floor
		target_velocity.y = target_velocity.y - (falll_acceleration * delta)
	
	#jumping
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
			
	#iterate through all collisions in current frame		
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		
		#if collision with ground
		if collision.get_collider() == null:
			continue
		
		#if collider with mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			#check we're hitting it from above.
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				#if so, squash it
				mob.squash()
				target_velocity.y = bounce_impulse
				#prevent further dup calls
				break
		
	#moving character
	velocity = target_velocity
	move_and_slide()


func die():
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(body: Node3D) -> void:
	die() 
