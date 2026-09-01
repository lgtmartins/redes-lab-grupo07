#!/bin/sh
ip route del default 2>/dev/null || true
# Rota de VOLTA: sem ela o servidor recebe o pedido e não consegue responder.
ip route add 10.0.10.0/24 via 10.0.20.254
echo "area restrita do sistema" > /srv/index.html

# Versão desprotegida, na porta 8080. Continua no ar de propósito: o trabalho
# é mostrar a diferença entre as duas, não fingir que a insegura não existe.
httpd -f -p 8080 -h /srv &

# ---------- a MESMA área restrita, agora protegida por TLS, na porta 8443 ----
# O certificado é gerado a cada partida, em /tmp: chave privada não se versiona
# em repositório público — nem uma de laboratório, para não ensinar o hábito.
# (-nodes = a chave fica sem senha, senão o servidor pararia pedindo a senha e
#  ninguém estaria lá para digitar.)
openssl req -x509 -newkey rsa:2048 -nodes -days 30 -subj /CN=srv \
        -keyout /tmp/key.pem -out /tmp/cert.pem 2>/dev/null

# Este certificado é assinado por nós mesmos: nenhuma autoridade que o cliente
# já confie o avalizou. Por isso o cliente precisa de `curl -k`, e por isso o
# navegador mostra o aviso de "conexão não é particular" — o aviso é sobre
# QUEM é o servidor (autenticidade), não sobre a cifra estar funcionando.
# A cifra funciona: é o que a captura cifrado.pcap vai mostrar.
openssl s_server -accept 8443 -cert /tmp/cert.pem -key /tmp/key.pem -www -quiet &

wait
