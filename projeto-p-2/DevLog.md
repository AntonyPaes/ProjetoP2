# DEVLOG
Desenvolvimento — 21/10/2026
O que fiz: Dei continuidade à estrutura do jogo Lava-rápido tomado por bolhas de sabão, utilizando o modo top-down. Configurei as ações de entrada para movimentar o personagem nas quatro direções e trabalhei na estrutura da cena do jogador.
O que travou: Tive dificuldades para configurar a câmera, principalmente para fazer com que ela acompanhasse o personagem e respeitasse os limites do mapa.
Como ficou: O movimento do personagem foi trabalhado e iniciei a configuração da Camera2D. A câmera ainda precisa de ajustes e testes para funcionar como esperado.
Próxima etapa: Corrigir a câmera, validar os limites da arena e continuar o desenvolvimento das mecânicas de Defesa.

Desenvolvimento — 28/10/2026
O que fiz: Preparei a sprite da bolha de sabão em 32×32 pixels e trabalhei na criação da cena do inimigo, utilizando CharacterBody2D, Sprite2D, CollisionShape2D e NavigationAgent2D. Desenvolvi a lógica da máquina de estados para perseguir e atacar o objeto protegido, além do sistema de surgimento periódico das bolhas. Também criei a cena e o script do carro, com resistência inicial de 5 pontos.
O que travou: O spawner apresentou erros ao tentar instanciar a cena do inimigo. Também precisei ajustar a configuração do alvo e trabalhar na malha de navegação para permitir que as bolhas contornem os obstáculos da arena.
Como resolvi: Identifiquei a necessidade de configurar a propriedade Cena Bolha com o arquivo entities/bolha_inimiga.tscn e de definir o carro como alvo do spawner. Iniciei os ajustes da NavigationRegion2D para regenerar a malha de navegação após adicionar o carro à arena.
Próxima etapa: Testar o surgimento das bolhas, corrigir possíveis problemas de navegação, verificar o dano ao carro e integrar as condições de vitória e derrota à partida.

Aula 11 — 04/11/2026
O que fiz: Trabalhei na identidade visual do jogo, pesquisando e selecionando sprites gratuitas relacionadas a postos de gasolina e lava-rápidos. Organizei referências de cenários, pisos, máquinas e equipamentos para substituir os elementos provisórios e deixar a arena mais próxima do tema proposto.
O que travou: Encontrei dificuldades para localizar pacotes gratuitos que tivessem todos os elementos necessários em perspectiva top-down e com o mesmo estilo de pixel art.
Como resolvi: Selecionei diferentes recursos gratuitos compatíveis com a proposta visual do jogo e preparei referências para complementar o cenário com equipamentos e efeitos de água.

Desenvolvimento — 05/11/2026
O que fiz: Desenvolvi melhorias no sistema de ataque do personagem, implementando a mira direcionada pelo mouse e o disparo contínuo de jatos de água. Integrei uma spritesheet animada de efeito de água com 12 quadros para substituir o efeito visual anterior feito com linhas.
O que travou: O primeiro efeito de ataque ficou muito largo e quadrado, prejudicando a aparência do jato de água. Também foi necessário ajustar a área de colisão para acompanhar melhor o efeito visual.
Como resolvi: Ajustei a escala horizontal e vertical da animação e reduzi a abertura da área de ataque, buscando um jato mais fino e levemente comprido.
