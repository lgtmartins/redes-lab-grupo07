# Minha pequena internet

Laboratório do trabalho semestral de **Redes e Sistemas Distribuídos** —
Prof. Me. Luiz Ricardo Mantovani da Silva.

Uma topologia só, que cresce ao longo do semestre: começa com duas redes que
não se falam e termina com um serviço replicado, roteamento que se refaz
sozinho e a demonstração de por que uma senha não deve viajar sem proteção.

Tudo roda no **Google Cloud Shell**, que é gratuito, não pede cartão de crédito
e dá a cada aluno uma máquina Linux com root só dela.

---

## Começando

Construa a imagem do laboratório — uma vez por sessão do Cloud Shell:

```bash
make base
```

Suba a topologia da primeira entrega:

```bash
make up E=1
```

Rode as provas:

```bash
make verificar E=1
```

`make verificar` **começa vermelho de propósito**. O laboratório vem
incompleto: o roteiro de verificação é o enunciado de verdade, e o trabalho é
levá-lo ao verde.

Enunciado de cada entrega em [`entregas/`](entregas/).

---

## As cinco entregas

| # | Semana | Tema | Vale |
|---|---|---|---|
| [E1](entregas/E1.md) | 6 | Dois segmentos e um serviço | 0,8 |
| [E2](entregas/E2.md) | 9 | O roteador e o encapsulamento | 1,4 |
| [E3](entregas/E3.md) | 11 | O serviço não pode cair | 1,2 |
| [E4](entregas/E4.md) | 12 | A rota se refaz sozinha | 1,2 |
| — | 14 | Apresentação | 1,4 |
| [E5](entregas/E5.md) | 13 | O pacote entrega o segredo · **Cartilha** | **2,0 (Extensão)** |

E1–E4 e a apresentação compõem os 6,0 de avaliação prática. E5 é a atividade
de extensão, com nota escalonada em 1,2 / 1,7 / 2,0.

---

## Regras do jogo

**A entrega é o repositório, nunca o ambiente.** A correção é feita clonando o
repositório do grupo numa Cloud Shell limpa e rodando `make up` e
`make verificar`. Se não subir lá, não entregou.

**Evidência é obrigatória.** `make evidencias E=<n>` grava a saída da
verificação; os `.pcap` das entregas 2 e 5 vão junto. Isso é versionado — nunca
apaguem a pasta `evidencias/`.

**Imagem pequena.** A máquina do Cloud Shell é efêmera e recicla o cache de
imagens: só a pasta pessoal (5 GB) sobrevive. Por isso a base é Alpine.

**Nada de varredura de rede.** Os termos de uso do Cloud Shell proíbem
explicitamente varredura, e a conta que descumprir é desligada. Todo o trabalho
aqui é captura passiva dentro da rede virtual do próprio grupo — o que é outra
coisa, e é permitido.

---

## Para o professor

Antes de liberar para a turma, uma vez, numa Cloud Shell limpa:

```bash
make autoteste
```

Confere as quatro coisas de que o laboratório depende e que documentação
nenhuma garante: criação de bridge com sub-rede própria, `tcpdump` com
`NET_RAW` efetivo, `net.ipv4.ip_forward` por contêiner, e o pacote `bird` no
Alpine (só a E4 depende dele).

### Botão "Abrir no Cloud Shell"

Para cada entrega, na página do trabalho:

```
https://shell.cloud.google.com/cloudshell/editor
  ?cloudshell_git_repo=https://github.com/LuizRMSilva1973/redes-lab
  &cloudshell_tutorial=entregas/E1.md
  &show=ide%2Cterminal
```

O aluno cai no terminal com o repositório clonado e o enunciado aberto como
roteiro guiado ao lado. Trocar `E1.md` pela entrega da vez.

O repositório precisa estar em **GitHub ou Bitbucket**, público.

### Correção

```bash
git clone <repo-do-grupo> && cd <repo> && make up E=2 && make verificar E=2
```

Os roteiros imprimem o valor observado em cada ponto, não só passou/falhou —
dá para corrigir lendo a saída.

---

# Trabalho do grupo

