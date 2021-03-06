/* Utils.em - a small collection of useful editing macros */
/*

source insight 宏定义文件v2.1
source insight自定义宏，支持上移行，下移行，复制行，删除行，中间跳转到下一行，注释与反注释（支持多行）


source insight 宏定义文件v2.2
source insight自定义宏，支持上移行，下移行，复制行（支持多行），删除行，中间跳转到下一行，注释与反注释（支持多行）。


source insight 宏定义文件v2.3
source insight自定义宏，支持上移行，下移行，复制行（支持多行），删除行，中间跳转到下一行，注释与反注释（支持多行）。
支持多行复制。

source insight 宏定义文件v2.4
source insight自定义宏，添加常用宏定义说明，整合到一个文件中
头文件增加说明

source insight 宏定义文件v2.5
取消注释对首字符为空的进行处理
增加多行空行
增加星号注释


source insight 宏定义文件v2.6
添加选择行打印printf变量



常用规则           快捷键定义
MultiLineComment   Ctrl + / 多行注释
UnMultiLineComment Ctrl + Q  反多行注释
duplicateselect    Ctrl + D 拷贝一份内容到当前选中内容后面
deleteline         Ctrl + L 删除当前行
enternewline       Ctrl + Enter 换一新行
InsertFileHeader               插入文件头
InsertFunHeader                插入函数头
printvar()           Ctrl+6    打印变量
addmultiline()       Ctrl+7    插入多行空行
addxinghaocomment()  Ctrl+8    插入多行*号注释


*/

/**
source insight常用接口
#获取lnfirst行的内容
GetBufLine(hbuf,lnfirst)
#获取text,[0,chfirst)的内容
strmid(curlntext, 0, chfirst)
#打印str
msg(str)
#后缀middle到header后面
cat(header, middle)
#删除ln行内容
DelBufLine(hbuf, ln)
#插入ln行内容为showtext
InsBufLine(hbuf,ln, showtext)
#获取选中的内容
GetBufSelText(hbuf)
#获取当前窗口句柄
GetCurrentWnd()
#获取当前编辑内容句柄
GetCurrentBuf()
#获取选中内容的首行
GetWndSelLnFirst(hwnd)
#获取选中内容的末行
GetWndSelLnLast(hwnd)
#获取选中字符首位置
GetWndSelIchFirst(hwnd)
#获取选中字符末位置？
GetWndSelIchLim(hwnd)
#设置选中内容为替换字符
SetBufSelText(hbuf, replacetext)
#替换ln行的hbuf中的数据使用字符进行替换
PutBufLine (hbuf, ln, s)
Replaces the line of text for line number ln in the file buffer hbuf with the string in s.
#提示输入框 Ask (prompt_string)
Prompts the user with a message box window displaying the string prompt_string. The Ask message box has an OK button, and a Cancel button. Clicking the Cancel button stops the macro.
##CharFromAscii (ascii_code)
Returns a string containing a single character that corresponds to the ASCII code in ascii_code.
#保存缓存到磁盘 SaveBuf (hbuf)
Saves a file buffer to disk. Hbuf is the buffer handle.




**/

/* InsertFileHeader:

   Inserts a comment header block at the top of the current function.
   This actually works on any type of symbol, not just functions.

   To use this, define an environment variable "MYNAME" and set it
   to your email name.  eg. set MYNAME=raygr
*/

