extends Node2D

# Código desenvolvido com auxílio do ChatGPT (OpenAI),
# em 28/10/2026, para o sistema de surgimento de inimigos.

@export var cena_bolha: PackedScene
@export var alvo: Node2D

@export var intervalo_spawn: float = 4.0
@export var maximo_bolhas_ativas: int = 12

@onready var temporizador: Timer = $Timer

@onready var pontos_spawn: Array[Marker2D] = [
	$SpawnCima as Marker2D,
	$SpawnBaixo as Marker2D,
	$SpawnEsquerda as Marker2D,
	$SpawnDireita as Marker2D
]


func _ready() -> void:
	temporizador.wait_time = intervalo_spawn
	temporizador.timeout.connect(_criar_bolha)
	temporizador.start()



func _criar_bolha() -> void:
	if cena_bolha == null:
		push_error(
            "Cena Bolha não configurada no SpawnerBolhas."
		)
		return

	if not is_instance_valid(alvo):
		push_warning(
            "Configure o objeto protegido no SpawnerBolhas."
		)
		return

	var quantidade = get_tree().get_nodes_in_group("bolhas").size()

	if quantidade >= maximo_bolhas_ativas:
		return

	var ponto: Marker2D = pontos_spawn.pick_random()

	var bolha = cena_bolha.instantiate()

	if bolha == null:
		push_error(
            "Não foi possível criar a cena da bolha. Confira o arquivo atribuído."
		)
		return

	get_parent().add_child(bolha)

	bolha.global_position = ponto.global_position
	bolha.definir_alvo(alvo)