> **Grupo:** grupo-07 — Luiz Guilherme Tiritan Martins, Pedro Guermandi Bressan
> e Gustavo Messa Corbe.
>
> **Token de identificação** (`e5-seguranca/token.txt`): `grupo-07`. É ele que
> aparece dentro do pacote em `claro.pcap` e que não aparece em `cifrado.pcap`.

## Entrega 1 — Plano de endereçamento

Duas sub-redes `/24`, sem sobreposição, uma por segmento.

| Segmento | Sub-rede | Máscara | Endereços no total | Endereçáveis a máquinas | Faixa útil |
|---|---|---|---|---|---|
| A | `10.0.10.0/24` | `255.255.255.0` | 256 | **254** | `10.0.10.1` – `10.0.10.254` |
| B | `10.0.20.0/24` | `255.255.255.0` | 256 | **254** | `10.0.20.1` – `10.0.20.254` |

**A conta.** O `/24` diz que os 24 primeiros bits do endereço identificam a
rede e sobram 8 bits para a máquina: 2^8 = **256** combinações. Duas delas não
podem ir para uma máquina, e por isso 256 − 2 = **254**:

* `10.0.10.0` — todos os bits de host em zero. É o nome da **rede** inteira, o
  que aparece na tabela de rotas; não é um destino.
* `10.0.10.255` — todos os bits de host em um. É o **broadcast**: um pacote
  para ele é entregue a todas as máquinas do segmento ao mesmo tempo. Se uma
  máquina o usasse como endereço próprio, não haveria como distinguir um pacote
  dirigido a ela de um pacote dirigido a todos.

**Quem ficou com o quê.**

| Máquina | Segmento | Endereço | Papel |
|---|---|---|---|
| `e1-host-a1` | A | `10.0.10.10` | host |
| `e1-host-a2` | A | `10.0.10.11` | host / grupo de controle a partir da E2 |
| `e1-srv-a` | A | `10.0.10.20` | servidor HTTP (porta 8080) |
| `e1-host-b1` | B | `10.0.20.10` | host |
| `e1-host-b2` | B | `10.0.20.11` | host |
| `router` | A e B | `10.0.10.254` / `10.0.20.254` | roteador, a partir da E2 |

Convenção adotada, e vale para o semestre inteiro: `.10`–`.19` para hosts,
`.20`–`.29` para servidores e réplicas, `.254` reservado ao roteador daquele
segmento. Reservar o `.254` desde a E1 é o que permitiu, na E2, acrescentar o
roteador sem renumerar nada.

Os trânsitos entre roteadores da E4 seguem a mesma lógica, em sub-redes
próprias: `10.0.30.0/24` (t1), `10.0.40.0/24` (t2) e `10.0.50.0/24` (t3).

### Por que A não alcança B na Entrega 1

Não é firewall, e não é o pacote ter se perdido no caminho: **o pacote nunca
saiu**.

Quando `host-a1` (`10.0.10.10/24`) tenta falar com `10.0.20.10`, ele primeiro
aplica a própria máscara aos dois endereços para decidir se o destino é vizinho
de fio. `10.0.10.10 & 255.255.255.0` dá `10.0.10.0`; `10.0.20.10 & 255.255.255.0`
dá `10.0.20.0`. São redes diferentes, então o destino **não** está no mesmo
segmento e não adianta perguntar por ele com ARP.

O host então procura na tabela de rotas alguém a quem entregar o pacote — uma
rota para `10.0.20.0/24`, ou, na falta dela, uma rota padrão. Nesta entrega ele
não tem nenhuma das duas: a rota padrão foi apagada de propósito e o roteador
ainda não existe. Sem próximo salto, o próprio sistema operacional recusa o
pacote antes de gerar qualquer quadro, e devolve **`Network is unreachable`**.

É por isso que o roteiro exige as duas metades da prova. `Network is unreachable`
é uma falha de **camada 3, na origem** — bem diferente de um timeout, que seria
o pacote ter saído e ninguém ter respondido. Um teste só do lado negativo
ficaria verde com o laboratório inteiro desligado; o lado positivo (ping dentro
de A e dentro de B) é o que mostra que as máquinas estão vivas e que o
isolamento é a topologia funcionando, não a ausência dela.

