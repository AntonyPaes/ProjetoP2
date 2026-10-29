class_name BolhaInimiga
extends CharacterBody2D

# Código desenvolvido com auxílio do ChatGPT (OpenAI),
# em 28/10/2026, seguindo o requisito de navegação da Aula 10.

enum Estado {
	PERSEGUINDO,
	ATACANDO,
	ESTOURADA
}

@export var velocidade: float = 85.0
@export var distancia_ataque: float = 56.0

@onready var agente: NavigationAgent2D = $NavigationAgent2D

var alvo: Node2D
var estado_atual: Estado = Estado.PERSEGUINDO
var ataque_realizado: bool = false


func _ready() -> void:
	add_to_group("bolhas")

	agente.path_desired_distance = 4.0
	agente.target_desired_distance = 12.0

	# Aguarda a sincronização inicial da navegação.
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

	var distancia = global_position.distance_to(
		alvo.global_position
	)

	# Transição: perseguir -> atacar.
	if distancia <= distancia_ataque:
		estado_atual = Estado.ATACANDO
		velocity = Vector2.ZERO
		return

	if agente.is_navigation_finished():
		velocity = Vector2.ZERO

		# Permite o ataque quando a navegação termina
		# próximo à borda navegável do objeto protegido.
		if distancia <= distancia_ataque + 24.0:
			estado_atual = Estado.ATACANDO

		return

	var proxima_posicao = agente.get_next_path_position()
	var direcao = global_position.direction_to(proxima_posicao)

	velocity = direcao * velocidade
	move_and_slide()


func _atacar() -> void:
	velocity = Vector2.ZERO

	if ataque_realizado:
		return

	ataque_realizado = true

	if is_instance_valid(alvo) and alvo.has_method("receber_dano"):
		alvo.call("receber_dano", 1)
	else:
		push_warning(
            "O alvo precisa ter um método receber_dano(1)."
		)

	estado_atual = Estado.ESTOURADA
	queue_free()


func estourar() -> void:
	estado_atual = Estado.ESTOURADA
	queue_free()