macro InsertFileHeader()
{
    szMyName = getenv(MyName)

    hbuf = GetCurrentBuf()

    InsBufLine(hbuf, 0, "/***************************************************************************")
    InsBufLine(hbuf, 1, "** 版权所有:  WeiLai Copyright (c) 2010-2015  ******************************")
    fPath = GetBufName(hbuf)
	if (fPath != hNil)
	{
		fLen = strlen(fPath)

		len = fLen
		while(StrMid(fPath, len - 1, len) != "\\")
		{
		    len = len - 1
		}
		fileName = StrMid(fPath, len, fLen)
	}

    InsBufLine(hbuf, 2, "** 文件名称:  @fileName@  [@fPath@]")
    InsBufLine(hbuf, 3, "** 当前版本:  v1.0")

    /* if owner variable exists, insert Owner: name */
    if (strlen(szMyName) > 0)
    {
        sz = "** 作    者:  @szMyName@"
    }
    else
    {
        sz = "** 作    者: "
    }

    InsBufLine(hbuf, 4, sz)

    // Get current time
    szTime  = GetSysTime(1)
    Day      = szTime.Day
    Month   = szTime.Month
    Year     = szTime.Year
    if (Day < 10)
        szDay = "0@Day@"
    else
        szDay = Day    

	fileLen = strlen(fileName)
	UpFileName = toupper (strtrunc (fileName, fileLen - 2))
	headFileFlag = 0
//	msg(fileLen)
//	msg(fileName)
//	msg(fileName[fileLen-1])
//	msg(fileName[fileLen-2])
//	msg(fileLen > 2)
//	msg(fileName[fileLen-1] == "h")
//	msg(fileName[fileLen-2] == ".")
	if(fileLen > 2 && fileName[fileLen-1] == "h" && fileName[fileLen-2] == "." )
	{
		headFileFlag = 1
	}
	else
	{

	}
//	msg(headFileFlag)
	
    InsBufLine(hbuf, 5,  "** 完成日期: @Year@年@Month@月@szDay@日")
    InsBufLine(hbuf, 6,  "** 修改记录: ")
    InsBufLine(hbuf, 7,  "** 修改记录: ")
    InsBufLine(hbuf, 8,  "** 修改日期: ")
    InsBufLine(hbuf, 9,  "** 版本号  : ")
    InsBufLine(hbuf, 10, "** 修改人  : ")
    InsBufLine(hbuf, 11, "** 修改内容: ")
    if(headFileFlag > 0)
    {
    	InsBufLine(hbuf, 12, "***************************************************************************/")
		InsBufLine(hbuf, 13, "#ifndef __@UpFileName@_H__")
		InsBufLine(hbuf, 14, "#define __@UpFileName@_H__")
    }
    else
    {
        InsBufLine(hbuf, 12, "***************************************************************************/")
	    InsBufLine(hbuf, 13, "")  
	    InsBufLine(hbuf, 14, "")	    
    }

    InsBufLine(hbuf, 15, "/*****************************头文件****************************************/")
    InsBufLine(hbuf, 16, "")
    InsBufLine(hbuf, 17, "/*****************************宏定义****************************************/")
    InsBufLine(hbuf, 18, "")
    InsBufLine(hbuf, 19, "/*****************************结构体或类型定义*******************************/")
    InsBufLine(hbuf, 20, "")
    InsBufLine(hbuf, 21, "")    
    InsBufLine(hbuf, 22, "/*****************************全局变量****************************************/")
    InsBufLine(hbuf, 23, "")
    InsBufLine(hbuf, 24, "")    
    InsBufLine(hbuf, 25, "/*****************************本地变量****************************************/")
    InsBufLine(hbuf, 26, "")
    InsBufLine(hbuf, 27, "")    
    InsBufLine(hbuf, 28, "/*****************************函数或类声明****************************************/")
    InsBufLine(hbuf, 29, "")
    InsBufLine(hbuf, 30, "")
	InsBufLine(hbuf, 31, "/*****************************函数或类实现****************************************/")    
    InsBufLine(hbuf, 32, "")
    InsBufLine(hbuf, 33, "")
    InsBufLine(hbuf, 34, "")
    InsBufLine(hbuf, 35, "")
    InsBufLine(hbuf, 36, "")
    InsBufLine(hbuf, 37, "")
    InsBufLine(hbuf, 38, "")
    InsBufLine(hbuf, 39, "")
    InsBufLine(hbuf, 40, "/*****************************by extern \"C\"****************************************/")
    InsBufLine(hbuf, 41, "/*****************************头文件****************************************/")
    InsBufLine(hbuf, 42, "")
    InsBufLine(hbuf, 43, "")
    InsBufLine(hbuf, 44, "/*****************************宏定义****************************************/")
    InsBufLine(hbuf, 45, "")
    InsBufLine(hbuf, 46, "")
	InsBufLine(hbuf, 47, "#ifdef __cplusplus") 
	InsBufLine(hbuf, 48, "extern \"C\" {")
	InsBufLine(hbuf, 49, "#endif")
	InsBufLine(hbuf, 50, "")	
    InsBufLine(hbuf, 51, "/*****************************结构体或类型定义*******************************/")
    InsBufLine(hbuf, 52, "")
    InsBufLine(hbuf, 53, "")    
    InsBufLine(hbuf, 54, "/*****************************全局变量****************************************/")
    InsBufLine(hbuf, 55, "")
    InsBufLine(hbuf, 56, "")    
    InsBufLine(hbuf, 57, "/*****************************本地变量****************************************/")
    InsBufLine(hbuf, 58, "")
    InsBufLine(hbuf, 59, "")    
    InsBufLine(hbuf, 60, "/*****************************函数或类声明****************************************/")
    InsBufLine(hbuf, 61, "")
    InsBufLine(hbuf, 62, "")
	InsBufLine(hbuf, 63, "/*****************************函数或类实现****************************************/")    
    InsBufLine(hbuf, 64, "")
	InsBufLine(hbuf, 65, "")
	InsBufLine(hbuf, 66, "#ifdef __cplusplus") 
	InsBufLine(hbuf, 67, "}")
	InsBufLine(hbuf, 68, "#endif")
	InsBufLine(hbuf, 69, "")
	InsBufLine(hbuf, 70, "")
	InsBufLine(hbuf, 71, "")
	InsBufLine(hbuf, 72, "")
	InsBufLine(hbuf, 73, "")

    if(headFileFlag > 0)
    {
		InsBufLine(hbuf, 74, "#endif /* @fileName@ */")
		InsBufLine(hbuf, 75, "")		
    }
}




// Inserts "Returns True .. or False..." at the current line
macro ReturnTrueOrFalse()
{
	hbuf = GetCurrentBuf()
	szFunc = GetCurSymbol()
	ln = GetSymbolLine(szFunc)

	InsBufLine(hbuf, ln, "/*    Returns True if successful or False if errors. */")
}



