#!/bin/sh
# CONTRATO (não mude): escreva na saída padrão só o nome da réplica que
# respondeu e termine com código 0; ou escreva INDISPONIVEL e termine com 1.
# Nunca demore mais que 5 segundos, mesmo com tudo fora do ar.
#
# ---- cliente com failover ----
# Três réplicas, tentadas em ordem até uma responder. O orçamento de tempo é o
# que sustenta o contrato: no pior caso (nenhuma alcançável) são 3 tentativas
# de 1 s = 3 s, com folga confortável dentro dos 5 s exigidos.
#
# Por que 1 s e não 10: com timeout longo o cliente FICA PENDURADO esperando
# quem já morreu. Quem chamou este cliente fica pendurado junto, e quem chamou
# aquele também — é assim que a queda de uma máquina derruba o sistema inteiro.
# Melhor desistir cedo desta réplica e perguntar à próxima.
REPLICAS="10.0.20.21 10.0.20.22 10.0.20.23"
LIMITE=1

for ip in $REPLICAS; do
  # --connect-timeout cobre a réplica PARTICIONADA (o pacote sai e nada volta:
  # o ARP nem resolve); -m cobre a réplica que aceita a conexão e trava depois.
  # Os dois juntos garantem que nenhuma tentativa passa de $LIMITE segundos.
  r=$(curl -s --connect-timeout "$LIMITE" -m "$LIMITE" "http://$ip:8080/" 2>/dev/null)
  r=$(printf '%s' "$r" | tr -d ' \t\r\n')

  # Só anuncia o que veio DE VERDADE pela rede, e só se tiver a cara de uma
  # resposta válida. Um curl que falhou devolve string vazia; sem esta trava, o
  # cliente "responderia" o vazio e o serviço pareceria no ar com tudo caído.
  # Responder rápido e errado é pior que demorar.
  case "$r" in
    replica[123])
      echo "$r"
      exit 0
      ;;
  esac
done

# Nenhuma das três respondeu. Note que este cliente NÃO sabe dizer se elas
# morreram ou se apenas ficaram incomunicáveis — do lado de cá, o silêncio é
# idêntico nos dois casos. Ver a discussão no README.
echo INDISPONIVEL
exit 1
