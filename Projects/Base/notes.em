/*======================================================
** FunName   : GetCommentsPos
** Desc      : ���ע����
** InputPara : 
** OutPutPara: 
** Return Val: 
** Author    :  xiaoweilai
** Date      :  2017��5��26��
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
