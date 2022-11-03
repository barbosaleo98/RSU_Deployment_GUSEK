# TRABALHO FINAL 
# Otimiza��o de Sistemas - OSI 00039
# Prof. Dr. Leandro Magat�o
# Aluno: Leonardo Barbosa da Silva

#===========================================================
# Distribui��o de RSUs para uma rede de Vehicle-to-everything
#===========================================================

# No final deste arquivo est�o os conjuntos de dados para alternar 
# entre o cen�rio da matriz 4x5 ou 10x9 apresentadas no relat�rio

# Basta comentar as linhas de dados que n�o ser�o executadas

#----------------------------------------------------------
#Defini��o de Par�metros e Conjuntos
#----------------------------------------------------------

param Lv 'numero de pontos verticais', integer;
param Lh 'numero de pontos horizontais', integer;
param alfa 'coeficiente de custo', integer;
param r 'raio de cobertura', integer;

set I  'coordenadas das linhas' := 1..Lv;
set J   'coordenadas das colunas'  := 1..Lh;

var X 'Posicionamento de RSU' {i in I, j in J}, binary;

param Mc 'Bin�ria de cobertura' {i in I, j in J}, default 0, binary;
param Md 'Bin�ria de posicionamento' {i in I, j in J}, default 0, binary;

set K  'coordenadas das linhas auxiliares' := 1..Lv;
set L   'coordenadas das colunas auxiliares'  := 1..Lh;

#----------------------------------------------------------
# Modelo de Otimiza��o 
#----------------------------------------------------------

#Fun��o Objetivo - minimizar custo de implementa��o das RSUs
minimize Z: sum {i in I} sum {j in J} (1 + alfa * Md[i,j]) * X[i,j];

# Restri��o de cobertura
subj to R {k in K, l in L}: sum {i in I} sum {j in J} 
	(if sqrt(((k-i)**2) + ((l-j)**2)) <= r then X[i,j] else 0) >= 1 - Mc[k,l];

solve;

#----------------------------------------------------------
# Visualiza��o de Resultados Obtidos
#----------------------------------------------------------

printf "\n\n ----------------------------------------------\n\n";
printf "Matriz de tamanho: %d x %d \n\n", Lv, Lh;
printf "Localiza��es �timas (i,j): \n"; 
printf "\n";
printf {i in I, j in J: X[i,j]} "Ponto (%d,%d) \n", i, j;
printf "\n----------------------------------------------\n";

#----------------------------------------------------------
# Conjunto de DADOS do Modelo 
#----------------------------------------------------------
data;

# Custo suficientemente grande
param alfa := 1000;

# Raio de cobertura
param r := 1;

# Pontos que n�o precisam ser cobertos (matriz 4x5)
param Mc := 
	[1,4] := 1
	[3,2] := 1
;

# Pontos em que n�o se pode colocar a RSU (matriz 4x5)
param Md := 
	[1,4] := 1
	[3,2] := 1
;

# n�mero de linhas (matriz 4x5)
param Lv := 4;

# n�mero de colunas (matriz 4x5)
param Lh := 5;

# Pontos que n�o precisam ser cobertos (matriz 10x9)
#param Mc := 
#	[2,5] := 1
#	[3,1] := 1
#	[6,4] := 1
#	[4,8] := 1
#	[8,7] := 1
#;

# Pontos em que n�o se pode colocar a RSU (matriz 10x9)
#param Md := 
#	[2,5] := 1
#	[3,1] := 1
#	[6,4] := 1
#	[4,8] := 1
#	[8,7] := 1
#;

# n�mero de linhas (matriz 10x9)
#param Lv := 10;

# n�mero de colunas (matriz 10x9)
#param Lh := 9;

end;