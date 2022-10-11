programa
{	   
	inclua biblioteca Arquivos --> arq
	inclua biblioteca Texto --> txt
	inclua biblioteca Util --> ut
	
	funcao inicio()
	{	
		//chama a função introdução, onde mostra ao usuario as regras, modos de jogo, etc.. 
		introducao()
		//chama a função jogo_forca, onde está o jogo 
		jogo_forca()
	
	}

	funcao jogo_forca()
	{
		inteiro ref_arq, tamanho, tamanho_real, acertos, erros=0, dicas=0, indice=1, tempo_limite=0
		inteiro linha, coluna, sorteio
		cadeia letra, secreto, personagem[35][4]
		logico acertou, repetiu
		caracter traco[40], modo
		
		//solicita ao jogador a dificuldade em que ele quer jogar
		faca{
			escreva("+----------------------DIFICULDADE---------------------+\n")
			escreva("|                                                      |\n")
			escreva("| [F]ácil  [I]ntermediário  [D]ificil  [M]uito Dificil |\n")
			escreva("|                                                      |\n")
			escreva("+------------------------------------------------------+\n")
			escreva("Qual modo deseja Jogar: ")
			leia(modo)
			limpa()
		  }enquanto (nao (modo == 'F' ou modo == 'f' ou modo == 'I' ou modo == 'i' ou modo == 'D' ou modo == 'd' ou modo == 'M' ou modo == 'm'))
				
		//difine o tando de erros, dicas e tempo de jogo conforme a dificuldade escolhida
		escolha(modo){
			caso 'F': 
			caso 'f':
				limpa()
				escreva("Modo FÁCIL escolhido!\n\n")
				dicas = 3
				erros = 6
				tempo_limite = 241000 + ut.tempo_decorrido()
				pare
				
			caso 'I':
			caso 'i':
				escreva("Modo INTERMEDIÁRIO escolhido!\n\n")
				dicas = 2
				erros = 5
				tempo_limite = 181000 + ut.tempo_decorrido()
				pare
				
			caso 'D':
			caso 'd':
				escreva("Modo DIFICIL escolhido!\n\n")
				dicas = 1
				erros = 4
				tempo_limite = 121000 + ut.tempo_decorrido()
				pare
				
			caso 'M':
			caso 'm':
				escreva("Modo MUITO DIFICIL escolhido\n\n!")
				dicas = 0
				erros = 3
				tempo_limite = 61000 + ut.tempo_decorrido()
				pare
			caso contrario:
				escreva("escolha um modo de jogo valido")
			
		}

		//Armazena as informçaões do jogo do arquivo na matriz
		ref_arq = arq.abrir_arquivo("./jogo_marvel.txt", arq.MODO_LEITURA)
		 	para(linha=0; linha < 30; linha++){
		 		para(coluna=0; coluna < 4; coluna++){
					personagem[linha][coluna] = arq.ler_linha(ref_arq)
				}
			}
		arq.fechar_arquivo(ref_arq) //fecha o arquivo

		//sorteia o persongem
		sorteio = ut.sorteia(0, 29)
		//Obtem o tamanho de caracteres personagem sorteado
		tamanho = txt.numero_caracteres(personagem[sorteio][0])
		//tira o "P:" do nome do personagem
		secreto = txt.extrair_subtexto(personagem[sorteio][0], 2, tamanho)
		//obtem o tamanho do nome do personagem sem o "P:"
		tamanho_real = txt.numero_caracteres(secreto)
		//tanto de vezes que o jogador pode jogar conforme o nome do personagem
		acertos = tamanho_real

		//tranforma o nome do personagem em traços
		para (inteiro posicao=0; posicao < tamanho_real; posicao++){
			//desconsidera os espaços ou hifens de letras a serem acertadas
			se(txt.obter_caracter(secreto, posicao) == ' ' ou txt.obter_caracter(secreto, posicao) == '-'){
				traco[posicao] = ' '
				acertos--
			}
			senao{
				traco[posicao] = '_'
			}	
		}

		//O jogo se repete até o jogador acertar a palavra ou atigir o limite de erros
		enquanto(acertos > 0 e erros > 0){

			//informa ao usuario seus erros, dicas e tempo restantes
			escreva(erros," Erros - ",dicas," Dicas e\n") 
			escreva((tempo_limite-ut.tempo_decorrido())/ 1000, " segundos restantes...\n\n")

			//chama a função erros, onde está desenhado o boneco da forca
			erro(erros)

			//mostra ao jogador o nome do personagem em traços "_"
			para (inteiro posicao=0; posicao < tamanho_real; posicao++){
				escreva(traco[posicao], " ")
			}

			//solicita ao jogar a letra
			escreva("\nDIGITE UMA LETRA (OU NOME DO PERSONAGEM): ")
			leia(letra)
			
			//deixa como falso novamente, pois ainda será verificado se o jogador errou ou acertou
			acertou = falso
			repetiu = falso

			//verirfica se ainda tem tempo
			se(ut.tempo_decorrido() > tempo_limite){	
				limpa()
				tempo_esgotado()
				pare
			}senao se(txt.caixa_alta(letra) == "DICA"){ //verirfica se foi solicitado uma dica
				//verifica se ainda tem dicas restantes
				se(txt.caixa_alta(letra) == "DICA" e dicas > 0){
					escreva("\nDica......\n")
					escreva(personagem[sorteio][indice])
					ut.aguarde(5000)
					indice++ //aumenta o numero indice da dica em +1
					dicas-- //diminui as dicas restantes em  -1
				}senao{ 
				 	escreva("Você atingiu o limite de dicas...\n")
				 	ut.aguarde(2000)
				 	erros++ //foi colocado para não constar como erro, caso o jogador não tenha mais dicas restantes...
				 }
			}senao se(txt.caixa_alta(letra) == secreto){ //verifica se o jogador digitou o nome do personagem
				ganhou(txt.caixa_alta(secreto)) //chama a função ganhou, onde está a mensagem de vitoria
				retorne //termina o programa
				
			 }senao se(txt.caixa_alta(letra) == "DESISTIR"){ //Verifica se o jogador pediu para desistir
				limpa()
				desistiu() //chama a função desistiu, onde está a mensagem de desistência
				retorne //termina o programa
				
			 }senao{//Caso nenhuma das opções acima, verifica se o jogador acertou ou repetiu a letra
				para(inteiro posicao=0; posicao < tamanho_real; posicao++){
					se(txt.obter_caracter(txt.caixa_alta(letra), 0) == txt.obter_caracter(secreto, posicao)){	
						se(traco[posicao] == txt.obter_caracter(txt.caixa_alta(letra), 0)){
						 	repetiu = verdadeiro
						}
						senao{
							acertou = verdadeiro
							traco[posicao] = txt.obter_caracter(txt.caixa_alta(letra), 0)
							acertos-- //dimiui seus acertos em -1, ou seja ele acertou a letra
						}	
					}		
				}
			 }

			//informa ao jogador se ele repetiu, acertou ou errou a letra
			se(repetiu == verdadeiro){
				limpa()
				escreva("Você JÁ DIGITOU a letra\n")
			}
			senao se(acertou == verdadeiro){
				limpa()
				escreva("Você ACERTOU a letra\n")
			}
			senao{//se o jogador não repetiu, nem acertou, então ele errou...
				limpa()
				erros-- //dimiui seus erros em -1
				escreva("Você ERROU a letra \n")
			}		
		}//repete o laço

		//apos erros ou acertos chegarem a 0, verifica...
		//se os acertos forem igual a 0, o jogador ganhou
		se(acertos == 0){
		   limpa()	   
		   ganhou(txt.caixa_alta(secreto)) //chama a funcao ganhou, onde está a mensagem de vitória
		}
		//se os erros forem igaul a 0, o jogador perdeu
		se(erros == 0){
		   limpa()
		   erro(erros) //chama a funcao perdeu, onde está o bonequinho da forca com uma mensagem de derrota
		}	
	}//fim do jogo

	funcao introducao()
	{
		cadeia resp

		//Nome e RA
		escreva("+-----------------------ALUNOS----------------------+\n")
		escreva("| FILIPE BATISTA CASELLE - 1680482112019            |\n")
		escreva("| RICARDINO BARBOSA DA COSTA JUNIOR - 1680482112001 |\n")
		escreva("| SÉRGIO VITOR SILVA BARROS - 1680482112008         |\n")
		escreva("|                                                   |\n")
		escreva("|       JOGO[X] DICAS[X] CONTROLE DE TEMPO[X]       |\n")
		escreva("+---------------------------------------------------+\n")
		ut.aguarde(5000)
		limpa()
		
		//informa ao jogador as regras do jogo, dificuldades, etc...
		escreva("+-------------JOGO DA FORCA - PERSONAGENS MARVEL------------+\n")
		escreva("| MODOS DE JOGO                                             |\n")
		escreva("| FÁCIL: 6 Erros - 3 Dicas - 4 Minutos(240 segundos).       |\n")
		escreva("| MÉDIO: 5 Erros - 2 Dicas - 3 Minutos(180 segundos).       |\n")
		escreva("| DIFICIL: 4 Erros - 1 Dicas - 2 Minutos(120 segundos).     |\n")
		escreva("| MUITO DIFICIL: 3 Erros - 0 Dicas - 1 Minuto(60 segundos). |\n")
		escreva("+-----------------------------------------------------------+\n\n")
		ut.aguarde(3000)
		escreva("+-----------------------------------------IMPORTANTE--------------------------------------+\n")
		escreva("|                                                                                         |\n")
		escreva("| DICAS: Para ultilizar basta digitar \"dica\" no momento que for solicitado a letra, porém |\n")
		escreva("| é computado como um erro, ou seja, uma tentativa a menos.                               |\n")
		escreva("| (A DICA FICA VISIVEL POR APENAS 5 SEGUNDOS INDEPENDENTE DO MODO ESCOLHIDO)              |\n")
		escreva("|                                                                                         |\n")
		escreva("| SAIR: Para sair do jogo basta digitar \"desistir\" no momento que for solicitado a letra. |\n")
		escreva("|                                                                                         |\n")
		escreva("|        CASO O JOGADOR SOUBER O NOME DO PERSONAGEM COMPLETO, PODE SER DIGITADO           |\n")
		escreva("|                      NO MOMONETO QUE FOR SOLICITADO A LETRA.                            |\n")
		escreva("+-----------------------------------------------------------------------------------------+\n\n")
		ut.aguarde(3000)
		//espera o jogar confirmar que leu as regras para iniciar o jogo	
		escreva("Tecle \"ENTER\" para iniciar o jogo e escolher o modo: ")
		leia(resp)

		//uma animação basica para carregar o jogo
		limpa()
		escreva("Iniciando.")
		ut.aguarde(300)
		escreva(".")
		ut.aguarde(300)
		escreva(".")
		ut.aguarde(300)
		limpa()			
		
	}
	funcao desistiu()
	{
		//aparece ao jogador, um mensagem informando que ele desistiu
		limpa()
		escreva("+------------------------+","\n")
		escreva("| perda por desistência! |","\n")
		escreva("|      encerrando...     |","\n")
		escreva("+------------------------+","\n")
		escreva("     (\\_/) ||       ","\n")
		escreva("     (•.•) ||        ","\n")
		escreva("      | |==||        ","\n")
		ut.aguarde(4000)
		jogar_novamente() //chama a funcao,onde pergunta se o jogador deseja jogar novamente 
	}
	
	funcao tempo_esgotado()
	{	
		//aparece ao jogador, uma mensagem informando que o tempo esgotou...
		limpa()
		escreva("+--------------+","\n")
		escreva("| tempo        |","\n")
		escreva("|  esgotado... |","\n")
		escreva("+--------------+","\n")
		escreva("(\\_/) ||       ","\n")
		escreva("(•.•) ||        ","\n")
		escreva(" | |==||        ","\n")
		ut.aguarde(4000) 
		jogar_novamente() //chama a funcao,onde pergunta se o jogador deseja jogar novamente
	}

	funcao ganhou(cadeia texto)
	{	
		caracter resp

		//aparece ao jogador, uma mensagem informando que ele ganhou
		limpa()
		escreva("█████████ ","\n")
		escreva("█▄█████▄█ ","\n")
		escreva("█▼▼▼▼▼    ","\n")
		escreva("█     Parabeeeens, você arcetou o personagem!!\n")
		escreva("█         Personagem:", texto,"\n")
		escreva("█▲▲▲▲▲     ","\n")
		escreva("█████████  ","\n")
		escreva(" ██ ██     ","\n")
		ut.aguarde(4000) 
		jogar_novamente() //chama a funcao,onde pergunta se o jogador deseja jogar novamente
	}

	funcao erro(inteiro erros)
	{ 
		//desenha a forca conforme os "erros restantes..."
		escolha(erros){
				caso 6:
				   escreva("-----+   ","\n")
				   escreva("|    |   ","\n")
				   escreva("|        ","\n")
				   escreva("|        ","\n")
				   escreva("|        ","\n")
				   escreva("=========","\n")

				   pare
				caso 5:
				   escreva("-----+   ","\n")
				   escreva("|    |   ","\n")
				   escreva("|    0   ","\n")
				   escreva("|        ","\n")
				   escreva("|        ","\n")
				   escreva("=========","\n")

				   pare
				caso 4:
				   escreva("-----+   ","\n")
				   escreva("|    |   ","\n")
				   escreva("|    0   ","\n")
				   escreva("|    |   ","\n")
				   escreva("|        ","\n")
				   escreva("=========","\n")
				   pare	   
				caso 3:
				   escreva("-----+   ","\n")
				   escreva("|    |   ","\n")
				   escreva("|    0   ","\n")
				   escreva("|   /|   ","\n")
				   escreva("|        ","\n")
				   escreva("=========","\n")
				   pare
				caso 2:
				   escreva("-----+   ","\n")
				   escreva("|    |   ","\n")
				   escreva("|    0   ","\n")
				   escreva("|   /|\\ ","\n")
				   escreva("|        ","\n")
				   escreva("=========","\n")			  
				   pare
				   
				caso 1:
				   escreva("-----+   ","\n")
				   escreva("|    |   ","\n")
				   escreva("|    0   ","\n")
				   escreva("|   /|\\ ","\n")
				   escreva("|   /    ","\n")
				   escreva("=========","\n")	  
				   pare
				caso 0:
				   escreva("-----+                        ","\n")
				   escreva("|    |      Sinto muito...    ","\n")
				   escreva("|    0          Você perdeu!! ","\n")
				   escreva("|   /|\\                      ","\n")
				   escreva("|   / \\                      ","\n")
				   escreva("=========                     ","\n")
				   ut.aguarde(4000)
				   jogar_novamente() //chama a funcao,onde pergunta se o jogador deseja jogar novamente 
				   pare
		}
	}

	funcao personagens()
	{	
		inteiro ref_arq, linha, coluna
		caracter resp
		cadeia encerrar
		
		faca{
			limpa()
			escreva("+---Deseja visualizar todos os personagens e dicas?---+\n")
			escreva("|                                                     |\n")
			escreva("|                   [S]im ou [N]ão                    |\n")
			escreva("|                                                     |\n")
			escreva("+-----------------------------------------------------+\n")
			leia(resp)
		}enquanto (nao (resp == 'S' ou resp == 's' ou resp == 'N' ou resp == 'n'))

		//mostra todas as informações do arquivo jogo.txt ao usuário
		se(resp== 'S' ou resp== 's'){			
			limpa()
			escreva("LISTA DE PERSONAGENS E DICAS\n\n")
			
			//armazena as informçaões do jogo na matriz
			ref_arq = arq.abrir_arquivo("./jogo_marvel.txt", arq.MODO_LEITURA)
			
			enquanto(nao arq.fim_arquivo(ref_arq)){	
				escreva(arq.ler_linha(ref_arq), "\n")
			}
			//fecha o arquivo
			arq.fechar_arquivo(ref_arq)
			
			escreva("Tecle \"ENTER\" para encerrar: ")
			leia(encerrar)
		}
		senao{//volta a funcao jogar_novamente e encerra o programa
		}
	}
	
	funcao jogar_novamente()
	{
		caracter resp
		
		faca{
			limpa()
			escreva("+---Deseja jogar novamente?---+\n")
			escreva("|                             |\n")
			escreva("|        [S]im ou [N]ão       |\n")
			escreva("|                             |\n")
			escreva("+-----------------------------+\n")
			leia(resp)
		}enquanto (nao (resp == 'S' ou resp == 's' ou resp == 'N' ou resp == 'n'))

		se(resp== 'S' ou resp== 's'){		
			faca{
				limpa()
				escreva("+---Deseja pular as regras?---+\n")
				escreva("|                             |\n")
				escreva("|        [S]im ou [N]ão       |\n")
				escreva("|                             |\n")
				escreva("+-----------------------------+\n")
				leia(resp)
				limpa()
			}enquanto (nao (resp == 'S' ou resp == 's' ou resp == 'N' ou resp == 'n'))

			se(resp== 'N' ou resp== 'n'){		
				//chama a função introdução, onde mostra ao usuario as regras, modos de jogo, etc.. 
				introducao()
				//chama a função jogo_forca, onde está o jogo 
				jogo_forca()
			}
			senao{
				//chama a função jogo_forca, onde está o jogo 
				jogo_forca()
			}	
				
		}senao{
			personagens() //chama a função personagem, onde pergunta ao jogar se ele deseja visualizar os personagens
			limpa()
			escreva("Encerrando.") 
			ut.aguarde(300)
			escreva(".")
			ut.aguarde(300)
			escreva(".")
		} //encerra o programa
	}
}
