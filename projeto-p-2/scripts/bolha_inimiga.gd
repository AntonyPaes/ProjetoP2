
class_name BolhaInimiga
extends CharacterBody2D

# Máquina de estados da bolha inimiga.

enum Estado {
	PERSEGUINDO,
	ATACANDO,
	ESTOURADA
}

@export var velocidade: float = 85.0

@onready var agente: NavigationAgent2D = $NavigationAgent2D

var alvo: Node2D
var estado_atual: Estado = Estado.PERSEGUINDO
var ataque_realizado: bool = false


func _ready() -> void:
	add_to_group("bolhas")

	agente.path_desired_distance = 2.0
	agente.target_desired_distance = 2.0

	await get_tree().physics_frame

	if is_instance_valid(alvo):
		agente.target_position = alvo.global_position


func definir_alvo(novo_alvo: Node2D) -> void:
	alvo = novo_alvo

	if is_inside_tree() and is_instance_valid(alvo):
		agente.target_position = alvo.global_position


func _physics_process(_delta: float) -> void:
	match estado_atual:
		Estado.PERSEGUINDO:
			_perseguir()

		Estado.ATACANDO:
			_atacar()

		Estado.ESTOURADA:
			velocity = Vector2.ZERO


func _perseguir() -> void:
	if not is_instance_valid(alvo):
		velocity = Vector2.ZERO
		return

	var direcao: Vector2

	if agente.is_navigation_finished():
		# Quando termina a rota, aproxima-se diretamente do carro.
		# A colisão física impedirá a bolha de atravessá-lo.
		direcao = global_position.direction_to(
			alvo.global_position
		)
	else:
		var proxima_posicao = agente.get_next_path_position()

		direcao = global_position.direction_to(
			proxima_posicao
		)

	velocity = direcao * velocidade
	move_and_slide()

	# Só causa dano se houver colisão física com o carro.
	for i in get_slide_collision_count():

		var colisao = get_slide_collision(i)

		if colisao.get_collider() == alvo:
			estado_atual = Estado.ATACANDO
			_atacar()
			return


func _atacar() -> void:
	if ataque_realizado:
		return

	ataque_realizado = true

	if is_instance_valid(alvo) and alvo.has_method("receber_dano"):
		alvo.receber_dano(1)

	estado_atual = Estado.ESTOURADA
	queue_free()


func estourar() -> void:
	if estado_atual == Estado.ESTOURADA:
		return

	estado_atual = Estado.ESTOURADA
	queue_free()
