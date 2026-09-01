#!/bin/sh
# Roda em r1, r2 e r3. A variável ROLE diz qual é.
ip route del default 2>/dev/null || true
sysctl -w net.ipv4.ip_forward=1 2>/dev/null || true

# ---------- MODO ATUAL: roteamento dinâmico (RIP, vetor de distância) ----------
# O que havia aqui antes era um `case` com `ip route add`: uma decisão congelada
# na mão de quem escreveu o arquivo. Funcionava enquanto o trânsito 1 existisse
# e não voltava nunca quando ele caía — o desvio por r3 ficava de pé, saudável,
# e ninguém o usava.
#
# Agora cada roteador ANUNCIA as redes que conhece e ESCUTA as dos vizinhos.
# Ninguém aqui sabe a topologia inteira: r1 só sabe "para 10.0.20.0/24, o r2
# me cobra 1 salto e o r3 me cobra 2" — e escolhe o menor. Quando o vizinho
# some, o anúncio para de chegar e a conta é refeita sozinha.
#
# Quem faz o quê nos arquivos bird-*.conf, porque cai na prova:
#   protocol direct  publica as redes diretamente conectadas a este roteador
#   protocol rip     troca essa lista com os vizinhos, medindo em SALTOS
#   protocol kernel  escreve o resultado na tabela de rotas de verdade
# Sem o terceiro o roteador aprende o caminho e não o usa.
mkdir -p /run/bird && exec bird -f -c "/lab/bird-$ROLE.conf"
