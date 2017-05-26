/*======================================================
** FunName   : GetCommentsTime
** Desc      : 
** InputPara : 
** OutPutPara: 
** Return Val: 
** Author    :  xiaoweilai
** Date      :  2017��5��26��
** Ver       :  1.0
======================================================*/
macro GetCommentsTime()
{
    var  year
    var  month
    var  day
    var  commTime
    var  sysTime

    sysTime = GetSysTime(1)
    year = sysTime.Year
    month = sysTime.month
    day = sysTime.day
    commTime = "@year@-@month@-@day@"
    return commTime
}
/*======================================================
** FunName   : GetCommentsPos
** Desc      : ���ע�����λ��
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
     return funPos
}

macro GetFunDescribe()
{
    str = Ask ("�����뺯������!") //ask: tip strings
    return str
}

macro GetAuthor()
{
    author = GetEnv (author_name) //get env of exist name
    if(nil == author)
    {
        str = Ask ("������������!")
        PutEnv (author_name, str)
    }

    author = GetEnv (author_name)
    return author
}

macro insertComment()
{
    var comments
    var hBuff
    var line
    var fun

    fun = GetCurSymbol()
    hBuff = GetCurrentBuf()

    line = GetCommentsPos()
    
    InsBufLine(hBuff, line, "/*====================================")
    
    comments = "* fun name:"
    comments = cat(comments,fun)
    InsBufLine(hBuff, line+1, comments)
    
    comments = "* desc    :"
    des = GetFunDescribe()
    comments = cat(comments,des)
    InsBufLine(hBuff, line+2, comments)
    
    comments = "* author  :"
    author = GetAuthor()
    comments = cat(comments,author)
    InsBufLine(hBuff, line+3, comments)
    
    comments = "* time    :"
    time = GetCommentsTime()
    comments = cat(comments,time)
    InsBufLine(hBuff, line+4, comments)
    
    InsBufLine(hBuff, line+5, "====================================*/")

    SaveBuf(hBuff)
}