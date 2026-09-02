# Roteiro dos 15 minutos — apresentação da cartilha

Para levar no celular. As frases entre aspas são para dizer do jeito que
estão; o resto é instrução para vocês.

**Divisão:** um apresenta, **outro anota**, o terceiro cuida da foto e do
material. Trocam de papel se apresentarem mais de uma vez.

---

## Antes de começar (2 minutos)

- Abram a cartilha **antes**, com a página já carregada. Não dependam da rede
  do lugar.
- Tenham o `claro.pcap` e `cifrado.pcap` abertos no Wireshark, se levarem
  notebook. Se for só celular, a cartilha basta — a captura está dentro dela.
- Quem anota: papel e caneta na mão, ou o bloco de notas do celular aberto.
- Peçam a autorização da foto **agora**, no começo, não no fim:
  > "A gente pode tirar uma foto no fim pra anexar no trabalho da faculdade?
  > Quem não quiser aparecer, é só avisar que a gente tira de outro jeito."

## 1 · Abertura — 30 segundos

> "A gente fez um trabalho na faculdade sobre uma coisa que acontece quando
> vocês usam o Wi-Fi de um lugar público — shopping, hospital, aeroporto,
> café. Dá 15 minutinhos pra gente mostrar? É rápido e tem a ver com senha de
> banco."

Não digam "redes de computadores", "protocolo" nem "camada". A palavra que
prende é **senha**.

## 2 · O gancho — 2 minutos

Mostrem as duas barras de endereço da cartilha, lado a lado. **Perguntem
antes de explicar:**

> "Olhem essas duas. É a mesma loja, a mesma página. Em qual das duas vocês
> digitariam a senha do banco de vocês?"

Deixem responderem. Alguém vai apontar a de baixo, a do cadeado. Ótimo.
Alguém pode dizer "não sei" — melhor ainda, é honesto.

> "É essa mesmo. A diferença inteira está nesse cadeadinho aqui do lado do
> endereço. E a maioria das pessoas nunca olha pra ele."

**Se ninguém responder**, não encham o silêncio na hora. Contem até três. Aí:

> "Pode chutar, não tem resposta errada aqui."

## 3 · A prova — 3 minutos

Esta é a parte que convence. Mostrem o print do Wireshark na cartilha.

> "Isso aqui não é um desenho, é uma foto de verdade. A gente montou uma rede
> pequena no computador, inventou uma senha — essa aqui, 'grupo-07' — e
> mandou ela por um site sem cadeado. Aí a gente foi olhar o que passou pelo
> caminho."

Apontem a linha destacada com o dedo.

> "Tá escrita aqui. Do jeitinho que a gente digitou. Não tá embaralhada, não
> tá com asterisco, não tá escondida. Qualquer um que estivesse no caminho
> lia isso."

Pausa. Deixem a informação assentar.

> "E a gente fez o mesmo teste com o cadeado ligado. Aí, no lugar dessa
> linha, sai só um monte de caractere sem sentido. A senha continua passando
> pelo mesmo caminho — só que embaralhada, e só o site consegue desembaralhar."

**Se levaram notebook**, mostrem as duas telas do Wireshark aqui. É mais
forte que a imagem impressa.

## 4 · Quem consegue ler — 2 minutos

A pergunta que naturalmente vem é "mas quem leria?". Antecipem:

> "E quem consegue ler isso? Não é qualquer um sentado na mesa do lado — o
> aparelho de Wi-Fi entrega a mensagem de cada um só pra quem é. Quem vê tudo
> é quem tá **no caminho**: o aparelho que distribui a internet do lugar. E
> quem controla esse aparelho."

> "Na casa de vocês, esse aparelho é de vocês. No café, é de outra pessoa — e
> vocês não têm como saber de quem, nem o que ela faz com o que passa por
> ali."

Mostrem o desenho da cartilha (celular → Wi-Fi do lugar → site) enquanto
falam. O desenho faz o trabalho sozinho.