## Entrega 2 — Por que o MAC muda se o IP não muda

São dois endereçamentos com finalidades diferentes, e essa é a ideia central do
modelo de camadas.

O **endereço IP é fim a fim**. Ele diz quem originou o pacote e quem deve
recebê-lo, e essa resposta não muda enquanto o pacote estiver viajando: se
mudasse a cada trecho, o destino não saberia para quem responder e nenhuma
resposta voltaria. Por isso, na captura das duas pernas do roteador, o IP de
origem `10.0.10.10` aparece **igual nos dois lados**.

O **endereço MAC é salto a salto**. Ele só tem sentido dentro de um enlace, e
só é único ali. Quando `host-a1` manda o pacote, o quadro Ethernet vai
endereçado ao MAC do roteador — não ao MAC do destino final, que `host-a1` não
tem como conhecer e nem conseguiria alcançar diretamente. O roteador recebe o
quadro, **descarta o cabeçalho de camada 2 inteiro**, olha o IP de destino,
decide por qual perna sair e **constrói um quadro novo**, agora com o MAC da
própria perna em `seg-b` como origem e o MAC de `host-b1` como destino.

Daí o resultado impresso pela verificação: mesmo IP de origem, MACs de origem
diferentes. A carga de camada 3 atravessou inteira; o envelope de camada 2 foi
jogado fora e refeito em cada trecho.

### O print: [`e2-roteador/evidencias/encapsulamento.png`](e2-roteador/evidencias/encapsulamento.png)

O mesmo pacote, aberto nas duas pernas do roteador, com os campos marcados.
Cinco leituras saem dele, e as duas últimas nós não tínhamos planejado —
apareceram quando abrimos o Wireshark:

| Campo | Perna A | Perna B | |
|---|---|---|---|
| Ethernet · Source | `e2:3d:a8:bb:e5:59` | `92:6a:ca:a7:86:ef` | mudou |
| Ethernet · Destination | `9a:a4:97:21:d2:0c` | `7a:18:73:29:93:86` | mudou |
| IPv4 · Source | `10.0.10.10` | `10.0.10.10` | **não** mudou |
| IPv4 · Destination | `10.0.20.10` | `10.0.20.10` | **não** mudou |
| IPv4 · Time to Live | `64` | `63` | mudou |
| IPv4 · Identification | `0x1b0e` | `0x1b0e` | **não** mudou |
| IPv4 · Header Checksum | `0xed87` | `0xee87` | mudou |

**O `Identification` idêntico é o que fecha a prova.** Sem ele, alguém poderia
objetar que são dois pacotes diferentes capturados por acaso — o ping manda
vários. Mas o campo `Identification` é o número de série que a origem carimba
em cada pacote que emite: `0x1b0e` nas duas pernas significa que é o **mesmo
pacote**, não dois parecidos. Os carimbos de tempo reforçam: `.120754` e
`.120766`, 12 microssegundos de diferença.

**O `Header Checksum` mudou, e mudou pela quantidade exata.** De `0xed87` para
`0xee87` — subiu `0x0100`. Isso não é coincidência: o TTL ocupa o byte alto de
uma das palavras de 16 bits do cabeçalho, então diminuir 1 no TTL diminui
`0x0100` naquela palavra, e o checksum, que é o complemento de um da soma,
sobe exatamente `0x0100`. O roteador não recalculou o cabeçalho inteiro: ele
ajustou o checksum de forma incremental, que é o que a RFC 1624 descreve.
Fazer a conta completa a cada salto seria caro demais.

Ou seja: o roteador **não é um repetidor**. Ele desmonta o quadro, mexe no
cabeçalho IP (TTL e checksum), monta um quadro novo — e não toca em mais nada.

Duas consequências que valem guardar:

* **O MAC precisa mudar** porque o segmento B é outro domínio de camada 2. O
  MAC de `host-a1` não existe lá; um quadro com ele nunca seria entregue.
