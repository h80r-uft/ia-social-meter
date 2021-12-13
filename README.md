# Waifu-Meter

## Objetivo

Desenvolver uma rede neural perceptron multicamadas capaz de prever a pontuação de uma entrada, _"Waifu"_, através de seus atributos de altura, idade, peso e medidas corporais.

## Abordagem

### Dataset

#### Método de coleta

Os dados foram coletados utilizando uma versão simplificada do scrapper [waifu-dataset](https://github.com/thewaifuproject/waifu-dataset), convertida para a linguagem `dart`.

#### Método de filtragem

A filtragem dos dados é efetuada para manter apenas entradas que possuem valores de idade, altura, peso, busto, cintura e quadril válidos, visto que o objetivo é observar a relação entre estes valores e a pontuação da entrada.

#### Fonte
Todos os dados vêm da plataforma [MyWaifuList](https://mywaifulist.moe), onde usuários podem cadastrar novas entradas e votar nestas.

### Pontuação

A pontuação é calculada através de _Laplace smoothing_ ¹, uma técnica que gera um valor de 0 à 1 tomando em consideração a quantidade de votos totais e também o quantitativo de votos positivos. Uma alternativa seria o uso do _limite inferior do intervalo de confiança da pontuação de Wilson para um parâmetro de Bernoulli_ ².

Esta técnica não foi utilizada, todavia, porque o nível de complexidade não justifica o ganho em precisão, para o caso aplicado. Para melhor entendimento, o artigo _How to Count Thumb-Ups and Thumb-Downs: User-Rating based Ranking of Items from an Axiomatic Perspective_ ³ demonstra a validade do método _Laplace smoothing_.

## Conclusão

Após implementação, tornou-se perceptível que é de maior interesse observar a quantia de _likes_ e _dislikes_, deste modo, a atribuição de pontuação foi descartada.

Além disso, com o desenvolvimento da rede neural foi possível observar que a base de dados selecionada não possui um padrão explícito, possivelmente causado pela alta diversidade dos usuários que originaram o conjunto de dados, deste modo, as previsões efetuadas, na maioria das vezes, indicam um número balanceado de _likes_ e _dislikes_ em pequena quantidade, o que está de acordo com a maioria dos dados estudados.

## Bibliografia

**[1]** [How To Sort By Average Rating](https://planspace.org/2014/08/17/how-to-sort-by-average-rating/)

**[2]** [How Not To Sort By Average Rating](https://www.evanmiller.org/how-not-to-sort-by-average-rating.html)

**[3]** [How to Count Thumb-Ups and Thumb-Downs: User-Rating based Ranking of Items from an Axiomatic Perspective](https://www.dcs.bbk.ac.uk/~dell/publications/dellzhang_ictir2011.pdf)

- Acesso em 11/12/2021