/* Inserts ifdef REVIEW around the selection */
macro IfdefReview()
{
	IfdefSz("REVIEW");
}


/* Inserts ifdef BOGUS around the selection */
macro IfdefBogus()
{
	IfdefSz("BOGUS");
}


/* Inserts ifdef NEVER around the selection */
macro IfdefNever()
{
	IfdefSz("NEVER");
}


// Ask user for ifdef condition and wrap it around current
// selection.
macro InsertIfdef()
{
	sz = Ask("Enter ifdef condition:")
	if (sz != "")
		IfdefSz(sz);
}

macro InsertCPlusPlus()
{
	IfdefSz("__cplusplus");
}


// Wrap ifdef <sz> .. endif around the current selection
macro IfdefSz(sz)
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)

	hbuf = GetCurrentBuf()
	InsBufLine(hbuf, lnFirst, "#ifdef @sz@")
	InsBufLine(hbuf, lnLast+2, "#endif /* @sz@ */")
}


// Delete the current line and appends it to the clipboard buffer
macro KillLine()
{
	hbufCur = GetCurrentBuf();
	lnCur = GetBufLnCur(hbufCur)
	hbufClip = GetBufHandle("Clipboard")
	AppendBufLine(hbufClip, GetBufLine(hbufCur, lnCur))
	DelBufLine(hbufCur, lnCur)
}


// Paste lines killed with KillLine (clipboard is emptied)
macro PasteKillLine()
{
	Paste
	EmptyBuf(GetBufHandle("Clipboard"))
}



// delete all lines in the buffer
macro EmptyBuf(hbuf)
{
	lnMax = GetBufLineCount(hbuf)
	while (lnMax > 0)
		{
		DelBufLine(hbuf, 0)
		lnMax = lnMax - 1
		}
}


// Ask the user for a symbol name, then jump to its declaration
macro JumpAnywhere()
{
	symbol = Ask("What declaration would you like to see?")
	JumpToSymbolDef(symbol)
}






// list all siblings of a user specified symbol
// A sibling is any other symbol declared in the same file.
macro OutputSiblingSymbols()
{
	symbol = Ask("What symbol would you like to list siblings for?")
	hbuf = ListAllSiblings(symbol)
	SetCurrentBuf(hbuf)
}


// Given a symbol name, open the file its declared in and
// create a new output buffer listing all of the symbols declared
// in that file.  Returns the new buffer handle.
macro ListAllSiblings(symbol)
{
	loc = GetSymbolLocation(symbol)
	if (loc == "")
		{
		msg ("@symbol@ not found.")
		stop
		}

	hbufOutput = NewBuf("Results")

	hbuf = OpenBuf(loc.file)
	if (hbuf == 0)
		{
		msg ("Can't open file.")
		stop
		}

	isymMax = GetBufSymCount(hbuf)
	isym = 0;
	while (isym < isymMax)
		{
		AppendBufLine(hbufOutput, GetBufSymName(hbuf, isym))
		isym = isym + 1
		}

	CloseBuf(hbuf)

	return hbufOutput

}