* **O TTL cai de 64 para 63** porque essa reconstrução tem um preço contado.
  Cada roteador que refaz o quadro subtrai um do TTL, e o pacote que chega a
  zero é descartado. É o que impede um erro de roteamento de virar um pacote
  circulando para sempre — e é a assinatura, legível no ping, de que houve
  mesmo um salto, e não dois hosts no mesmo fio.

## Entrega 3 — Réplica morta × réplica particionada

**Não, o nosso cliente não distingue as duas.** E isso não é um descuido dele: é
uma impossibilidade.

Do lado de cá, os dois casos produzem exatamente o mesmo sinal — **silêncio**.
Quando `docker stop` mata a `replica1`, ela some e não responde. Quando
`docker network disconnect` tira a `replica3` da rede, ela continua viva,
processando, achando que está tudo bem — e também não responde. O cliente vê o
timeout de 1 segundo estourar nos dois casos, e nada no que ele recebe (que é
nada) diferencia um do outro.

Esse é o resultado que torna sistemas distribuídos difíceis: **é impossível, num
sistema assíncrono, distinguir com certeza um processo que falhou de um processo
lento ou incomunicável.** A única evidência disponível é a ausência de resposta,
e ausência de resposta tem várias causas possíveis.

**Isso é um problema?** Depende do que se faz com a incerteza.

* Para o nosso cliente, **não**. Ele só precisa de *alguma* réplica que
  responda. Se a `replica1` está morta ou apenas incomunicável dá no mesmo: em
  qualquer dos casos ela não serve agora, e a pergunta vai para a seguinte.
  Nunca anunciamos uma réplica que não respondeu — a trava
  `case "$r" in replica[123])` existe justamente para isso, porque responder
  rápido e errado é pior que demorar.
* Para o **serviço**, sim, e muito. Se as réplicas escrevessem dados em vez de
  só servir uma página, tratar "não respondeu" como "morreu" seria perigoso: a
  réplica particionada continua viva e pode continuar aceitando escritas do
  outro lado da partição. Promover outra réplica no lugar dela cria duas
  autoridades sobre o mesmo dado — o *split brain*. É por isso que sistemas
  reais não decidem isso por timeout: exigem quórum, para que apenas o lado da
  partição com a maioria continue operando.

Nosso serviço escapa porque é somente-leitura e as três réplicas servem conteúdo
idêntico. O timeout curto resolve o nosso problema; ele não resolveria o do
banco de dados.

## Entrega 4 — Convergência e o custo do vetor de distância

**Tempo medido: 21 s, depois 30 s, depois 14 s** — três execuções, mesma
topologia, mesma máquina, nada alterado entre elas. Não é ruído de medição: é o
resultado.

O RIP anuncia a tabela **a cada 30 segundos**, e a notícia da queda só começa a
andar no próximo anúncio. Se o enlace cai logo depois de um anúncio, espera-se
quase o ciclo inteiro; se cai pouco antes do seguinte, a notícia sai quase de
imediato. O tempo de convergência do vetor de distância não é um número, é um
**intervalo** — aqui, algo entre poucos segundos e o ciclo de 30 s, mais o tempo
de a nova rota descer para a tabela do kernel. Os 14 s e os 30 s que medimos são
as duas pontas desse intervalo aparecendo na prática.

Isso responde a "quanto custa a convergência" melhor que qualquer valor único, e
é a razão de o roteiro comparar o **antes** com o **depois** em vez de cravar um
prazo: o que precisa ser verdade é que a rede volta e que o caminho mudou, não
que ela volte em N segundos.

O valor de cada execução sai na linha `observado: levou Ns — esse é o custo da
convergência`, e a saída inteira fica gravada em
`e4-roteamento/evidencias/verificacao.txt`.

**O que aconteceu nesse tempo.** Com a rota estática, derrubar o trânsito 1
matava a rede: a decisão de ir por `10.0.30.12` tinha sido congelada por quem
escreveu o arquivo, e o roteador não tem como saber que o mundo mudou. O desvio
por r3 continuava de pé, saudável, e ninguém o usava — e quando o cabo voltava,
a rota nem voltava sozinha, porque tinha sumido junto com a interface.

