/* diy.em --  self define useful editing macros **/

/* 
��source insight����Ӷ���ע�ͺͿ������#if 0�ķ���
2017-06-01 13:58 by fanhuanliugang, 813 �Ķ�, 0 ����, �ղ�, �༭
1����Ӻ���

project-��open project�д�Base����utils.em�ļ�����ӣ�MultiLineComment��AddMacroComment����
*/

macro MultiLineComment()
{

    hwnd = GetCurrentWnd()

    selection = GetWndSel(hwnd)

    LnFirst =GetWndSelLnFirst(hwnd)      //ȡ�����к�

    LnLast =GetWndSelLnLast(hwnd)      //ȡĩ���к�

    hbuf = GetCurrentBuf()

 

    if(GetBufLine(hbuf, 0) =="//magic-number:tph85666031"){

        stop

    }

 

    Ln = Lnfirst

    buf = GetBufLine(hbuf, Ln)

    len = strlen(buf)
	tc = GetBufLineCount (hbuf)

 

    while(Ln <= Lnlast) {

        buf = GetBufLine(hbuf, Ln)  //ȡLn��Ӧ����

        if(buf ==""){                   //��������

            Ln = Ln + 1

            continue

        }

 

        if(StrMid(buf, 0, 1) == "/"){       //��Ҫȡ��ע��,��ֹֻ�е��ַ�����

            if(StrMid(buf, 1, 2) == "/"){

                PutBufLine(hbuf, Ln, StrMid(buf, 2, Strlen(buf)))

            }

        }

 

        if(StrMid(buf,0,1) !="/"){          //��Ҫ���ע��

            PutBufLine(hbuf, Ln, Cat("//", buf))

        }

        Ln = Ln + 1

    }

 
	
    SetWndSel(hwnd, selection)
	// put the insertion point inside the header comment
	setCursor(hbuf, tc, Ln, 0)
}
/** add #if 0 ע�� **/
macro AddMacroComment()
{

	hwnd=GetCurrentWnd()

	sel=GetWndSel(hwnd)

	lnFirst=GetWndSelLnFirst(hwnd)

	lnLast=GetWndSelLnLast(hwnd)

	hbuf=GetCurrentBuf()



	if (LnFirst == 0) {

			szIfStart = ""

	} else {

			szIfStart = GetBufLine(hbuf, LnFirst-1)

	}

	szIfEnd = GetBufLine(hbuf, lnLast+1)

	if (szIfStart == "#if 0" && szIfEnd =="#endif") {

			DelBufLine(hbuf, lnLast+1)

			DelBufLine(hbuf, lnFirst-1)

			sel.lnFirst = sel.lnFirst �C 1

			sel.lnLast = sel.lnLast �C 1

	} else {

			InsBufLine(hbuf, lnFirst, "#if 0")

			InsBufLine(hbuf, lnLast+2, "#endif")

			sel.lnFirst = sel.lnFirst + 1

			sel.lnLast = sel.lnLast + 1

	}

}
/** set current cursor position **/
macro setCursor(hbuf, tc, Ln,pos)
{
	// put the insertion point inside the header comment
	if(Ln == tc && tc != 0)
		SetBufIns(hbuf, Ln - 1, pos)
	else
		SetBufIns(hbuf, Ln, pos)
}

/** set strings and move cursor to next line **/
macro selfstr(sz)
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf() // get current buffer handle
	ln = GetBufLnCur (hbuf) //current line

	//InsBufLine(hbuf, lnFirst, "@sz@")
	//InsBufLine(hbuf, lnLast+1, "")
	
	InsBufLine(hbuf, ln, "@sz@")
	// put the insertion point inside the header comment
	setCursor(hbuf,0, ln+1, 0);
}


macro cmain()
{
	selfstr("int main(int argc, char **argv)")
	selfstr("{")
	selfstr("")
	selfstr("    return 0;")
	selfstr("}")
}

macro forloop()
{
	selfstr("    int i = 0;")
	selfstr("    for(i = 0;i < 10; i++)")
	selfstr("    {")
	selfstr("        ")
	selfstr("    }")
}

macro switchcase()
{
	selfstr("    switch ( )")
	selfstr("    {")
	selfstr("    case :")
	selfstr("        break;")
	selfstr("    default :")
	selfstr("        break;")
	selfstr("    }")
}


macro ifelseifelse()
{
    selfstr("   if(     )")
    selfstr("   {")
    selfstr("       ")
    selfstr("   }")
    selfstr("   else if (       )")
    selfstr("   {")
    selfstr("       ")
    selfstr("   }")
    selfstr("   else")
    selfstr("   {")
    selfstr("       ")
    selfstr("   }")
}

macro ifelse()
{
    selfstr("   if(     )")
    selfstr("   {")
    selfstr("       ")
    selfstr("   }")
    selfstr("   else")
    selfstr("   {")
    selfstr("       ")
    selfstr("   }")
}


