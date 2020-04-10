/* Utils.em - a small collection of useful editing macros */
/*

source insight �궨���ļ�v2.1
source insight�Զ���֧꣬�������У������У������У�ɾ���У��м���ת����һ�У�ע���뷴ע�ͣ�֧�ֶ��У�


source insight �궨���ļ�v2.2
source insight�Զ���֧꣬�������У������У������У�֧�ֶ��У���ɾ���У��м���ת����һ�У�ע���뷴ע�ͣ�֧�ֶ��У���


source insight �궨���ļ�v2.3
source insight�Զ���֧꣬�������У������У������У�֧�ֶ��У���ɾ���У��м���ת����һ�У�ע���뷴ע�ͣ�֧�ֶ��У���
֧�ֶ��и��ơ�

source insight �궨���ļ�v2.4
source insight�Զ���꣬��ӳ��ú궨��˵�������ϵ�һ���ļ���
ͷ�ļ�����˵��



���ù���           ��ݼ�����
MultiLineComment   Ctrl + / ����ע��
UnMultiLineComment Ctrl + Q  ������ע��
duplicateselect    Ctrl + D ����һ�����ݵ���ǰѡ�����ݺ���
deleteline         Ctrl + L ɾ����ǰ��
enternewline       Ctrl + Enter ��һ����
InsertFileHeader               �����ļ�ͷ
InsertFunHeader                ���뺯��ͷ

*/

