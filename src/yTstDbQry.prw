#INCLUDE 'protheus.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} YtstDbQry
Exemplos de utilização da Library L2BuildQuery
@author  Leeung Meneses
@since   13/06/2023
@version 1.0 Beta
/*/
//-------------------------------------------------------------------
user function YtstDbQry()

	local oBuildQuery := nil
	local cAlias := ""

	RpcSetType(2)
	RpcSetEnv("99","01")

	/* EXEMPLOS DE QUERYES UTLIZANDO A BIBLIOTECA L2BUILDQUERY */
	/* QUERYES MENOS COMPLEXAS ------------------------ COMPARATIVO SINTAXE PADRÃO SQL NO ADVPL*/
	
	// QUERY COM TOP 100
	oBuildQuery := Library.zL2BuildQuery():new()	
	oBuildQuery:tabela("SB1") 							//cQuery := " SELECT TOP 100 * FROM RetSqlName('SB1') (NOLOCK) WHERE D_E_L_E_T_=' '

	cAlias := oBuildQuery:primeiro(100) 				//EXECUTA RETORNANDO OS 100 PRIMEIROS REGISTROS			
	cQuery := oBuildQuery:query() 						//QUERY MONDATA -> SELECT /*BUILD_QUERY:*/ TOP 100 * FROM SB1990 (NOLOCK) WHERE 1=1 AND SB1990.D_E_L_E_T_ = ' '

	while (cAlias)->(!eof())
		conout((cAlias)->B1_COD + (cAlias)->B1_DESC)
		(cAlias)->(dbSkip())
	enddo

	(cAlias)->(DBCloseArea())							//FECHA ÁREA
	FreeObj(oBuildQuery)								//DESCONSTROI O OBJETO			

	// QUERY COM WHERE
	oBuildQuery := App.Library.zL2BuildQuery():new()
	oBuildQuery:tabela("SB1") 						
	oBuildQuery:onde({'B1_COD','=','0000000000001'}) 	//WHERE
	cQuery := oBuildQuery:query() 					
	(cAlias)->(DBCloseArea())						
	FreeObj(oBuildQuery)							


	// QUERY NOMEADA COM SELECAO DE CAMPOS <SELECT> <WHERE> <AND> E <OR> E EXIBINDO DELETADOS
	oBuildQuery := App.Library.zL2BuildQuery():new()
	oBuildQuery:exibeDeletados(.T.) 					// PADRAO = .F.
	oBuildQuery:nomeQuery("Exemplo de query simples com where AND E OR") // OPCIONAL, EXIBE NA QUERY COMO COMENTARIO
	oBuildQuery:selecione({"B1_COD","B1_DESC"}) 		//cQuery += " SELECT B1_COD, B1_DESC "
	oBuildQuery:tabela("SB1") 							//cQuery += " FROM SB1010 (NOLOCK) "
	oBuildQuery:onde({'B1_COD',"!=","000001"})			//cQuery += " WHERE B1_COD != '000001' "
	oBuildQuery:ou({'B1_DESC',"!=","CLIENTE PADRAO"})   //cQuery += " OR TRIM(B1_DESC) != 'CLIENTE PADRAO' "

	cQuery := oBuildQuery:query() 						
	cAlias := oBuildQuery:tudo()						
	(cAlias)->(DBCloseArea())							
	FreeObj(oBuildQuery)								

	// QUERY COM <join> <order>
	oBuildQuery := App.Library.zL2BuildQuery():new()
	oBuildQuery:selecione({"BM_GRUPO","BM_DESC","B1_COD","B1_DESC","*"})				//cQuery += " SELECT BM_GRUPO,BM_DESC,B1_COD,B1_DESC,* "
	oBuildQuery:tabela("SBM")															//cQuery += " FROM " +RetSqlName('SBM')+ "
	oBuildQuery:junta("SB1",{{'B1_FILIAL','BM_FILIAL'},{"B1_GRUPO","BM_GRUPO"}},"LEFT")	//cQuery += " JOIN " +RetSqlName('SB1')+ " ON B1_FILIAL = BM_FILIAL AND B1_GRUPO = BM_GRUPO
	oBuildQuery:junta("SB2",{{"B1_FILIAL","B2_FILIAL"},{"B1_COD","B2_COD"}})			//cQuery += " JOIN " +RetSqlName('SB2')+ " ON B1_FILIAL = B2_FILIAL AND B1_COD = B2_COD
	oBuildQuery:onde({'BM_GRUPO',"=","000008"})											//cQuery += " WHERE BM_GRUPO = PADR('000008',GetSx3Cache('SBM','X3_TAMANHO'),' ') AND "+RetSqlName('SBM')+".D_E_L_E_T_=' '
	oBuildQuery:ordene({"SB1","B1_COD DESC"})											//cQuery += " ORDER BY B1_COD DESC "
	cQuery := oBuildQuery:query() 														
	cAlias := oBuildQuery:tudo()						
	(cAlias)->(DBCloseArea())							
	FreeObj(oBuildQuery)								

	//QUERY <JOIN> AGREGAÇÃO <COUNT>
	oBuildQuery := App.Library.zL2BuildQuery():new()
	oBuildQuery:selecione({"BM_GRUPO"})
	oBuildQuery:agregue("COUNT","B1_COD","Q_PROD_GRUPO")
	oBuildQuery:tabela("SBM")
	oBuildQuery:junta("SB1",{{'B1_FILIAL','BM_FILIAL'},{"B1_GRUPO","BM_GRUPO"}})
	cQuery := oBuildQuery:query() 														
	cAlias := oBuildQuery:tudo()
	(cAlias)->(DBCloseArea())
	FreeObj(oBuildQuery)

	
	RpcClearEnv()


return nil
