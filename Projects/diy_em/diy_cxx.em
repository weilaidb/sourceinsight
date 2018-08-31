 /* diy.em --  self define useful editing macros, cxx use **/

 
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

macro vectorprint()
{
	selfstr("int main(int argc, char **argv)")
	selfstr("{")
	selfstr("")
	selfstr("    return 0;")
	selfstr("}")
}

