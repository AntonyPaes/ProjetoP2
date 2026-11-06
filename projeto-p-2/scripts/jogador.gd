
extends CharacterBody2D

# Movimento, mira livre e ataque com jato de água.
# Projeto P2 - Lava-rápido tomado por bolhas de sabão.

@export var velocidade: float = 180.0

# Configurações do ataque
@export var alcance_ataque: float = 56.0
@export var abertura_ataque: float = 6.0
@export var velocidade_animacao_jato: float = 24.0
@export var intervalo_entre_jatos: float = 0.18

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D

@onready var ataque_area: Area2D = $AtaqueArea
@onready var forma_ataque: CollisionPolygon2D = $AtaqueArea/FormaAtaque
@onready var jato_visual: AnimatedSprite2D = $JatoVisual

# Última direção para a qual o personagem olhou.
var ultima_direcao: Vector2 = Vector2.DOWN

# Direção atual do ataque.
var direcao_ataque: Vector2 = Vector2.DOWN

var pode_atacar: bool = true
var ataque_ativo: bool = false

# Evita atingir a mesma bolha duas vezes no mesmo disparo.
var bolhas_atingidas: Dictionary = {}


func _ready() -> void:

	camera.make_current()

	# Configura a área de ataque.
	ataque_area.monitoring = false
	ataque_area.collision_layer = 0
	ataque_area.collision_mask = 1

	forma_ataque.disabled = false

	# Configura o formato de leque da água.
	forma_ataque.polygon = PackedVector2Array([
		Vector2(6, -2),
		Vector2(18, -4),
		Vector2(36, -5),
		Vector2(alcance_ataque, -abertura_ataque),
		Vector2(alcance_ataque, abertura_ataque),
		Vector2(36, 5),
		Vector2(18, 4),
		Vector2(6, 2)
])

	# Configura a animação do jato.
	jato_visual.hide()
	jato_visual.scale = Vector2(2, 0.75)
	jato_visual.position = Vector2.ZERO

	if jato_visual.sprite_frames == null:
		push_error("O JatoVisual não possui SpriteFrames.")
		return

	if not jato_visual.sprite_frames.has_animation("jato"):
		push_error("Crie a animação chamada jato no JatoVisual.")
		return

	# Define a animação como não repetitiva.
	jato_visual.sprite_frames.set_animation_loop(
		"jato",
		false
	)

	jato_visual.sprite_frames.set_animation_speed(
		"jato",
		velocidade_animacao_jato
	)

	# Conecta a detecção das bolhas.
	ataque_area.body_entered.connect(
		_on_ataque_area_body_entered
	)


func _physics_process(_delta: float) -> void:

	# Lê os controles de movimento.
	var direcao: Vector2 = Input.get_vector(
		"left",
		"right",
		"up",
        "down"
	)

	velocity = direcao * velocidade

	move_and_slide()

	# Atualiza a direção do personagem.
	if direcao != Vector2.ZERO and not ataque_ativo:

		ultima_direcao = direcao.normalized()

		_atualizar_animacao(ultima_direcao)

	elif direcao == Vector2.ZERO and not ataque_ativo:

		anim.stop()

	# Mantém o ataque enquanto o botão estiver pressionado.
	if Input.is_action_pressed("attack") and pode_atacar:

		_iniciar_ataque()


func _atualizar_animacao(direcao: Vector2) -> void:

	# Escolhe a animação mais próxima da direção.
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


func _iniciar_ataque() -> void:

	if not pode_atacar:
		return

	pode_atacar = false
	ataque_ativo = true

	bolhas_atingidas.clear()

	# Calcula a direção entre o personagem e o mouse.
	var mira: Vector2 = get_global_mouse_position() - global_position

	if mira.length_squared() > 1.0:

		direcao_ataque = mira.normalized()

	else:

		direcao_ataque = ultima_direcao

	# Faz o personagem olhar para a mira.
	ultima_direcao = direcao_ataque

	_atualizar_animacao(direcao_ataque)

	# Deixa o personagem parado olhando para a direção do ataque.
	anim.stop()
	anim.frame = 0

	# Posiciona e gira a área de ataque.
	ataque_area.position = Vector2.ZERO

	ataque_area.rotation = direcao_ataque.angle()

	# Posiciona e gira o efeito visual.
	jato_visual.position = direcao_ataque * (
		alcance_ataque * 0.55
	)

	jato_visual.rotation = direcao_ataque.angle()

	# Reinicia a animação do jato.
	jato_visual.frame = 0
	jato_visual.show()
	jato_visual.play("jato")

	# Ativa a detecção das bolhas.
	ataque_area.set_deferred("monitoring", true)

	# Aguarda a atualização da física.
	await get_tree().physics_frame

	# Verifica as bolhas que já estão dentro do ataque.
	for corpo in ataque_area.get_overlapping_bodies():

		_atingir_bolha(corpo)

	# Aguarda os 12 quadros da animação terminarem.
	await jato_visual.animation_finished

	# Desativa o ataque.
	ataque_area.set_deferred("monitoring", false)

	ataque_ativo = false

	jato_visual.stop()
	jato_visual.hide()

	# Aguarda antes do próximo disparo.
	await get_tree().create_timer(
		intervalo_entre_jatos
	).timeout

	pode_atacar = true


func _on_ataque_area_body_entered(corpo: Node2D) -> void:

	_atingir_bolha(corpo)


func _atingir_bolha(corpo: Node2D) -> void:

	if not ataque_ativo:
		return

	if not is_instance_valid(corpo):
		return

	# Só ataca inimigos que pertencem ao grupo bolhas.
	if corpo.is_in_group("bolhas"):

		var identificador = corpo.get_instance_id()

		if bolhas_atingidas.has(identificador):
			return

		bolhas_atingidas[identificador] = true

		if corpo.has_method("estourar"):
			corpo.estourar()
