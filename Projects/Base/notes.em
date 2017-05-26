/*======================================================
** FunName   : GetCommentsPos
** Desc      : 添加注释项
** InputPara : 
** OutPutPara: 
** Return Val: 
** Author    :  xiaoweilai
** Date      :  2017年5月26日
** Ver       :  1.0
======================================================*/
macro GetCommentsPos()
{
     var funPos
     var fun
     fun = GetCurSymbol()
     funPos = GetSymbolLine(fun)
     msg(funPos)
     stop
     return funPos
}