Com RIP, r1 não decide sozinho: ele escuta. Antes da queda chegavam dois
anúncios para `10.0.20.0/24` — o de r2 pelo t1 custando 1 salto, o de r3 pelo t2
custando 2. Vence o menor, e o próximo salto é `10.0.30.12`. Quando o t1 cai, o
anúncio de r2 para de chegar; passado o tempo de espera, r1 descarta aquela rota
e passa a usar a única que sobrou, a de r3 — e o próximo salto vira
`10.0.40.13`. É por isso que o roteiro compara o **antes** com o **depois**: se
o caminho depois fosse idêntico, a rede teria voltado por outro motivo e nada
teria convergido.

**E numa rede com 50 roteadores?** Fica pior, e por três razões distintas:

1. **A convergência é linear no diâmetro da rede.** No vetor de distância
   ninguém conhece a topologia: cada roteador só sabe o que o vizinho lhe
   contou. A notícia de que um enlace caiu se propaga **de vizinho em vizinho**,
   um salto por rodada de anúncios (no RIP, a cada 30 s). Numa rede de 3
   roteadores a notícia atravessa tudo em um ou dois passos; numa de 50, num
   diâmetro proporcional ao tamanho da rede — dezenas de segundos viram minutos.
2. **A contagem ao infinito.** Enquanto a notícia ruim se espalha, dois
   roteadores podem ficar anunciando um ao outro um caminho que já não existe,
   cada um confiando no outro e somando um salto por vez, subindo devagar até o
   RIP dar a rede por inalcançável em 16. Durante todo esse intervalo há rotas
   erradas em uso e pacotes andando em círculo. Os paliativos clássicos —
   *split horizon*, *poison reverse*, *hold-down* — reduzem o problema e cobram
   ainda mais tempo de espera em troca.
3. **O tráfego cresce com a tabela.** Cada roteador manda a tabela inteira a
   todos os vizinhos a cada 30 s, tenha mudado algo ou não. Com 50 roteadores
   isso é tabela grande, periódica e majoritariamente redundante.