//拷贝一份内容到当前选中内容后面
macro duplicateselect()
{
    hwnd = GetCurrentWnd();
    hbuf = GetCurrentBuf();

    if (hbuf == 0)
        stop;   // empty buffer

    // get current cursor postion
    ipos = GetWndSelIchFirst(hwnd);

    // get current line number
    ln = GetBufLnCur(hbuf);
	lnfirst = GetWndSelLnFirst(hwnd)
	lnlast  = GetWndSelLnLast(hwnd)

    if ((GetBufSelText(hbuf) != "") && (lnfirst != lnlast)) {

		chfirst = GetWndSelIchFirst(hwnd)
		chlast  = GetWndSelIchLim(hwnd)
//		msg("chfirst:@chfirst@")
//		msg("chlast :@chlast@")
		curlntext = GetBufLine(hbuf,lnfirst)
		lastlntext = GetBufLine(hbuf, lnlast)
		/*
		** 替换思路:
		** 选中之前的是header(未选中的)
		** 第一行选中的是selcheader
		** 后面选中的是middle
		** 最后一行未选中的是tail
		** 最后一行选中的是seltail
		**/
		header = ""
		selheader = ""
		middle = ""
		tail = ""
		seltail = ""

		if(0 != chfirst)
			header = strmid(curlntext, 0, chfirst)
		if(chfirst != GetBufLineLength(hbuf,lnfirst))
			selheader = strmid(curlntext, chfirst, GetBufLineLength(hbuf,lnfirst))

		if(0 != chlast && chlast != 4096)
			seltail = strmid(lastlntext, 0, chlast)

		lastlnpos = GetBufLineLength(hbuf,lnlast)
//		msg("chlast   :@chlast@")
//		msg("lastlnpos:@lastlnpos@")
		if(chlast != GetBufLineLength(hbuf,lnlast) && chlast != 4096)
			tail = strmid(lastlntext, chlast, lastlnpos)

//		msg(header)
//		msg(selheader)
//		msg(tail)
		showtext = ""

		lnstart = lnfirst
		lntmp = lnlast
		while(lntmp <= (lnlast + lnlast - lnfirst)
		{
			if(lntmp == lnlast)
			{
				showtext = GetBufLine(hbuf, lnstart)
				DelBufLine(hbuf, lntmp)
				InsBufLine(hbuf,lntmp, cat(seltail,selheader))
			}
			else if(lntmp == lnlast + lnlast - lnfirst)
			{
				showtext = GetBufLine(hbuf, lnstart)
				DelBufLine(hbuf, lntmp)
				InsBufLine(hbuf,lntmp, cat(seltail,tail))
			}
			else
			{
				showtext = GetBufLine(hbuf, lnstart)
				InsBufLine(hbuf,lntmp, showtext)
			}
			lntmp = lntmp + 1
			lnstart = lnstart + 1
		}
        stop;
    }


    if ((GetBufSelText(hbuf) != "") && (lnfirst == lnlast)) {
		chfirst = GetWndSelIchFirst(hwnd)
		chlast  = GetWndSelIchLim(hwnd)
		curlntext = GetBufLine(hbuf,lnfirst)
		header = ""
		middle = ""
		tail = ""

		if(0 != chfirst)
			header = strmid(curlntext, 0, chfirst)

		if(chfirst != chlast)
			middle = strmid(curlntext, chfirst, chlast )
		if(chlast != GetBufLineLength(hbuf,lnfirst))
			tail = strmid(curlntext, chlast, GetBufLineLength(hbuf,lnfirst))
		showtext = cat(header, middle);
		showtext = cat (showtext, middle)
		showtext = cat (showtext, tail)
		DelBufLine(hbuf, ln)
		InsBufLine(hbuf,ln, showtext)
        stop;
    }
    InsBufLine(hbuf,ln + 1, GetBufLine(hbuf,ln))
	stop;
}

//拷贝一份内容到当前选中内容后面
macro duplicateselect2()
{
	hbufCur = GetCurrentBuf()
	lnCur = GetBufLnCur(hbufCur)
	selecttext = GetBufSelText (hbufCur)
	sellen = strlen(selecttext)
	if (sellen != 0)
	{
//		msg(selecttext)
	}

    hwnd = GetCurrentWnd()
    selection = GetWndSel(hwnd)
    LnFirst =GetWndSelLnFirst(hwnd)      //取首行行号
    LnLast =GetWndSelLnLast(hwnd)      //取末行行号
    hbuf = GetCurrentBuf()
	isym = 0;
	sellen = strlen(selection)


	// get current cursor postion
    IchFirst = GetWndSelIchFirst (hwnd)
//    GetBufLine(hbufCur, IchLast)
    IchLast = 0;
    if(LnFirst != LnLast)
    	IchLast = GetWndSelIchLim (hwnd)
    else
    	IchLast = GetWndSelIchLim (hwnd)

	if (LnLast != LnFirst || IchFirst != IchLast)
	{
//		msg(selection)
	    msg ("IchFirst:@IchFirst@ .")
    	msg ("IchLast :@IchLast@ .")
	}


	if(sellen > 0
)
	{
		loops = LnLast - LnFirst
		while (isym <= loops)
		{
//				AppendBufLine(hbufOutput, GetBufSymName(hbuf, isym))
		InsBufLine(hbufCur,LnLast + isym + 1, GetBufLine(hbufCur,LnFirst + isym))
		isym = isym + 1
		}
	}
	else
	{
		InsBufLine(hbufCur,lnCur + 1, GetBufLine(hbufCur,lnCur))
	}
}

//插入当前选择的内容，在上一行。
macro getselecttext()
{
	hbufCur = GetCurrentBuf();
	lnCur = GetBufLnCur(hbufCur)
	selecttext = GetBufSelText (hbufCur)
	sz = cat("    printk(\"", selecttext)
	sz = cat(sz, "\\n\");");

	InsBufLine(hbufCur, lnCur, sz)
}
//复制当前行，如果有选中的数据，则复制选中数据
macro duplicateline()
{
	hbufCur = GetCurrentBuf()
	lnCur = GetBufLnCur(hbufCur)
	selecttext = GetBufSelText (hbufCur)
	sellen = strlen(selecttext)
//	if (hbuf == 0)
//		stop; // empty buffer

    hwnd = GetCurrentWnd()
    selection = GetWndSel(hwnd)
    LnFirst =GetWndSelLnFirst(hwnd)      //取首行行号
    LnLast =GetWndSelLnLast(hwnd)      //取末行行号
    hbuf = GetCurrentBuf()
	isym = 0;

	// get current cursor postion
    IchFirst = GetWndSelIchFirst (hwnd)
    IchLast = GetWndSelIchLim (hwnd)
    //msg ("@IchFirst@ IchFirst.")
    //msg ("@IchLast@ IchLast .")


	if(sellen > 0
)
	{
		loops = LnLast - LnFirst
		while (isym <= loops)
		{
//				AppendBufLine(hbufOutput, GetBufSymName(hbuf, isym))
		InsBufLine(hbufCur,LnLast + isym + 1, GetBufLine(hbufCur,LnFirst + isym))
		isym = isym + 1
		}
	}
	else
	{
		InsBufLine(hbufCur,lnCur + 1, GetBufLine(hbufCur,lnCur))
	}
}

macro deleteline()
{
	hbufCur = GetCurrentBuf()
	lnCur = GetBufLnCur(hbufCur)
	DelBufLine(hbufCur, lnCur)
}

macro enternewline()
{
	hbufCur = GetCurrentBuf()
	lnCur = GetBufLnCur(hbufCur)
	InsBufLine(hbufCur, lnCur + 1, "")
	SetBufIns(hbufCur, lnCur + 1, 0)
}

macro moveup()
{
	hbufCur = GetCurrentBuf()
	lnCur = GetBufLnCur(hbufCur)
	if(lnCur > 0)
	{
		lnBfBuf = GetBufLine(hbufCur, lnCur -1)
		lnCurBuf = GetBufLine(hbufCur, lnCur)
		DelBufLine(hbufCur, lnCur - 1)
		InsBufLine(hbufCur, lnCur - 1, lnCurBuf)

		DelBufLine(hbufCur, lnCur)
		InsBufLine(hbufCur, lnCur, lnBfBuf)
	}
}

macro movedown()
{
	hbufCur = GetCurrentBuf()
	lnCur = GetBufLnCur(hbufCur)
	lnMax = GetBufLineCount(hbufCur)
	if(lnCur + 1 < lnMax)
	{
		lnAfBuf = GetBufLine(hbufCur, lnCur + 1)
		lnCurBuf = GetBufLine(hbufCur, lnCur)
		PutBufLine(hbufCur, lnCur, lnAfBuf)
		PutBufLine(hbufCur, lnCur + 1, lnCurBuf)
		SetBufIns(hbufCur, lnCur + 1, 0)
	}
}

//增加注释或反注释,并下移一行
macro commentlinedown()
{
	hbufCur = GetCurrentBuf()
	lnCur = GetBufLnCur(hbufCur)
	lnMax = GetBufLineCount(hbufCur)

	if(lnCur + 1 < lnMax)
	{
		lnCurBuf = GetBufLine(hbufCur, lnCur)
		len = strlen(lnCurBuf)
		if(len < 2)
		{
			PutBufLine(hbufCur,lnCur, Cat("//", lnCurBuf))
		}
		else
		{
			if(lnCurBuf[0] == "/" && lnCurBuf[1] == "/")
			{
				PutBufLine(hbufCur,lnCur, strmid(lnCurBuf,2,len))
			}
			else
			{
				PutBufLine(hbufCur,lnCur, Cat("//", lnCurBuf))
			}

		}
		SetBufIns(hbufCur, lnCur + 1, 0)
	}
}

//增加注释或反注释,并上移一行
macro commentlineup()
{
	hbufCur = GetCurrentBuf()
	lnCur = GetBufLnCur(hbufCur)
	lnMax = GetBufLineCount(hbufCur)

	if(lnCur - 1 > 0)
	{
		lnCurBuf = GetBufLine(hbufCur, lnCur)
		len = strlen(lnCurBuf)
		if(len < 2)
		{
			PutBufLine(hbufCur,lnCur, Cat("//", lnCurBuf))
		}
		else
		{
			if(lnCurBuf[0] == "/" && lnCurBuf[1] == "/")
			{
				PutBufLine(hbufCur,lnCur, strmid(lnCurBuf,2,len))
			}
			else
			{
				PutBufLine(hbufCur,lnCur, Cat("//", lnCurBuf))
			}

		}
		SetBufIns(hbufCur, lnCur - 1, 0)
	}
}
/**
** Ctrl + /
**/
macro MultiLineComment()

{
    hwnd = GetCurrentWnd()
    selection = GetWndSel(hwnd)
    LnFirst =GetWndSelLnFirst(hwnd)      //取首行行号
    LnLast =GetWndSelLnLast(hwnd)      //取末行行号
    hbuf = GetCurrentBuf()

    IchFirst = GetWndSelIchFirst (hwnd)
    IchLast = GetWndSelIchLim (hwnd)
    //msg ("@IchFirst@ IchFirst.")
    //msg ("@IchLast@ IchLast .")


    if(GetBufLine(hbuf, 0) ==""){
        stop
    }

    Ln = Lnfirst
    buf = GetBufLine(hbuf, Ln)
    len = strlen(buf)

    while(Ln <= Lnlast) {
        buf = GetBufLine(hbuf, Ln)  //取Ln对应的行
        if(buf ==""){                   //跳过空行
            Ln = Ln + 1
            continue
        }

        if(StrMid(buf, 0, 1) == "/"){       //需要取消注释,防止只有单字符的行
            if(StrMid(buf, 1, 2) == "/"){
//                PutBufLine(hbuf, Ln, StrMid(buf, 2, Strlen(buf)))
//                PutBufLine(hbuf, Ln, Cat("//", buf))
            }
            PutBufLine(hbuf, Ln, Cat("//", buf))
        }

        if(StrMid(buf,0,1) !="/"){          //需要添加注释
            PutBufLine(hbuf, Ln, Cat("//", buf))
        }
        Ln = Ln + 1
    }
    SetWndSel(hwnd, selection)

}
/**
Ctrl + Q
**/
macro UnMultiLineComment()

{
    hwnd = GetCurrentWnd()
    selection = GetWndSel(hwnd)
    LnFirst =GetWndSelLnFirst(hwnd)      //取首行行号
    LnLast =GetWndSelLnLast(hwnd)      //取末行行号
    hbuf = GetCurrentBuf()

    IchFirst = GetWndSelIchFirst (hwnd)
    IchLast = GetWndSelIchLim (hwnd)
    //msg ("@IchFirst@ IchFirst.")
    //msg ("@IchLast@ IchLast .")


    if(GetBufLine(hbuf, 0) ==""){
        stop
    }

    Ln = Lnfirst
    buf = GetBufLine(hbuf, Ln)
    len = strlen(buf)

    while(Ln <= Lnlast) {
        buf = GetBufLine(hbuf, Ln)  //取Ln对应的行
        if(buf ==""){                   //跳过空行
            Ln = Ln + 1
            continue
        }
        Cn=0
        while(Cn <= len)
        {
			if(StrMid(buf,Cn,Cn+1) == " ")
			{
				Cn = Cn +1
			}
			else
			{
				break
			}
        }
        

        if(StrMid(buf, Cn+0, Cn+1) == "/"){       //需要取消注释,防止只有单字符的行
            if(StrMid(buf, Cn+1, Cn+2) == "/"){
            	rs = StrMid(buf, Cn+2, Strlen(buf))
            	rs = cat(StrMid(buf, 0, Cn), rs)
                PutBufLine(hbuf, Ln, rs)
//                PutBufLine(hbuf, Ln, Cat("//", buf))
            }
//            PutBufLine(hbuf, Ln, Cat("//", buf))
        }

        if(StrMid(buf,0,1) !="/"){          //需要添加注释
//            PutBufLine(hbuf, Ln, Cat("//", buf))
        }
        Ln = Ln + 1
    }
    SetWndSel(hwnd, selection)

}


/******************************************************************************
* AutoExpand - Automatically expands C statements
*
* DESCRIPTION: - Automatically expands C statements like if, for, while,
* switch, etc..
*
* Input:
* Output:
* Returns:
*
* modification history
* --------------------
* 01a, 27mar2003, t357 modified
* --------------------
******************************************************************************/
macro AutoExpand()
{
	// get window, sel, and buffer handles
	hwnd = GetCurrentWnd()
	if (hwnd == 0)
	stop
	sel = GetWndSel(hwnd)
	if (sel.ichFirst == 0)
	stop
	hbuf = GetWndBuf(hwnd)

	// get line the selection (insertion point) is on
	szLine = GetBufLine(hbuf, sel.lnFirst);

	// parse word just to the left of the insertion point
	wordinfo = GetWordLeftOfIch(sel.ichFirst, szLine)
	ln = sel.lnFirst;

	chTab = CharFromAscii(9)

	// prepare a new indented blank line to be inserted.
	// keep white space on left and add a tab to indent.
	// this preserves the indentation level.
	ich = 0
	while (szLine[ich] == ' ' || szLine[ich] == chTab)
	{
	ich = ich + 1
	}

	szLine = strmid(szLine, 0, ich)
	sel.lnFirst = sel.lnLast
	sel.ichFirst = wordinfo.ich
	sel.ichLim = wordinfo.ich

	// expand szWord keyword...


	if (wordinfo.szWord == "if" ||
	wordinfo.szWord == "while" ||
	wordinfo.szWord == "elseif")
	{
		SetBufSelText(hbuf, " (###)")
		InsBufLine(hbuf, ln + 1, "@szLine@" # "{");
		InsBufLine(hbuf, ln + 2, "@szLine@" # chTab);
		InsBufLine(hbuf, ln + 3, "@szLine@" # "}");
	}
	else if (wordinfo.szWord == "for")
	{
		SetBufSelText(hbuf, " (###)")
		InsBufLine(hbuf, ln + 1, "@szLine@" # "{");
		InsBufLine(hbuf, ln + 2, "@szLine@" # chTab);
		InsBufLine(hbuf, ln + 3, "@szLine@" # "}");
	}
	else if (wordinfo.szWord == "switch")
	{
		SetBufSelText(hbuf, " (###)")
		InsBufLine(hbuf, ln + 1, "@szLine@" # "{")
		InsBufLine(hbuf, ln + 2, "@szLine@" # "case ")
		InsBufLine(hbuf, ln + 3, "@szLine@" # chTab)
		InsBufLine(hbuf, ln + 4, "@szLine@" # chTab # "break;")
		InsBufLine(hbuf, ln + 5, "@szLine@" # "default:")
		InsBufLine(hbuf, ln + 6, "@szLine@" # chTab)
		InsBufLine(hbuf, ln + 7, "@szLine@" # "}")
	}
	else if (wordinfo.szWord == "do")
	{
		InsBufLine(hbuf, ln + 1, "@szLine@" # "{")
		InsBufLine(hbuf, ln + 2, "@szLine@" # chTab);
		InsBufLine(hbuf, ln + 3, "@szLine@" # "} while ();")
	}
	else if (wordinfo.szWord == "case")
	{
		SetBufSelText(hbuf, " ###")
		InsBufLine(hbuf, ln + 1, "@szLine@" # chTab)
		InsBufLine(hbuf, ln + 2, "@szLine@" # chTab # "break;")
	}
	else
	stop

		SetWndSel(hwnd, sel)
		LoadSearchPattern("###", true, false, false);
		Search_Forward
}


/* G E T W O R D L E F T O F I C H */
/*-------------------------------------------------------------------------
 Given an index to a character (ich) and a string (sz),
 return a "wordinfo" record variable that describes the
 text word just to the left of the ich.

 Output:
 wordinfo.szWord = the word string
 wordinfo.ich = the first ich of the word
 wordinfo.ichLim = the limit ich of the word
-------------------------------------------------------------------------*/
macro GetWordLeftOfIch(ich, sz)
{
wordinfo = "" // create a "wordinfo" structure

chTab = CharFromAscii(9)

// scan backwords over white space, if any
ich = ich - 1;
if (ich >= 0)
while (sz[ich] == " " || sz[ich] == chTab)
{
ich = ich - 1;
if (ich < 0)
break;
}

// scan backwords to start of word
ichLim = ich + 1;
asciiA = AsciiFromChar("A")
asciiZ = AsciiFromChar("Z")
while (ich >= 0)
{
ch = toupper(sz[ich])
asciiCh = AsciiFromChar(ch)
if ((asciiCh < asciiA || asciiCh > asciiZ) && !IsNumber(ch))
break // stop at first non-identifier character
ich = ich - 1;
}

ich = ich + 1
wordinfo.szWord = strmid(sz, ich, ichLim)
wordinfo.ich = ich
wordinfo.ichLim = ichLim;

return wordinfo
}



/******************************************************************************
 * InsFunHeader -- insert function's information
 *
 * modification history
 * --------------------
 * 01a, 23mar2003, added DESCRIPTION by t357
 * 01a, 05mar2003, t357 written
 * --------------------
 ******************************************************************************/
macro InsertFunHeader()
{
	// Get the owner's name from the environment variable: szMyName.
	// If the variable doesn't exist, then the owner field is skipped.
	/*#########################################################
#########################################################
#######  Set szMyName variable to your name    ########
#######  for example    szMyName = "t357"     ########
#########################################################   
#########################################################*/
	szMyName = "" //empty
	// Get a handle to the current file buffer and the name
	// and location of the current symbol where the cursor is.
	hbuf = GetCurrentBuf() //get file buffer
	szFunc = GetCurSymbol() //get the curren symbol where the cursor is.
	ln = GetSymbolLine(szFunc)
	// Get current time
	szTime = GetSysTime(1)
	Day = szTime.Day
	Month = szTime.Month
	Year = szTime.Year
	if (Day < 10)
	szDay = "0@Day@"
	else
	szDay = Day
	szMonth = (Month)
	szInf = Ask("Enter the information of function:")
	szDescription = Ask("Enter the description of function:")
	// begin assembling the title string
	sz = "/******************************************************************************"
	InsBufLine(hbuf, ln, sz)
	InsBufLine(hbuf, ln + 1, " * @szFunc@ - @szInf@")
	InsBufLine(hbuf, ln + 2, " * DESCRIPTION: - ")
	InsBufLine(hbuf, ln + 3, " *    @szDescription@ ")
	// remove by t357.    CutWord(szDescription)
	InsBufLine(hbuf, ln + 4, " * 输入参数: ")
	InsBufLine(hbuf, ln + 5, " * 输出参数: ")
	InsBufLine(hbuf, ln + 6, " * 返回结果: 0-成功,其它-失败")
	InsBufLine(hbuf, ln + 7, " * ")
	InsBufLine(hbuf, ln + 8, " * modification history")
	InsBufLine(hbuf, ln + 9, " * --------------------")
	InsBufLine(hbuf, ln + 10, " * 01a, @szDay@@szMonth@@Year@, @szMyName@ written")
	InsBufLine(hbuf, ln + 11, " * --------------------")
	InsBufLine(hbuf, ln + 12, " ******************************************************************************/")
	// put the insertion point inside the header comment
	SetBufIns(hbuf, ln + 1, strlen(szFunc) + strlen(szInf) + 8)
}


macro AskSysmbol()
{
	symbolname = Ask("What symbol do you want to locate?")
	symbol = GetSymbolLocation(symbolname)
	if (symbol == nil)
	    Msg (symbolname # " was not found")
	else
	    {
	    hsyml = SymbolChildren(symbol)
	    cchild = SymListCount(hsyml)
	    ichild = 0
	    while (ichild < cchild)
	        {
	        childsym = SymListItem(hsyml, ichild)
	        Msg (childsym.symbol # " was found in " 
	            # childsym.file # " at line " # 
	childsym.lnFirst)
	        ichild = ichild + 1
	        }
	    SymListFree(hsyml)
	    }


}
//插入多行空行
macro addmultiline()
{
    hwnd = GetCurrentWnd()
    selection = GetWndSel(hwnd)
    LnFirst =GetWndSelLnFirst(hwnd)      //取首行行号
    LnLast =GetWndSelLnLast(hwnd)      //取末行行号
    hbuf = GetCurrentBuf()

    IchFirst = GetWndSelIchFirst (hwnd)
    IchLast = GetWndSelIchLim (hwnd)
    //msg ("@IchFirst@ IchFirst.")
    //msg ("@IchLast@ IchLast .")

    Ln = Lnfirst
    buf = GetBufLine(hbuf, Ln)
    len = strlen(buf)
    
	nums = Ask("prepare add multi lines, Input Add Line Num:")
	if (nums != "")
	{
		
	}
    while(Ln <= Lnfirst + nums) {
    	showtext=""
        InsBufLine(hbuf,Ln, showtext)
        Ln = Ln + 1
    }
	SaveBuf(hbuf)
	
//    Save_Tabs_To_Spaces()
    
}


//插入多行*号注释
macro addxinghaocomment()
{
    hwnd = GetCurrentWnd()
    selection = GetWndSel(hwnd)
    LnFirst =GetWndSelLnFirst(hwnd)      //取首行行号
    LnLast =GetWndSelLnLast(hwnd)      //取末行行号
    hbuf = GetCurrentBuf()

    IchFirst = GetWndSelIchFirst (hwnd)
    IchLast = GetWndSelIchLim (hwnd)
    //msg ("@IchFirst@ IchFirst.")
    //msg ("@IchLast@ IchLast .")

    Ln = Lnfirst
    buf = GetBufLine(hbuf, Ln)
    len = strlen(buf)
    
	nums = Ask("prepare add xinghao comment, Input Add Line Num:")
	if (nums == "")
	{
		return
	}
	showtextFirst="/**"
	showtextMiddle="** "
	showtextLast="**/"

	InsBufLine(hbuf,Ln, showtextFirst)
	Ln = Ln + 1
    while(Ln <= Lnfirst + nums - 2) {
    	
        InsBufLine(hbuf,Ln, showtextMiddle)
        Ln = Ln + 1
    }
    InsBufLine(hbuf,Ln, showtextLast)
	SaveBuf(hbuf)
	 
}

//打印变量
macro printvar()
{
    hwnd = GetCurrentWnd()
    selection = GetWndSel(hwnd)
    LnFirst =GetWndSelLnFirst(hwnd)      //取首行行号
    LnLast =GetWndSelLnLast(hwnd)      //取末行行号
    hbuf = GetCurrentBuf()

    IchFirst = GetWndSelIchFirst (hwnd)
    IchLast = GetWndSelIchLim (hwnd)
    //msg ("@IchFirst@ IchFirst.")
    //msg ("@IchLast@ IchLast .")


   // if(GetBufLine(hbuf, 0) ==""){
   //     stop
   // }

    Ln = Lnfirst
    buf = GetBufLine(hbuf, Ln)
    len = strlen(buf)

    pstr = "    printf(\""
    midstr = " : %u\\n\", "
    rightsign = ");"
    result = ""

	
    newWrFirstLn = Lnlast + 1
    newWrLastLn  = newWrFirstLn + Lnlast - Lnfirst
    newWrLn = newWrFirstLn
	count=0
	
    while(Ln <= Lnlast) {
        buf = GetBufLine(hbuf, Ln)  //取Ln对应的行
        if(buf ==""){                   //跳过空行
            Ln = Ln + 1
            continue
        }

        len = strlen(buf)
//		msg(cat("length is:",len))
		tn = len
		
		lastvarstartpos = 0
		lastvarendpos = 0
		varname=""
		typename=""
		while(tn > 0)
		{
			chr = strmid(buf, tn-1, tn)
//			if(("(" == chr) 
//			||(")" == chr))
//			{
//				break
//			}

			if(";" == chr && len > 1)
			{
				lastvarendpos = tn - 1
//				msg(cat("lastvar pos end:",lastvarendpos))
			}
			else if((" " == chr)&&(tn < lastvarendpos))
			{
				lastvarstartpos = tn
//				msg(cat("lastvar pos start:",lastvarstartpos))
				break
			}
			
			tn = tn-1
		}

		if(lastvarendpos - lastvarstartpos > 1)
		{
			lastword=(strmid(buf, lastvarstartpos, lastvarendpos))
			result = cat(pstr,lastword)
			result = cat(result,midstr)
			result = cat(result,lastword)
			result = cat(result,rightsign)
			
//			msg(result)
			InsBufLine(hbuf,newWrLn, result)
			count = count + 1
		}
		
        Ln = Ln + 1
        newWrLn = newWrLn + 1
    }

	if(count == 0)
	{
		msg("【生成printf打印变量】请选择带变量的行!!!")
	}

	SaveBuf(hbuf)
}



