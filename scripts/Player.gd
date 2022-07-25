extends KinematicBody2D

var baseSpeed = 100
var baseSpeedRunning = 200
var speed = 100  # speed in pixels/sec
var velocity = Vector2.ZERO

enum {
	MOVE,
	ATTACK
}

var state = MOVE
var random = RandomNumberGenerator.new()
onready var characterDictionary = preload("res://scripts/CharacterDictionary.gd").new() 
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
var randomSpriteNumber

onready var sprite = $Sprite

func _ready():
	pickSkin()
	
	
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
	


func move_state(delta):
	if Input.is_action_pressed("run"):
		speed = baseSpeedRunning
	else:
		speed = baseSpeed
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Move/blend_position", input_vector)
		animationTree.set("parameters/Punch/blend_position", input_vector)
		animationState.travel("Move")
		velocity = velocity.move_toward(input_vector * speed, 100)
	else:
		animationState.travel("Idle")
		velocity = Vector2.move_toward(Vector2.ZERO, 0)
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("punch"):
		state = ATTACK
	

func attack_state(delta):
	animationState.travel("Punch")
	pass

func pickSkin():
	random.randomize()
	randomSpriteNumber = random.randi_range(0,characterDictionary.character.size() - 1)
	sprite.texture = load("res://assets/Actor/Characters/"+characterDictionary.character[randomSpriteNumber]+"/SpriteSheet.png")
