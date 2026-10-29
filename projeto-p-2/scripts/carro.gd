
extends StaticBody2D

# Código elaborado com auxílio do ChatGPT (OpenAI),
# em 28/10/2026, para o projeto da P2.

signal resistencia_alterada(atual: int, maxima: int)
signal carro_destruido

@export var resistencia_maxima: int = 5
var resistencia_atual: int = 5


func _ready() -> void:
	resistencia_atual = resistencia_maxima

	print(
		"Carro pronto! Resistência: ",
		resistencia_atual,
		"/",
		resistencia_maxima
	)


func receber_dano(quantidade: int = 1) -> void:
	if resistencia_atual <= 0:
		return

	resistencia_atual = maxi(
		resistencia_atual - quantidade,
		0
	)

	print(
		"Carro atingido! Resistência: ",
		resistencia_atual,
		"/",
		resistencia_maxima
	)

	resistencia_alterada.emit(
		resistencia_atual,
		resistencia_maxima
	)

	if resistencia_atual == 0:
		print("DERROTA! O carro recebeu cinco toques.")
		carro_destruido.emit()
