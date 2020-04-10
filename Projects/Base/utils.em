/* Utils.em - a small collection of useful editing macros */

/*-------------------------------------------------------------------------
    I N S E R T   H E A D E R
    InsertHeader  使用原名

    Inserts a comment header block at the top of the current function. 
    This actually works on any type of symbol, not just functions.

    To use this, define an environment variable "MYNAME" and set it
    to your email name.  eg. set MYNAME=raygr
-------------------------------------------------------------------------*/
macro InsertHeader()
{
    // Get the owner's name from the environment variable: MYNAME.
    // If the variable doesn't exist, then the owner field is skipped.
    szMyName = getenv(MyName)

    // Get a handle to the current file buffer and the name
    // and location of the current symbol where the cursor is.
    hbuf = GetCurrentBuf() //get current file buffer
    szFunc = GetCurSymbol() //get current symbol
    ln = GetSymbolLine(szFunc) //get current symbol at line

	//InsBufLine insert on line
    InsBufLine(hbuf, ln, "/*======================================================");
    ln = ln + 1 //add one line

    // begin assembling the title string
    //   "** Desc      : "
    sz = "** FunName   : "  

    /* convert symbol name to T E X T   L I K E   T H I S */
    cch = strlen(szFunc)
    ich = 0
    while (ich < cch)
    {
        ch = szFunc[ich]
        if (ich > 0)
            if (isupper(ch))
                sz = cat(sz, "")
            else
                sz = cat(sz, "")
        sz = Cat(sz, (ch))
        ich = ich + 1
    } 
    InsBufLine(hbuf, ln, sz)
    ln = ln + 1

    InsBufLine(hbuf, ln, "** Desc      : ")
    ln = ln + 1

    InsBufLine(hbuf, ln, "** InputPara : ")
    ln = ln + 1

    InsBufLine(hbuf, ln, "** OutPutPara: ")
    ln = ln + 1

    InsBufLine(hbuf, ln, "** Return Val: ")
    ln = ln + 1

    /* if owner variable exists, insert Owner: name */
    if (strlen(szMyName) > 0)
    {
    	//                   "** Desc      : "
        InsBufLine(hbuf, ln, "** Author    :  @szMyName@")                 
    }
    else
    {
        InsBufLine(hbuf, ln, "** Author    :  ")                 
    }
    ln = ln + 1

    // Get current time
    szTime  = GetSysTime(1) //get system time
    Day      = szTime.Day //day
    Month   = szTime.Month //month
    Year     = szTime.Year //year
    if (Day < 10) 
        szDay = "0@Day@" //day
    else
        szDay = Day   //day

	//                   "** Desc      : "
	//                   "** Author    :  ") 
    InsBufLine(hbuf, ln, "** Date      :  @Year@年@Month@月@szDay@日")
    ln = ln + 1 //add one line
    InsBufLine(hbuf, ln, "** Ver       :  1.0")
    ln = ln + 1
    InsBufLine(hbuf, ln, "======================================================*/")
}

macro InsertPrintk()
{
    // Get a handle to the current file buffer and the name
    // and location of the current symbol where the cursor is.
    hbuf = GetCurrentBuf()  
    
    szFunc="    printk(KERN_SELF\"F:%s(L:%d\@%s) \\n\", __FUNCTION__, __LINE__,__FILE__);"
    hwnd=GetCurrentWnd()
    sel=GetWndSel(hwnd)
    lnFirst=GetWndSelLnFirst(hwnd)    
  
    //szFunc = GetCurSymbol()
    //ln = GetSymbolLine(szFunc)
    
    InsBufLine(hbuf, lnFirst, szFunc);
    
}

macro InsertPrintkHex()
{
    // Get a handle to the current file buffer and the name
    // and location of the current symbol where the cursor is.
    hbuf = GetCurrentBuf()  
    
    szFunc="    printk(KERN_SELF\"    ,0x%08x    \\n\",   );"
    hwnd=GetCurrentWnd()
    sel=GetWndSel(hwnd)
    lnFirst=GetWndSelLnFirst(hwnd)    
  
    //szFunc = GetCurSymbol()
    //ln = GetSymbolLine(szFunc)

    InsBufLine(hbuf, lnFirst, szFunc);
}


// Inserts "Returns True .. or False..." at the current line
macro ReturnTrueOrFalse()
{
    hbuf = GetCurrentBuf()
    ln = GetBufLineCur(hbuf)

    InsBufLine(hbuf, ln, "    Returns True if successful or False if errors.")
}