/**
source insight���ýӿ�
#��ȡlnfirst�е�����
GetBufLine(hbuf,lnfirst)
#��ȡtext,[0,chfirst)������
strmid(curlntext, 0, chfirst)
#��ӡstr
msg(str)
#��׺middle��header����
cat(header, middle)
#ɾ��ln������
DelBufLine(hbuf, ln)
#����ln������Ϊshowtext
InsBufLine(hbuf,ln, showtext)
#��ȡѡ�е�����
GetBufSelText(hbuf)
#��ȡ��ǰ���ھ��
GetCurrentWnd()
#��ȡ��ǰ�༭���ݾ��
GetCurrentBuf()
#��ȡѡ�����ݵ�����
GetWndSelLnFirst(hwnd)
#��ȡѡ�����ݵ�ĩ��
GetWndSelLnLast(hwnd)
#��ȡѡ���ַ���λ��
GetWndSelIchFirst(hwnd)
#��ȡѡ���ַ�ĩλ�ã�
GetWndSelIchLim(hwnd)
#����ѡ������Ϊ�滻�ַ�
SetBufSelText(hbuf, replacetext)


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
    InsBufLine(hbuf, 1, "** ��Ȩ����:  WeiLai Copyright (c) 2010-2015  ******************************")
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

    InsBufLine(hbuf, 2, "** �ļ�����:  @fileName@  [@fPath@]")
    InsBufLine(hbuf, 3, "** ��ǰ�汾:  v1.0")

    /* if owner variable exists, insert Owner: name */
    if (strlen(szMyName) > 0)
    {
        sz = "** ��    ��:  @szMyName@"
    }
    else
    {
        sz = "** ��    ��: "
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
	
    InsBufLine(hbuf, 5,  "** �������: @Year@��@Month@��@szDay@��")
    InsBufLine(hbuf, 6,  "** �޸ļ�¼: ")
    InsBufLine(hbuf, 7,  "** �޸ļ�¼: ")
    InsBufLine(hbuf, 8,  "** �޸�����: ")
    InsBufLine(hbuf, 9,  "** �汾��  : ")
    InsBufLine(hbuf, 10, "** �޸���  : ")
    InsBufLine(hbuf, 11, "** �޸�����: ")
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

    InsBufLine(hbuf, 15, "/*****************************ͷ�ļ�****************************************/")
    InsBufLine(hbuf, 16, "")
    InsBufLine(hbuf, 17, "/*****************************�궨��****************************************/")
    InsBufLine(hbuf, 18, "")
    InsBufLine(hbuf, 19, "/*****************************�ṹ������Ͷ���*******************************/")
    InsBufLine(hbuf, 20, "")
    InsBufLine(hbuf, 21, "")    
    InsBufLine(hbuf, 22, "/*****************************ȫ�ֱ���****************************************/")
    InsBufLine(hbuf, 23, "")
    InsBufLine(hbuf, 24, "")    
    InsBufLine(hbuf, 25, "/*****************************���ر���****************************************/")
    InsBufLine(hbuf, 26, "")
    InsBufLine(hbuf, 27, "")    
    InsBufLine(hbuf, 28, "/*****************************������������****************************************/")
    InsBufLine(hbuf, 29, "")
    InsBufLine(hbuf, 30, "")
	InsBufLine(hbuf, 31, "/*****************************��������ʵ��****************************************/")    
    InsBufLine(hbuf, 32, "")
    InsBufLine(hbuf, 33, "")
    InsBufLine(hbuf, 34, "")
    InsBufLine(hbuf, 35, "")
    InsBufLine(hbuf, 36, "")
    InsBufLine(hbuf, 37, "")
    InsBufLine(hbuf, 38, "")
    InsBufLine(hbuf, 39, "")
    InsBufLine(hbuf, 40, "/*****************************by extern \"C\"****************************************/")
    InsBufLine(hbuf, 41, "/*****************************ͷ�ļ�****************************************/")
    InsBufLine(hbuf, 42, "")
    InsBufLine(hbuf, 43, "")
    InsBufLine(hbuf, 44, "/*****************************�궨��****************************************/")
    InsBufLine(hbuf, 45, "")
    InsBufLine(hbuf, 46, "")
	InsBufLine(hbuf, 47, "#ifdef __cplusplus") 
	InsBufLine(hbuf, 48, "extern \"C\" {")
	InsBufLine(hbuf, 49, "#endif")
	InsBufLine(hbuf, 50, "")	
    InsBufLine(hbuf, 51, "/*****************************�ṹ������Ͷ���*******************************/")
    InsBufLine(hbuf, 52, "")
    InsBufLine(hbuf, 53, "")    
    InsBufLine(hbuf, 54, "/*****************************ȫ�ֱ���****************************************/")
    InsBufLine(hbuf, 55, "")
    InsBufLine(hbuf, 56, "")    
    InsBufLine(hbuf, 57, "/*****************************���ر���****************************************/")
    InsBufLine(hbuf, 58, "")
    InsBufLine(hbuf, 59, "")    
    InsBufLine(hbuf, 60, "/*****************************������������****************************************/")
    InsBufLine(hbuf, 61, "")
    InsBufLine(hbuf, 62, "")
	InsBufLine(hbuf, 63, "/*****************************��������ʵ��****************************************/")    
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



//����һ�����ݵ���ǰѡ�����ݺ���
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
		** �滻˼·:
		** ѡ��֮ǰ����header(δѡ�е�)
		** ��һ��ѡ�е���selcheader
		** ����ѡ�е���middle
		** ���һ��δѡ�е���tail
		** ���һ��ѡ�е���seltail
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

//����һ�����ݵ���ǰѡ�����ݺ���
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
    LnFirst =GetWndSelLnFirst(hwnd)      //ȡ�����к�
    LnLast =GetWndSelLnLast(hwnd)      //ȡĩ���к�
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

//���뵱ǰѡ������ݣ�����һ�С�
macro getselecttext()
{
	hbufCur = GetCurrentBuf();
	lnCur = GetBufLnCur(hbufCur)
	selecttext = GetBufSelText (hbufCur)
	sz = cat("    printk(\"", selecttext)
	sz = cat(sz, "\\n\");");

	InsBufLine(hbufCur, lnCur, sz)
}
//���Ƶ�ǰ�У������ѡ�е����ݣ�����ѡ������
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
    LnFirst =GetWndSelLnFirst(hwnd)      //ȡ�����к�
    LnLast =GetWndSelLnLast(hwnd)      //ȡĩ���к�
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

//����ע�ͻ�ע��,������һ��
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

//����ע�ͻ�ע��,������һ��
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
    LnFirst =GetWndSelLnFirst(hwnd)      //ȡ�����к�
    LnLast =GetWndSelLnLast(hwnd)      //ȡĩ���к�
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
        buf = GetBufLine(hbuf, Ln)  //ȡLn��Ӧ����
        if(buf ==""){                   //��������
            Ln = Ln + 1
            continue
        }

        if(StrMid(buf, 0, 1) == "/"){       //��Ҫȡ��ע��,��ֹֻ�е��ַ�����
            if(StrMid(buf, 1, 2) == "/"){
//                PutBufLine(hbuf, Ln, StrMid(buf, 2, Strlen(buf)))
//                PutBufLine(hbuf, Ln, Cat("//", buf))
            }
            PutBufLine(hbuf, Ln, Cat("//", buf))
        }

        if(StrMid(buf,0,1) !="/"){          //��Ҫ���ע��
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
    LnFirst =GetWndSelLnFirst(hwnd)      //ȡ�����к�
    LnLast =GetWndSelLnLast(hwnd)      //ȡĩ���к�
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
        buf = GetBufLine(hbuf, Ln)  //ȡLn��Ӧ����
        if(buf ==""){                   //��������
            Ln = Ln + 1
            continue
        }

        if(StrMid(buf, 0, 1) == "/"){       //��Ҫȡ��ע��,��ֹֻ�е��ַ�����
            if(StrMid(buf, 1, 2) == "/"){
                PutBufLine(hbuf, Ln, StrMid(buf, 2, Strlen(buf)))
//                PutBufLine(hbuf, Ln, Cat("//", buf))
            }
//            PutBufLine(hbuf, Ln, Cat("//", buf))
        }

        if(StrMid(buf,0,1) !="/"){          //��Ҫ���ע��
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
	InsBufLine(hbuf, ln + 4, " * �������: ")
	InsBufLine(hbuf, ln + 5, " * �������: ")
	InsBufLine(hbuf, ln + 6, " * ���ؽ��: 0-�ɹ�,����-ʧ��")
	InsBufLine(hbuf, ln + 7, " * ")
	InsBufLine(hbuf, ln + 8, " * modification history")
	InsBufLine(hbuf, ln + 9, " * --------------------")
	InsBufLine(hbuf, ln + 10, " * 01a, @szDay@@szMonth@@Year@, @szMyName@ written")
	InsBufLine(hbuf, ln + 11, " * --------------------")
	InsBufLine(hbuf, ln + 12, " ******************************************************************************/")
	// put the insertion point inside the header comment
	SetBufIns(hbuf, ln + 1, strlen(szFunc) + strlen(szInf) + 8)
}





