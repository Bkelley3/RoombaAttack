extends Node
export (PackedScene) var Mob
var score
func _ready():
	randomize()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$GUI.show_game_over()
func new_game():
	score = 0
	$GUI.update_score(score)
	$Player.start($StartPosition.position)
	$StartTimer.start()
func _on_StartTimer_timeout():
    $MobTimer.start()
    $ScoreTimer.start()
func _on_ScoreTimer_timeout():
	score += 1
	$GUI.update_score(score)
func _on_MobTimer_timeout():
    # Choose a random location on Path2D.
    $MobPath/MobSpawnLocation.set_offset(randi())
    # Create a Mob instance and add it to the scene.
    var mob = Mob.instance()
    add_child(mob)
    # Set the mob's direction perpendicular to the path direction.
    var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
    # Set the mob's position to a random location.
    mob.position = $MobPath/MobSpawnLocation.position
    # Add some randomness to the direction.
    direction += rand_range(-PI / 4, PI / 4)
    mob.rotation = direction
    # Choose the velocity.
    mob.set_linear_velocity(Vector2(rand_range(mob.min_speed, mob.max_speed), 0).rotated(direction))
func _input(event):
	if Input.is_action_pressed("ui_escape"):
		get_tree().quit()
func _on_EndPosition_body_entered(body):
	game_over()