// Ask user for ifdef condition and wrap it around current
// selection.
macro InsertIfdef()
{
    hwnd = GetCurrentWnd()
    lnFirst = GetWndSelLnFirst(hwnd)
    lnLast = GetWndSelLnLast(hwnd)

    hbuf = GetCurrentBuf()
    InsBufLine(hbuf, lnFirst, "#if defined(###)")
    InsBufLine(hbuf, lnLast+2, "#endif /* ### */")
    LoadSearchPattern("###", true, false, false);
    Search_Forward
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

macro CodeComment(){//多行注释
    hwnd=GetCurrentWnd()
    selection=GetWndSel(hwnd)
    LnFirst=GetWndSelLnFirst(hwnd)//取首行行号
    LnLast=GetWndSelLnLast(hwnd)//取末行行号
    hbuf=GetCurrentBuf()
    if(GetBufLine(hbuf,0)=="//magic-number:tph85666031")
    {
        stop
    }
    Ln=Lnfirst
    buf=GetBufLine(hbuf,Ln)
    len=strlen(buf)
    while(Ln<=Lnlast)
    {
        buf=GetBufLine(hbuf,Ln)//取Ln对应的行
        if(buf=="")
        {//跳过空行
            Ln=Ln+1
            continue
        }
        if(StrMid(buf,0,1)=="/")
        {//需要取消注释,防止只有单字符的行
            if(StrMid(buf,1,2)=="/")
            {
                PutBufLine(hbuf,Ln,StrMid(buf,2,Strlen(buf)))
            }
        }
        if(StrMid(buf,0,1)!="/")
        {//需要添加注释
            PutBufLine(hbuf,Ln,Cat("//",buf))
        }
        Ln=Ln+1
    }
    SetWndSel( hwnd, selection )
}

macro MacroComment()
{
    hwnd=GetCurrentWnd()
    sel=GetWndSel(hwnd)
    lnFirst=GetWndSelLnFirst(hwnd)
    lnLast=GetWndSelLnLast(hwnd)
    hbuf=GetCurrentBuf()
  
    if (LnFirst == 0) {
            szIfStart = ""
    } else
    {
            szIfStart = GetBufLine(hbuf, LnFirst-1)
    }
    szIfEnd = GetBufLine(hbuf, lnLast+1)
    if (szIfStart == "#if 0" && szIfEnd == "#endif")
    {
            DelBufLine(hbuf, lnLast+1)
            DelBufLine(hbuf, lnFirst-1)
            sel.lnFirst = sel.lnFirst -1
            sel.lnLast = sel.lnLast -1
    }
    else
    {
            InsBufLine(hbuf, lnFirst, "#if 0")
            InsBufLine(hbuf, lnLast+2, "#endif")
            sel.lnFirst = sel.lnFirst + 1
            sel.lnLast = sel.lnLast + 1
    }
    SetWndSel( hwnd, sel )
}


/*   A U T O   E X P A N D   */
/*-------------------------------------------------------------------------
    Automatically expands C statements like if, for, while, switch, etc..

    To use this macro,
     1. Add this file to your project or your Base project.
  
  2. Run the Options->Key Assignments command and assign a
  convenient keystroke to the "AutoExpand" command.
  
  3. After typing a keyword, press the AutoExpand keystroke to have the
  statement expanded.  The expanded statement will contain a ### string
  which represents a field where you are supposed to type more.
  
  The ### string is also loaded in to the search pattern so you can
  use "Search Forward" to select the next ### field.

 For example:
  1. you type "for" + AutoExpand key
  2. this is inserted:
    for (###; ; )
    {

    }
  3. and the first ### field is selected.
-------------------------------------------------------------------------*/
macro AutoExpand()
{
&nbsp;&nbsp;&nbsp; // get window, sel, and buffer handles
&nbsp;&nbsp;&nbsp; hwnd = GetCurrentWnd()
&nbsp;&nbsp;&nbsp; if (hwnd == 0)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; stop
&nbsp;&nbsp;&nbsp; sel = GetWndSel(hwnd)
&nbsp;&nbsp;&nbsp; if (sel.ichFirst == 0)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; stop
&nbsp;&nbsp;&nbsp; hbuf = GetWndBuf(hwnd)

&nbsp;&nbsp;&nbsp; // get line the selection (insertion point) is on
&nbsp;&nbsp;&nbsp; szLine = GetBufLine(hbuf, sel.lnFirst);

&nbsp;&nbsp;&nbsp; // parse word just to the left of the insertion point
&nbsp;&nbsp;&nbsp; wordinfo = GetWordLeftOfIch(sel.ichFirst, szLine)
&nbsp;&nbsp;&nbsp; ln = sel.lnFirst;

&nbsp;&nbsp;&nbsp; chTab = CharFromAscii(9)

&nbsp;&nbsp;&nbsp; // prepare a new indented blank line to be inserted.
&nbsp;&nbsp;&nbsp; // keep white space on left and add a tab to indent.
&nbsp;&nbsp;&nbsp; // this preserves the indentation level.
&nbsp;&nbsp;&nbsp; ich = 0
&nbsp;&nbsp;&nbsp; while (szLine[ich] == ' ' || szLine[ich] == chTab)
&nbsp;&nbsp;&nbsp; {
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ich = ich + 1
&nbsp;&nbsp;&nbsp; }

&nbsp;&nbsp;&nbsp; szLine = strmid(szLine, 0, ich)
&nbsp;&nbsp;&nbsp; szLineTab = strmid(szLine, 0, ich) # "&nbsp;&nbsp;&nbsp; "
&nbsp;&nbsp;&nbsp; sel.lnFirst = sel.lnLast
&nbsp;&nbsp;&nbsp; sel.ichFirst = wordinfo.ich
&nbsp;&nbsp;&nbsp; sel.ichLim = wordinfo.ich

&nbsp;&nbsp;&nbsp; // expand szWord keyword...


&nbsp;&nbsp;&nbsp; if (wordinfo.szWord == "while")
&nbsp;&nbsp;&nbsp; {
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SetBufSelText(hbuf, " (###)")
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 1, "@szLine@" # "{");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 2, "@szLine@" # "");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 3, "@szLine@" # "}");
&nbsp;&nbsp;&nbsp; }
&nbsp;&nbsp;&nbsp; else if (wordinfo.szWord == "if" || wordinfo.szWord == "elseif" || wordinfo.szWord == "else if")
&nbsp;&nbsp;&nbsp; {
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SetBufSelText(hbuf, " (###)")
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 1, "@szLine@" # "{");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 2, "@szLine@" # "");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 3, "@szLine@" # "}");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 4, "@szLine@" # "else");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 5, "@szLine@" # "{");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 6, "@szLine@" # "");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 7, "@szLine@" # "}");
&nbsp;&nbsp;&nbsp; }
&nbsp;&nbsp;&nbsp; else if (wordinfo.szWord == "for")
&nbsp;&nbsp;&nbsp; {
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SetBufSelText(hbuf, " (###; ; )")
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 1, "@szLine@" # "{");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 2, "@szLine@" # "");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 3, "@szLine@" # "}");
&nbsp;&nbsp;&nbsp; }
&nbsp;&nbsp;&nbsp; else if (wordinfo.szWord == "switch")
&nbsp;&nbsp;&nbsp; {
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SetBufSelText(hbuf, " (###)")
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 1, "@szLine@" # "{")
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 2, "@szLine@" # "case :")
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 3, "@szLineTab@" # "")
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 4, "@szLineTab@" # "break;")
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 5, "@szLine@" # "default :")
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 6, "@szLineTab@" # "")
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 7, "@szLineTab@" # "break;")
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 8, "@szLine@" # "}")
&nbsp;&nbsp;&nbsp; }
&nbsp;&nbsp;&nbsp; else if (wordinfo.szWord == "do")
&nbsp;&nbsp;&nbsp; {
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 1, "@szLine@" # "{")
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 2, "@szLineTab@" # "");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 3, "@szLine@" # "} while (###);")
&nbsp;&nbsp;&nbsp; }
&nbsp;&nbsp;&nbsp; else if (wordinfo.szWord == "case")
&nbsp;&nbsp;&nbsp; {
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SetBufSelText(hbuf, " ###:")
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 1, "@szLineTab@" # "")
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 2, "@szLineTab@" # "break;")
&nbsp;&nbsp;&nbsp; }
&nbsp;&nbsp;&nbsp; else if (wordinfo.szWord == "try")
&nbsp;&nbsp;&nbsp; {
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SetBufSelText(hbuf, " ")
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 1, "@szLine@" # "{");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 2, "@szLineTab@" # "");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 3, "@szLine@" # "}");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 4, "@szLine@" # "catch (Exception ###)");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 5, "@szLine@" # "{");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 6, "@szLineTab@" # "");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 7, "@szLine@" # "}");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 8, "@szLine@" # "finally");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 9, "@szLine@" # "{");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln +10, "@szLineTab@" # "");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln +11, "@szLine@" # "}");
&nbsp;&nbsp;&nbsp; }
&nbsp;&nbsp;&nbsp; else if (wordinfo.szWord == "catch")
&nbsp;&nbsp;&nbsp; {
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SetBufSelText(hbuf, " (Exception ###)")
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 5, "@szLine@" # "{");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 6, "@szLineTab@" # "");
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; InsBufLine(hbuf, ln + 7, "@szLine@" # "}");
&nbsp;&nbsp;&nbsp; }
&nbsp;&nbsp;&nbsp; else
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; stop

    SetWndSel(hwnd, sel)
    LoadSearchPattern("###", true, false, false);
    Search_Forward
}
/*   G E T   W O R D   L E F T   O F   I C H   */
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




// Closes all but the most recently visited windows and files.
// Any dirty files are kept open.
macro CloseOldWindows()
{
    var hwnd
    var cWnd

    // This is the number of recent windows to keep open.  You may change
    // this constant to suit your needs.
    var NumberOfWindowsToKeep; NumberOfWindowsToKeep = 1

    hwnd = GetCurrentWnd()
    cWnd = 0

    // skip the most recently visited windows in the z-order
    while (hwnd != hNil && cWnd < NumberOfWindowsToKeep)
    {
        cWnd = cWnd + 1
        hwnd = GetNextWnd(hwnd)
    }

    // close the remaining windows
    while (hwnd != hNil)
    {
        var hwndNext

        hwndNext = GetNextWnd(hwnd)

        // only close the window if the file is not edited
        if (!IsBufDirty(GetWndBuf(hwnd)))
            CloseWnd(hwnd)

        hwnd = hwndNext
    }

    // close all files that are not visible in a window anymore
    var cBuf
    cBuf = BufListCount()
    while (cBuf > 0)
    {
        var hbuf
        cBuf = cBuf - 1
        hbuf = BufListItem(cBuf)
        if (GetWndHandle(hbuf) == hNil)
            CloseBuf(hbuf)
    }
}

// Convert spaces to tabs and save the file
macro Save_Spaces_To_Tabs()
{
    hbuf = GetCurrentBuf()
    if (hbuf != hNil)
    {
        Spaces_To_Tabs()
        SaveBuf(hbuf)
    }
}

// Convert tabs to spaces and save the file
macro Save_Tabs_To_Spaces()
{
    hbuf = GetCurrentBuf()
    if (hbuf != hNil)
    {
        Tabs_To_Spaces()
        SaveBuf(hbuf)
    }
}

 

//----------------------------------------------------------------------------
//  Function: Spaces_To_Tabs
//
// Description:
//   Convert all sets of two or more spaces in the current buffer into the
//      appropriate number of tab characters.
//
macro Spaces_To_Tabs()
{
 hbuf = GetCurrentBuf()
 hwnd = GetCurrentWnd()
 srSave = GetWndSel(hwnd)

    // Phase 1: convert the spaces at the beginning of lines
    //
 Leading_Spaces_To_Tabs()

    // Phase 2: convert the spaces NOT at the beginning of lines
    //
 sr = SearchInBuf(hbuf, "  +", 0, 0, 1, 1, 0)
 
 while (sr != "")
 {
     SetWndSel(hwnd, sr)
  ReTab_Current_Line()
     sr = GetWndSel(hwnd)
        sr = SearchInBuf(hbuf, "  +", sr.lnLast, sr.ichLim, 1, 1, 0)
 }
 SetBufIns(hbuf, srSave.lnFirst, srSave.ichFirst)
}

//----------------------------------------------------------------------------
//  Function: Tabs_To_Spaces
//
// Description:
//   Convert all tab characters in the current buffer into the appropriate
//      number of spaces.
//
macro Tabs_To_Spaces()
{
    hbuf = GetCurrentBuf()
    hwnd = GetCurrentWnd()
    srSave = GetWndSel(hwnd)

    // Phase 1: convert the tabs at the beginning of lines
    //
    Leading_Tabs_To_Spaces()

    // Phase 2: convert the tabs NOT at the beginning of lines
    //
    sr = SearchInBuf(hbuf, "//t", 0, 0, 1, 1, 0)

    while (sr != "")
    {
        SetWndSel(hwnd, sr)
        DeTab_Current_Line()
        sr = GetWndSel(hwnd)
        sr = SearchInBuf(hbuf, "//t", sr.lnLast, sr.ichLim, 1, 1, 0)
    }
    SetBufIns(hbuf, srSave.lnFirst, srSave.ichFirst)
}

 

//----------------------------------------------------------------------------
//  Function: Leading_Spaces_To_Tabs
//
// Description:
//   Convert all sets of two or more spaces in the current buffer into the
//      appropriate number of tab characters.
//
macro Leading_Spaces_To_Tabs()
{
 hbuf = GetCurrentBuf()
    iConsecutiveTabs = 0
    while (iConsecutiveTabs < 15)
    {
  ReplaceInBuf(hbuf, "^//(//t*//)    ", "//1//t", 0,
       GetBufLineCount(hbuf) + 1, 1, 1, 0, 0)
  iConsecutiveTabs = iConsecutiveTabs + 1
 }
}

 

//----------------------------------------------------------------------------
//  Function: Leading_Tabs_To_Spaces
//
// Description:
//   Convert all tab characters at line beginnings in the current buffer
//  into the appropriate number of spaces. Brute force method.
//
macro Leading_Tabs_To_Spaces()
{
     hbuf = GetCurrentBuf()
    ReplaceInBuf(hbuf, "^//t//t//t//t//t//t//t//t//t//t//t//t//t//t//t",
        "                                                            ",
     0, GetBufLineCount(hbuf) + 1, 1, 1, 0, 0)
    ReplaceInBuf(hbuf, "^//t//t//t//t//t//t//t//t//t//t//t//t//t//t",
        "                                                        ",
     0, GetBufLineCount(hbuf) + 1, 1, 1, 0, 0)
    ReplaceInBuf(hbuf, "^//t//t//t//t//t//t//t//t//t//t//t//t//t",
        "                                                    ",
     0, GetBufLineCount(hbuf) + 1, 1, 1, 0, 0)
    ReplaceInBuf(hbuf, "^//t//t//t//t//t//t//t//t//t//t//t//t",
        "                                                ",
     0, GetBufLineCount(hbuf) + 1, 1, 1, 0, 0)
    ReplaceInBuf(hbuf, "^//t//t//t//t//t//t//t//t//t//t//t",
        "                                            ",
     0, GetBufLineCount(hbuf) + 1, 1, 1, 0, 0)
    ReplaceInBuf(hbuf, "^//t//t//t//t//t//t//t//t//t//t",
        "                                        ",
     0, GetBufLineCount(hbuf) + 1, 1, 1, 0, 0)
    ReplaceInBuf(hbuf, "^//t//t//t//t//t//t//t//t//t",
        "                                    ",
     0, GetBufLineCount(hbuf) + 1, 1, 1, 0, 0)
    ReplaceInBuf(hbuf, "^//t//t//t//t//t//t//t//t",
        "                                ",
     0, GetBufLineCount(hbuf) + 1, 1, 1, 0, 0)
    ReplaceInBuf(hbuf, "^//t//t//t//t//t//t//t",
        "                            ",
     0, GetBufLineCount(hbuf) + 1, 1, 1, 0, 0)
    ReplaceInBuf(hbuf, "^//t//t//t//t//t//t",
        "                        ",
     0, GetBufLineCount(hbuf) + 1, 1, 1, 0, 0)
    ReplaceInBuf(hbuf, "^//t//t//t//t//t",
        "                    ",
     0, GetBufLineCount(hbuf) + 1, 1, 1, 0, 0)
    ReplaceInBuf(hbuf, "^//t//t//t//t",
        "                ",
     0, GetBufLineCount(hbuf) + 1, 1, 1, 0, 0)
    ReplaceInBuf(hbuf, "^//t//t//t",
        "            ",
     0, GetBufLineCount(hbuf) + 1, 1, 1, 0, 0)
    ReplaceInBuf(hbuf, "^//t//t",
        "        ",
     0, GetBufLineCount(hbuf) + 1, 1, 1, 0, 0)
    ReplaceInBuf(hbuf, "^//t",
        "    ",
     0, GetBufLineCount(hbuf) + 1, 1, 1, 0, 0)
}

 

//----------------------------------------------------------------------------
//  Function: DeTab_Current_Line
//
// Description:
//   Convert all tabs in the current line into the appropriate number of
//  spaces, based upon line position. Good for up to 25 consecutive tabs.
//
macro DeTab_Current_Line()
{
 szSpaces = "                                                                                                    "
 tabSize  = 4
 hbuf = GetCurrentBuf()
 iLine = GetBufLnCur(hbuf)
 cLines = GetBufLineCount(hbuf)
 szLine = GetBufLine(hbuf, iLine)
 cchLine = strlen(szLine)

 ichL = 0
 ichR = 0
 icoL = 0
 icoR = 0
 ichLine = 0
 icoLine = 0
 inTabs = '<'
 szNewLine = ""

 while (ichLine < cchLine)
 {
  if (szLine[ichLine] == "/t")
  {
   if (inTabs == 'N')
   {
    szNewLine = cat(szNewLine, strmid(szLine, ichL, ichR + 1))
    icoL = icoLine
   }
   icoLine = (((icoLine + tabSize) / tabSize) * tabSize)
   icoR = icoLine
   inTabs = 'Y'
  }
  else
  {
   if (inTabs == 'Y')
   {
    cSpaces = icoR - icoL
    szNewLine = cat(szNewLine, strtrunc(szSpaces, cSpaces))
    ichL = ichLine
    ichR = ichLine
   }
   else
   {
    ichR = ichLine
   }
   icoLine = icoLine + 1
   inTabs = 'N'
  }
  ichLine = ichLine + 1
 }
 if (inTabs == 'Y')
 {
  cSpaces = icoR - icoL
  szNewLine = cat(szNewLine, strtrunc(szSpaces, cSpaces))
 }
 else
 {
  szNewLine = cat(szNewLine, strmid(szLine, ichL, ichR + 1))
 }
 PutBufLine(hbuf, iLine, szNewLine)

 // Work around weirdness of PutBufLine(); it moves UP one line when
 // putting the last line in the buffer!
 //
 if (iLine + 1 == cLines)
 {
  Cursor_Down
 }
 End_Of_Line
}

//----------------------------------------------------------------------------
//  Function: ReTab_Current_Line
//
// Description:
//   Convert all sets of two or more spaces in the current line into the
//      appropriate number of tab and space characters, based upon line
//  position. Good for indentations up to 100 columns.
//
macro ReTab_Current_Line()
{
 szTabs   = "                         ";
 szSpaces = "    "  // As many spaces as value of tabSize
 tabSize  = 4
 hbuf = GetCurrentBuf()
 iLine = GetBufLnCur(hbuf)
 cLines = GetBufLineCount(hbuf)
 szLine = GetBufLine(hbuf, GetBufLnCur(hbuf))
 cchLine = strlen(szLine)

 ichL = 0
 ichR = 0
 icoL = 0
 icoR = 0
 ichLine = 0
 icoLine = 0
 inText = '<'
 quotes = 'N'
 szNewLine = ""

 while (ichLine < cchLine)
 {
  if (szLine[ichLine] == "/t")
  {
      if (quotes == 'N')
      {
       if (inText == 'Y')
       {
        szNewLine = cat(szNewLine, strmid(szLine, ichL, ichR + 1))
        icoL = icoLine
       }
       else if (inText == '?')
       {
        ichR = ichR - 1
        szNewLine = cat(szNewLine, strmid(szLine, ichL, ichR + 1))
       }
       inText = 'N'
      }
      icoLine = (((icoLine + tabSize) / tabSize) * tabSize)
      icoR = icoLine
  }
  else if (szLine[ichLine] == " ")
  {
      if (quotes == 'N')
      {
       if (inText == 'Y')
       {
        icoL = icoLine
        ichR = ichLine
        inText = '?'
       }
       else if (inText == '?')
       {
        ichR = ichR - 1
        szNewLine = cat(szNewLine, strmid(szLine, ichL, ichR + 1))
        inText = 'N'
       }
       else
       {
        inText = 'N'
       }
      }
      icoLine = icoLine + 1
      icoR = icoLine
  }
  else
  {
   if (inText == 'N')
   {
    cTabs = (icoR / tabSize) - (icoL / tabSize)
    if (cTabs > 0)
    {
     szNewLine = cat(szNewLine, strtrunc(szTabs, cTabs))
     cSpaces = icoR - ((icoR / tabSize) * tabSize)
    }
    else
    {
     cSpaces = icoR - icoL
    }
    if (cSpaces > 0)
    {
     szNewLine = cat(szNewLine, strtrunc(szSpaces, cSpaces))
    }
    ichL = ichLine
    ichR = ichLine
   }
   else
   {
    ichR = ichLine
   }
   if (szLine[ichLine] == "/")
   {
    if (quotes == 'N')
    {
        quotes = 'Y'
       }
       else if (szLine[ichLine - 1] != "//")
       {
        quotes = 'N'
       }
   }
   icoLine = icoLine + 1
   inText = 'Y'
  }
  ichLine = ichLine + 1
 }
 if ((inText == 'Y') || (inText == '?'))
 {
  szNewLine = cat(szNewLine, strmid(szLine, ichL, ichR + 1))
 }
 else if (inText == 'N')
 {
  cTabs = (icoR / tabSize) - (icoL / tabSize)
  if (cTabs > 0)
  {
   szNewLine = cat(szNewLine, strtrunc(szTabs, cTabs))
   cSpaces = icoR - ((icoR / tabSize) * tabSize)
  }
  else
  {
   cSpaces = icoR - icoL
  }
  if (cSpaces > 0)
  {
   szNewLine = cat(szNewLine, strtrunc(szSpaces, cSpaces))
  } 
 }
 PutBufLine(hbuf, iLine, szNewLine)

 // Work around weirdness of PutBufLine(); it moves UP one line when
 // putting the last line in the buffer!
 //
 if (iLine + 1 == cLines)
 {
  Cursor_Down
 }
 End_Of_Line
}



/*
* 代替SourceInsight原有的Backspace功能（希望如此）
* 增加了对双字节汉字的支持，在删除汉字的时候也能同时删除汉字的高字节而缓解半个汉字问题
* 能够对光标在汉字中间的情况进行自动修正
*
* 安装：
* ① 复制入SourceInsight安装目录；
* ② Project→Open Project，打开Base项目；
* ③ 将复制过去的SuperBackspace.em添加入Base项目?
* ④ 重启SourceInsight；
* ⑤ Options→Key Assignments，将Marco: SuperBackspace绑定到BackSpace键；
* ⑥ Enjoy！！
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*/

/*======================================================================

1、BackSpace后退键

======================================================================*/

macro SuperBackspace()

{

    hwnd = GetCurrentWnd();

    hbuf = GetCurrentBuf();

    if (hbuf == 0)

        stop; // empty buffer

    // get current cursor postion

    ipos = GetWndSelIchFirst(hwnd);

    // get current line number

    ln = GetBufLnCur(hbuf);

    if ((GetBufSelText(hbuf) != "") || (GetWndSelLnFirst(hwnd) != GetWndSelLnLast(hwnd))) {

        // sth. was selected, del selection

        SetBufSelText(hbuf, " "); // stupid & buggy sourceinsight

        // del the " "

        SuperBackspace(1);

        stop;

    }

    // copy current line

    text = GetBufLine(hbuf, ln);

    // get string length

    len = strlen(text);

    // if the cursor is at the start of line, combine with prev line

    if (ipos == 0 || len == 0) {

        if (ln <= 0)

            stop; // top of file

        ln = ln - 1; // do not use "ln--" for compatibility with older versions

        prevline = GetBufLine(hbuf, ln);

        prevlen = strlen(prevline);

        // combine two lines

        text = cat(prevline, text);

        // del two lines

        DelBufLine(hbuf, ln);

        DelBufLine(hbuf, ln);

        // insert the combined one

        InsBufLine(hbuf, ln, text);

        // set the cursor position

        SetBufIns(hbuf, ln, prevlen);

        stop;

    }

    num = 1; // del one char

    if (ipos >= 1) {

        // process Chinese character

        i = ipos;

        count = 0;

        while (AsciiFromChar(text[i - 1]) >= 160) {

            i = i - 1;

            count = count + 1;

            if (i == 0)

                break;

        }

        if (count > 0) {

            // I think it might be a two-byte character

            num = 2;

            // This idiot does not support mod and bitwise operators

            if ((count / 2 * 2 != count) && (ipos < len))

                ipos = ipos + 1; // adjust cursor position

        }

    }

    // keeping safe

    if (ipos - num < 0)

        num = ipos;

    // del char(s)

    text = cat(strmid(text, 0, ipos - num), strmid(text, ipos, len));

    DelBufLine(hbuf, ln);

    InsBufLine(hbuf, ln, text);

    SetBufIns(hbuf, ln, ipos - num);

    stop;

}

/*======================================================================

2、删除键——SuperDelete.em

======================================================================*/

macro SuperDelete()

{

    hwnd = GetCurrentWnd();

    hbuf = GetCurrentBuf();

    if (hbuf == 0)

        stop; // empty buffer

    // get current cursor postion

    ipos = GetWndSelIchFirst(hwnd);

    // get current line number

    ln = GetBufLnCur(hbuf);

    if ((GetBufSelText(hbuf) != "") || (GetWndSelLnFirst(hwnd) != GetWndSelLnLast(hwnd))) {

        // sth. was selected, del selection

        SetBufSelText(hbuf, " "); // stupid & buggy sourceinsight

        // del the " "

        SuperDelete(1);

        stop;

    }

    // copy current line

    text = GetBufLine(hbuf, ln);

    // get string length

    len = strlen(text);



    if (ipos == len || len == 0) {

totalLn = GetBufLineCount (hbuf);

lastText = GetBufLine(hBuf, totalLn-1);

lastLen = strlen(lastText);

        if (ipos == lastLen)// end of file

   stop;

        ln = ln + 1; // do not use "ln--" for compatibility with older versions

        nextline = GetBufLine(hbuf, ln);

        nextlen = strlen(nextline);

        // combine two lines

        text = cat(text, nextline);

        // del two lines

        DelBufLine(hbuf, ln-1);

        DelBufLine(hbuf, ln-1);

        // insert the combined one

        InsBufLine(hbuf, ln-1, text);

        // set the cursor position

        SetBufIns(hbuf, ln-1, len);

        stop;

    }

    num = 1; // del one char

    if (ipos > 0) {

        // process Chinese character

        i = ipos;

        count = 0;

      while (AsciiFromChar(text[i-1]) >= 160) {

            i = i - 1;

            count = count + 1;

            if (i == 0)

                break;

        }

        if (count > 0) {

            // I think it might be a two-byte character

            num = 2;

            // This idiot does not support mod and bitwise operators

            if (((count / 2 * 2 != count) || count == 0) && (ipos < len-1))

                ipos = ipos + 1; // adjust cursor position

        }

// keeping safe

if (ipos - num < 0)

            num = ipos;

    }

    else {

i = ipos;

count = 0;

while(AsciiFromChar(text) >= 160) {

     i = i + 1;

     count = count + 1;

     if(i == len-1)

   break;

}

if(count > 0) {

     num = 2;

}

    }



    text = cat(strmid(text, 0, ipos), strmid(text, ipos+num, len));

    DelBufLine(hbuf, ln);

    InsBufLine(hbuf, ln, text);

    SetBufIns(hbuf, ln, ipos);

    stop;

}

/*======================================================================

3、左移键——SuperCursorLeft.em

======================================================================*/

macro IsComplexCharacter()

{

hwnd = GetCurrentWnd();

hbuf = GetCurrentBuf();

if (hbuf == 0)

   return 0;

//当前位置

pos = GetWndSelIchFirst(hwnd);

//当前行数

ln = GetBufLnCur(hbuf);

//得到当前行

text = GetBufLine(hbuf, ln);

//得到当前行长度

len = strlen(text);

//从头计算汉字字符的个数

if(pos > 0)

{

   i=pos;

   count=0;

   while(AsciiFromChar(text[i-1]) >= 160)

   {

    i = i - 1;

    count = count+1;

    if(i == 0)

     break;

   }

   if((count/2)*2==count|| count==0)

    return 0;

   else

    return 1;

}

return 0;

}

macro moveleft()

{

hwnd = GetCurrentWnd();

hbuf = GetCurrentBuf();

if (hbuf == 0)

        stop; // empty buffer



ln = GetBufLnCur(hbuf);

ipos = GetWndSelIchFirst(hwnd);

if(GetBufSelText(hbuf) != "" || (ipos == 0 && ln == 0)) // 第0行或者是选中文字,则不移动

{

   SetBufIns(hbuf, ln, ipos);

   stop;

}

if(ipos == 0)

{

   preLine = GetBufLine(hbuf, ln-1);

   SetBufIns(hBuf, ln-1, strlen(preLine)-1);

}

else

{

   SetBufIns(hBuf, ln, ipos-1);

}

}

macro SuperCursorLeft()

{

moveleft();

if(IsComplexCharacter())

   moveleft();

}

/*======================================================================

4、右移键——SuperCursorRight.em

======================================================================*/

macro moveRight()

{

hwnd = GetCurrentWnd();

hbuf = GetCurrentBuf();

if (hbuf == 0)

        stop; // empty buffer

ln = GetBufLnCur(hbuf);

ipos = GetWndSelIchFirst(hwnd);

totalLn = GetBufLineCount(hbuf);

text = GetBufLine(hbuf, ln);

if(GetBufSelText(hbuf) != "") //选中文字

{

   ipos = GetWndSelIchLim(hwnd);

   ln = GetWndSelLnLast(hwnd);

   SetBufIns(hbuf, ln, ipos);

   stop;

}

if(ipos == strlen(text)-1 && ln == totalLn-1) // 末行

   stop;

if(ipos == strlen(text))

{

   SetBufIns(hBuf, ln+1, 0);

}

else

{

   SetBufIns(hBuf, ln, ipos+1);

}

}

macro SuperCursorRight()

{

moveRight();

if(IsComplexCharacter()) // defined in SuperCursorLeft.em

   moveRight();

}

/*======================================================================

5、shift+右移键——ShiftCursorRight.em

======================================================================*/

macro IsShiftRightComplexCharacter()

{

hwnd = GetCurrentWnd();

hbuf = GetCurrentBuf();

if (hbuf == 0)

   return 0;

selRec = GetWndSel(hwnd);

pos = selRec.ichLim;

ln = selRec.lnLast;

text = GetBufLine(hbuf, ln);

len = strlen(text);

if(len == 0 || len < pos)

return 1;

//Msg("@len@;@pos@;");

if(pos > 0)

{

   i=pos;

   count=0;

   while(AsciiFromChar(text[i-1]) >= 160)

   {

    i = i - 1;

    count = count+1;

    if(i == 0)

     break;

   }

   if((count/2)*2==count|| count==0)

    return 0;

   else

    return 1;

}

return 0;

}

macro shiftMoveRight()

{

hwnd = GetCurrentWnd();

hbuf = GetCurrentBuf();

if (hbuf == 0)

        stop; 



ln = GetBufLnCur(hbuf);

ipos = GetWndSelIchFirst(hwnd);

totalLn = GetBufLineCount(hbuf);

text = GetBufLine(hbuf, ln);

selRec = GetWndSel(hwnd);

curLen = GetBufLineLength(hbuf, selRec.lnLast);

if(selRec.ichLim == curLen+1 || curLen == 0)

{

   if(selRec.lnLast == totalLn -1)

    stop;

   selRec.lnLast = selRec.lnLast + 1;

   selRec.ichLim = 1;

   SetWndSel(hwnd, selRec);

   if(IsShiftRightComplexCharacter())

    shiftMoveRight();

   stop;

}

selRec.ichLim = selRec.ichLim+1;

SetWndSel(hwnd, selRec);

}

macro SuperShiftCursorRight()

{

if(IsComplexCharacter())

   SuperCursorRight();

shiftMoveRight();

if(IsShiftRightComplexCharacter())

   shiftMoveRight();

}

/*======================================================================

6、shift+左移键——ShiftCursorLeft.em

======================================================================*/

macro IsShiftLeftComplexCharacter()

{

hwnd = GetCurrentWnd();

hbuf = GetCurrentBuf();

if (hbuf == 0)

   return 0;

selRec = GetWndSel(hwnd);

pos = selRec.ichFirst;

ln = selRec.lnFirst;

text = GetBufLine(hbuf, ln);

len = strlen(text);

if(len == 0 || len < pos)

   return 1;

//Msg("@len@;@pos@;");

if(pos > 0)

{

   i=pos;

   count=0;

   while(AsciiFromChar(text[i-1]) >= 160)

   {

    i = i - 1;

    count = count+1;

    if(i == 0)

     break;

   }

   if((count/2)*2==count|| count==0)

    return 0;

   else

    return 1;

}

return 0;

}

macro shiftMoveLeft()

{

hwnd = GetCurrentWnd();

hbuf = GetCurrentBuf();

if (hbuf == 0)

        stop; 



ln = GetBufLnCur(hbuf);

ipos = GetWndSelIchFirst(hwnd);

totalLn = GetBufLineCount(hbuf);

text = GetBufLine(hbuf, ln);

selRec = GetWndSel(hwnd);

//curLen = GetBufLineLength(hbuf, selRec.lnFirst);

//Msg("@curLen@;@selRec@");

if(selRec.ichFirst == 0)

{

   if(selRec.lnFirst == 0)

    stop;

   selRec.lnFirst = selRec.lnFirst - 1;

   selRec.ichFirst = GetBufLineLength(hbuf, selRec.lnFirst)-1;

   SetWndSel(hwnd, selRec);

   if(IsShiftLeftComplexCharacter())

    shiftMoveLeft();

   stop;

}

selRec.ichFirst = selRec.ichFirst-1;

SetWndSel(hwnd, selRec);

}

macro SuperShiftCursorLeft()

{

if(IsComplexCharacter())

   SuperCursorLeft();

shiftMoveLeft();

if(IsShiftLeftComplexCharacter())

   shiftMoveLeft();

}

macro MultiLineComment()  
{  
    hwnd = GetCurrentWnd()  
    selection = GetWndSel(hwnd)  
    LnFirst =GetWndSelLnFirst(hwnd)      //取首行行号  
    LnLast =GetWndSelLnLast(hwnd)      //取末行行号  
    hbuf = GetCurrentBuf()  
    if(GetBufLine(hbuf, 0) =="//magic-number:tph85666031")  
    {  
        stop  
    }  
    Ln = Lnfirst  
    buf = GetBufLine(hbuf, Ln)  
    len = strlen(buf)  
    while(Ln <= Lnlast)   
    {  
        buf = GetBufLine(hbuf, Ln)  //取Ln对应的行  
        if(buf =="")  
        {                   //跳过空行  
            Ln = Ln + 1  
            continue  
        }  
        if(StrMid(buf, 0, 1) == "/")  
        {       //需要取消注释,防止只有单字符的行  
            if(StrMid(buf, 1, 2) == "/")  
            {  
                PutBufLine(hbuf, Ln, StrMid(buf, 2, Strlen(buf)))  
            }  
        }  
        if(StrMid(buf,0,1) !="/")  
        {          //需要添加注释  
            PutBufLine(hbuf, Ln, Cat("//", buf))  
        }  
        Ln = Ln + 1  
    }  
    SetWndSel(hwnd, selection)  
}  


/*---END---*/

