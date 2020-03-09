/* Utils.em - a small collection of useful editing macros */
/*

source insight 宏定义文件v2.1
source insight自定义宏，支持上移行，下移行，复制行，删除行，中间跳转到下一行，注释与反注释（支持多行）


source insight 宏定义文件v2.2
source insight自定义宏，支持上移行，下移行，复制行（支持多行），删除行，中间跳转到下一行，注释与反注释（支持多行）。


source insight 宏定义文件v2.3
source insight自定义宏，支持上移行，下移行，复制行（支持多行），删除行，中间跳转到下一行，注释与反注释（支持多行）。
支持多行复制。

*/


/*-------------------------------------------------------------------------
	I N S E R T   H E A D E R

	Inserts a comment header block at the top of the current function.
	This actually works on any type of symbol, not just functions.

	To use this, define an environment variable "MYNAME" and set it
	to your email name.  eg. set MYNAME=raygr
-------------------------------------------------------------------------*/
macro InsertHeader()
{
	// Get the owner's name from the environment variable: MYNAME.
	// If the variable doesn't exist, then the owner field is skipped.
	szMyName = getenv(MYNAME)

	// Get a handle to the current file buffer and the name
	// and location of the current symbol where the cursor is.
	hbuf = GetCurrentBuf()
	szFunc = GetCurSymbol()
	ln = GetSymbolLine(szFunc)

	// begin assembling the title string
//	sz = cat("/*   " , szFunc)
	sz = "/*    "

	/* convert symbol name to T E X T   L I K E   T H I S */
	cch = strlen(szFunc)
	ich = 0
	while (ich < cch)
		{
		ch = szFunc[ich]
		if (ich > 0)
			if (isupper(ch))
				sz = cat(sz, "  ")
			else
				sz = cat(sz, " ")
		sz = Cat(sz, toupper(ch))
		ich = ich + 1
		}

	sz = Cat(sz, "   */")
	InsBufLine(hbuf, ln, sz)
	InsBufLine(hbuf, ln+1, "/*-------------------------------------------------------------------------")

	/* if owner variable exists, insert Owner: name */
	if (strlen(szMyName) > 0)
		{
		InsBufLine(hbuf, ln+2, "    Owner: @szMyName@")
		InsBufLine(hbuf, ln+3, " ")
		ln = ln + 4
		}
	else
		ln = ln + 2

	InsBufLine(hbuf, ln,   "                                     ") // provide an indent already
	InsBufLine(hbuf, ln+1, "-------------------------------------------------------------------------*/")

	// put the insertion point inside the header comment
	SetBufIns(hbuf, ln, 10)
}


/* InsertFileHeader:

   Inserts a comment header block at the top of the current function.
   This actually works on any type of symbol, not just functions.

   To use this, define an environment variable "MYNAME" and set it
   to your email name.  eg. set MYNAME=raygr
*/

macro InsertFileHeader()
{
	szMyName = getenv(MYNAME)

	hbuf = GetCurrentBuf()

	InsBufLine(hbuf, 0, "/*-------------------------------------------------------------------------")

	/* if owner variable exists, insert Owner: name */
	InsBufLine(hbuf, 1, "    ")
	if (strlen(szMyName) > 0)
		{
		sz = "    Owner: @szMyName@"
		InsBufLine(hbuf, 2, " ")
		InsBufLine(hbuf, 3, sz)
		ln = 4
		}
	else
		ln = 2

	InsBufLine(hbuf, ln, "-------------------------------------------------------------------------*/")
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


**/

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


	if(sellen > 0)
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


	if(sellen > 0)
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

        if(StrMid(buf, 0, 1) == "/"){       //需要取消注释,防止只有单字符的行
            if(StrMid(buf, 1, 2) == "/"){
                PutBufLine(hbuf, Ln, StrMid(buf, 2, Strlen(buf)))
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
 *    switch, etc..
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


/*   G E T   W O R D   L E F T   O F   I C H   */
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




