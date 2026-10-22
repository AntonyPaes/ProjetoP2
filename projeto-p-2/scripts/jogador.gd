extends CharacterBody2D

@export var velocidade: float = 180.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D


func _ready() -> void:
	camera.make_current()

func _physics_process(_delta: float) -> void:
	var direcao: Vector2 = Input.get_vector(
		"left",
		"right",
		"up",
        "down"
	)

	velocity = direcao * velocidade
	move_and_slide()

	if direcao == Vector2.ZERO:
		anim.stop()
		return

	if abs(direcao.x) > abs(direcao.y):
		if direcao.x > 0:
			anim.play("right")
		else:
			anim.play("left")
	else:
		if direcao.y > 0:
			anim.play("down")
		else:
			anim.play("up")
