
extends Node2D

# Código elaborado com auxílio do ChatGPT (OpenAI).
# Gerencia as regras do modo Defesa.

@export var duracao_partida: float = 180.0

var tempo_restante: float = 0.0
var partida_encerrada: bool = false

@onready var carro = $Carro
@onready var timer_spawn: Timer = $SpawnerBolhas/Timer

@onready var tempo_label: Label = $HUD/TempoLabel
@onready var resistencia_label: Label = $HUD/ResistenciaLabel
@onready var resultado_label: Label = $HUD/ResultadoLabel


func _ready() -> void:
	tempo_restante = duracao_partida

	resultado_label.hide()

	carro.connect(
		"resistencia_alterada",
		Callable(self, "_atualizar_resistencia")
	)

	carro.connect(
		"carro_destruido",
		Callable(self, "_derrota")
	)

	_atualizar_resistencia(
		carro.get("resistencia_atual"),
		carro.get("resistencia_maxima")
	)

	_atualizar_tempo()


func _process(delta: float) -> void:
	if partida_encerrada:
		return

	tempo_restante = maxf(
		tempo_restante - delta,
		0.0
	)

	_atualizar_tempo()

	if tempo_restante <= 0.0:
		_vitoria()


func _atualizar_tempo() -> void:
	var segundos = ceili(tempo_restante)

	var minutos = int(segundos / 60)
	var restante = segundos % 60

	tempo_label.text = "TEMPO %02d:%02d" % [
		minutos,
		restante
	]


func _atualizar_resistencia(
	atual: int,
	maxima: int
) -> void:

	resistencia_label.text = "CARRO %d/%d" % [
		atual,
		maxima
	]


func _vitoria() -> void:
	_encerrar_partida(true)


func _derrota() -> void:
	_encerrar_partida(false)


func _encerrar_partida(venceu: bool) -> void:
	if partida_encerrada:
		return

	partida_encerrada = true

	timer_spawn.stop()

	$jogador.set_physics_process(false)

	# Remove as bolhas que ainda estavam na arena.
	for bolha in get_tree().get_nodes_in_group("bolhas"):
		bolha.queue_free()

	if venceu:
		resultado_label.text = "VITORIA!\nVoce protegeu o carro!"
	else:
		resultado_label.text = "DERROTA!\nO carro foi destruido!"

	resultado_label.show()