É exatamente esse conjunto de custos que motiva o **estado de enlace** (OSPF):
em vez de repassar conclusões já digeridas ("eu chego lá em 2 saltos"), cada
roteador inunda a rede com o fato bruto ("estes são os meus enlaces e o custo
deles"), todos montam o mesmo mapa e cada um calcula o caminho mais curto
sozinho, com Dijkstra. A notícia chega a todo mundo quase junto, em vez de
caminhar de vizinho em vizinho, e não existe contagem ao infinito — ninguém
depende da conclusão alheia. O preço é mais memória e mais CPU em cada
roteador, o que em 1988 era caro e hoje não é.

## Entrega 5 — O pacote entrega o segredo

**A regra que veio antes de tudo:** a captura foi feita **só dentro do
laboratório do grupo**, entre máquinas do grupo, com um segredo inventado pelo
grupo. Nenhum tráfego de rede alheia foi capturado em momento algum.

**Por que a captura é feita no roteador.** Numa rede comutada, um computador
qualquer não enxerga o tráfego dos outros: o switch entrega cada quadro só na
porta de quem é o destino. Quem vê tudo é quem está **no caminho**. No
laboratório esse lugar é o roteador — e é por isso que o `tcpdump` roda nele, e
não no cliente. No café da esquina, esse mesmo lugar é o ponto de acesso Wi‑Fi,
e quem o controla.

**O que as duas capturas mostram.** As duas metades da prova se sustentam uma na
outra, e nenhuma delas valeria sozinha:

* `claro.pcap` (HTTP, porta 8080) — o cabeçalho `Authorization: Bearer <token>`
  aparece **em letras legíveis**. Não há nada a decifrar: o texto está ali.
* `cifrado.pcap` (HTTPS, porta 8443) — o mesmo pedido, com o mesmo token, e o
  token **não aparece**. Mas a captura precisa ter pacotes: uma captura vazia
  "esconderia" qualquer coisa, e o verde não significaria nada. Por isso o
  roteiro conta os pacotes antes de aceitar a ausência do segredo.

**Sobre o aviso do navegador.** O certificado do laboratório é assinado por nós
mesmos, então o cliente precisa de `curl -k` e um navegador mostraria "a
conexão não é particular". O aviso é sobre **quem** é o servidor — ninguém em
quem o navegador já confie garantiu a identidade dele — e não sobre a cifra ter
falhado. A cifra funcionou: é isso que `cifrado.pcap` mostra. As duas coisas que
o cadeado promete são diferentes, e essa distinção entra na cartilha.

**A cartilha** está em [`e5-seguranca/cartilha/`](e5-seguranca/cartilha/), com
a captura do próprio grupo embutida no arquivo.

**O registro da atividade de extensão** fica em
[`e5-seguranca/extensao/`](e5-seguranca/extensao/): apresentamos a 4
familiares entre 55 e 82 anos, e nenhuma das três perguntas que ouvimos era
sobre o assunto da cartilha. Todas eram sobre golpe por mensagem — voz
imitada, tela falsa de banco, link clicado sem querer.

Esse é o achado da atividade, e ele custa reconhecer: escrevemos o material a
partir do que **nós** medimos, não a partir do que o público **teme**. A
captura de pacote prova um risco real, mas não era o risco que aquelas quatro
pessoas encontram na vida delas. A diferença é o vetor — a cartilha fala de
quem escuta no meio do caminho; elas perguntaram sobre quem chega pela frente
e mente.

A [`cartilha-v2.html`](e5-seguranca/cartilha/cartilha-v2.html) responde às três
perguntas numa seção nova, sem abandonar a captura. A v1 continua no
repositório, intocada: a comparação entre as duas é a evidência de que houve
retorno e mudança.

## Onde isto foi verificado

As cinco entregas ficaram verdes em **dois ambientes independentes**, cada um a
partir de um clone limpo deste repositório:

| Ambiente | Docker | Compose | Resultado |
|---|---|---|---|
| Ubuntu 26.04 no WSL2 | 29.1.3 | 2.40.3 | E1–E5 completas |
| Google Cloud Shell | 29.7.2 | v5.5.0 | E1–E5 completas |

O segundo é o que conta: é o ambiente da correção, e o teste foi feito clonando
do GitHub numa sessão nova, sem nada pré-construído.

### Uma diferença entre os dois, e o que ela nos ensinou

No WSL2, o primeiro `make up E=4` de um clone limpo **falhava**:

```
failed to solve: image "docker.io/library/redes-lab-bird:1": already exists
```

Os três roteadores da E4 declaram `build: .` apontando para a mesma tag, o
compose 2.40.3 os constrói em paralelo, e dois chegam juntos ao passo de
exportar a imagem. Um perde a corrida e o `up` inteiro aborta. O detalhe
traiçoeiro é que a imagem fica criada pela tentativa que ganhou — na segunda
vez tudo funciona, e o defeito some.

Passamos a construir a imagem do BIRD no `make base`, em série, e o problema
desapareceu. **Mas o laboratório original não falha no Cloud Shell:** testamos
lá, clonando o repositório do professor, e ele sobe de primeira. Não isolamos
qual variável explica a diferença — o compose v5 provavelmente deduplica
serviços que compartilham tag e contexto de build.

Então a mudança no `Makefile` é **precaução**, não conserto de defeito do
laboratório. Registramos assim de propósito: a primeira versão deste README
afirmava que o problema atingiria a turma inteira, e essa afirmação não
sobreviveu ao teste. Medir num ambiente e generalizar para outro é o mesmo erro
que o roteiro da E1 combate ao exigir as duas metades da prova.

## Evidências

Geradas na Cloud Shell, uma por entrega:

```bash
make evidencias E=1   # … até E=5
```

| Entrega | Arquivos |
|---|---|
| 1 | `e1-segmentos/evidencias/verificacao.txt` |
| 2 | `e2-roteador/evidencias/verificacao.txt`, `perna-a.pcap`, `perna-b.pcap`, print do Wireshark |
| 3 | `e3-replicas/evidencias/verificacao.txt` |
| 4 | `e4-roteamento/evidencias/verificacao.txt` |
| 5 | `e5-seguranca/evidencias/verificacao.txt`, `claro.pcap`, `cifrado.pcap`, cartilha e registro da apresentação |