## 5 · O que fazer — 3 minutos

**Nunca terminem no susto.** Todo alerta sai com o que fazer a respeito.

> "São três coisas, e nenhuma é complicada."

**Uma:**
> "Antes de digitar senha, olhem se tem o cadeado. Se o navegador escrever
> 'Não seguro', ele tá falando com vocês — não é detalhe técnico. Sem
> cadeado: não digita senha, não digita cartão, não digita CPF."

**Duas:**
> "Se for coisa de banco ou compra, e vocês estiverem numa rede que não é de
> vocês, desliguem o Wi-Fi e usem a internet do próprio celular. Gasta um
> pouco de dado, é mais lento, e resolve o problema inteiro."

**Três:**
> "Liguem a verificação em duas etapas — aquele código que chega por SMS ou
> no aplicativo na hora de entrar. Com ela ligada, mesmo que alguém descubra
> a senha, ainda não consegue entrar. E vocês ficam sabendo que alguém
> tentou."

## 6 · As perguntas — 5 minutos, e é aqui que está a nota

> "Alguma dúvida? Pode perguntar qualquer coisa, inclusive coisa que pareça
> boba — se ficou confuso, o problema é do nosso material, não de quem
> perguntou."

**Quem anota, entra em ação.** Escreva a pergunta **nas palavras da pessoa**,
não traduzida. Se não der tempo, escreva as primeiras palavras e complete
depois — mas complete no mesmo dia.

Não respondam rápido demais. O silêncio de três segundos é o que faz a
segunda pessoa levantar a mão.

---

## Perguntas prováveis, e o que responder

**"Mas o Wi-Fi do shopping tem senha. Não é seguro então?"**
> "Essa senha protege contra quem tá fora, na rua, tentando entrar na rede.
> Ela não protege de quem controla o aparelho — e no shopping, esse aparelho
> não é seu. São duas proteções diferentes."

**"Então o cadeado quer dizer que o site é confiável?"**
> "Não, e essa é a parte que confunde todo mundo. O cadeado garante que
> ninguém no caminho lê o que você mandou. Ele não garante que quem tá do
> outro lado é honesto. Site de golpe também pode ter cadeado — por isso
> confere o endereço, letra por letra."

**"E se eu já digitei minha senha assim?"**
> "Troca a senha, e olha nas configurações da conta se tem 'acessos
> recentes' — dá pra ver se entraram de algum lugar estranho. E aproveita e
> liga a verificação em duas etapas."

**"Vocês conseguem ver a minha senha agora?"**
> "Não. A gente fez isso numa rede que a gente mesmo montou, com uma senha
> que a gente inventou, dentro do computador. Capturar rede dos outros é
> crime, e é justamente o que a cartilha alerta pra vocês se protegerem."

Essa última pergunta aparece com frequência, e responder bem é o que mantém a
confiança da sala.

**"Usar 4G gasta muito dado?"**
> "Pra entrar no banco e fazer um pix, quase nada — é texto. O que gasta é
> vídeo. Pra coisa importante, compensa."

---

## O que NÃO dizer

Palavras que fazem a pessoa desligar. Se escaparem, traduzam na hora:

| Não diga | Diga |
|---|---|
| pacote | o que sai do celular |
| protocolo, HTTP, TLS | com cadeado / sem cadeado |
| criptografia | embaralhado |
| roteador, ponto de acesso | o aparelho que distribui a internet |
| interceptar, capturar tráfego | ler o que passa no caminho |
| autenticação | provar quem você é |

---

## Depois, ainda no local

- [ ] Tirar a foto (autorização já pedida no começo)
- [ ] Contar as pessoas — **número exato**
- [ ] Passar o papel da lista, se for o caso
- [ ] Conferir com quem anotou: as perguntas estão legíveis?
- [ ] Anotar hora de início e fim

Preencher o [`REGISTRO.md`](REGISTRO.md) **no mesmo dia**, enquanto está
fresco.
