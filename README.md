# O que é L2BuildQuery
- L2BuildQuery é uma biblioteca ADVPL para construção de query simples para personalizações dentro do Protheus

# Exemplos de utilização
- Consultando top 100 Clientes (SA1)
```
oBuildQuery := Library.zL2BuildQuery():new()	
oBuildQuery:tabela("SA1")
cAlias := oBuildQuery:primeiro(100) 

while (cAlias)->(!eof())
	conout((cAlias)->A1_COD + (cAlias)->A1_DESC)
	(cAlias)->(dbSkip())
enddo

(cAlias)->(DBCloseArea())	
FreeObj(oBuildQuery)
```

- Consultanto produto
 ```
oBuildQuery := Library.zL2BuildQuery():new()					
oBuildQuery:tabela("SB1") 						
oBuildQuery:onde({'B1_COD','=','0000000000001'})
cAlias := oBuildQuery:primeiro(1)
if(cAlias)->(!Eof())
	conout("Codigo: "+(cAlias)->B1_COD+" Descricao: "+(cAlias)->B1_DESC)
else
	conout("Nenhum registro encontrado")
	conout(oBuildQuery:query())
endif					
(cAlias)->(DBCloseArea())						
FreeObj(oBuildQuery)
```		


- Exibindo registros deletados
```
oBuildQuery := Library.zL2BuildQuery():new()
oBuildQuery:exibeDeletados(.T.)
oBuildQuery:nomeQuery("Exemplo de query simples com where AND E OR")
oBuildQuery:selecione({"B1_COD","B1_DESC"})
oBuildQuery:tabela("SB1")
oBuildQuery:onde({'B1_COD',"!=","000001"})
oBuildQuery:ou({'B1_DESC',"!=","CLIENTE PADRAO"})

cQuery := oBuildQuery:query() 						
cAlias := oBuildQuery:tudo()						
(cAlias)->(DBCloseArea())							
FreeObj(oBuildQuery)
```								

- Exemplo com Join SBM,SB1,SB2
```
oBuildQuery := Library.zL2BuildQuery():new()
oBuildQuery:selecione({"BM_GRUPO","BM_DESC","B1_COD","B1_DESC","*"})
oBuildQuery:tabela("SBM")
oBuildQuery:junta("SB1",{{'B1_FILIAL','BM_FILIAL'},{"B1_GRUPO","BM_GRUPO"}},"LEFT")
oBuildQuery:junta("SB2",{{"B1_FILIAL","B2_FILIAL"},{"B1_COD","B2_COD"}})
oBuildQuery:onde({'BM_GRUPO',"=","000008"})
oBuildQuery:ordene({"SB1","B1_COD DESC"})													
cAlias := oBuildQuery:tudo()						
(cAlias)->(DBCloseArea())							
FreeObj(oBuildQuery)
```						

- Exemplo com Agregação
```
oBuildQuery := Library.zL2BuildQuery():new()
oBuildQuery:selecione({"BM_GRUPO"})
oBuildQuery:agregue("COUNT","B1_COD","Q_PROD_GRUPO")
oBuildQuery:tabela("SBM")
oBuildQuery:junta("SB1",{{'B1_FILIAL','BM_FILIAL'},{"B1_GRUPO","BM_GRUPO"}})
cQuery := oBuildQuery:query() 														
cAlias := oBuildQuery:tudo()
(cAlias)->(DBCloseArea())
FreeObj(oBuildQuery)
```

	
