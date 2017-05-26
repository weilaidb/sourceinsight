
/***************************************************************************************
****************************************************************************************
* FILE		: SourceInsight_Comment.em
* Description	: utility to insert comment in Source Insight project
*			  
* Copyright (c) 2007 by Liu Ying. All Rights Reserved.
* 
* History:
* Version		Name       	Date			Description
   0.1		Liu Ying		2006/04/07	Initial Version
   0.2		Liu Ying		2006/04/21	add Ly_InsertHFileBanner
****************************************************************************************
****************************************************************************************/


/*==================================================================
* Function	: InsertFileHeader
* Description	: insert file header
*			  
* Input Para	: none
			  
* Output Para	: none
			  
* Return Value: none
==================================================================*/
macro Ly_InsertFileHeader()
{
	// get aurthor name
	szMyName = getenv(MYNAME)
	if (strlen(szMyName) <= 0)
	{
		szMyName = "XXX"
	}

	// get company name
	szCompanyName = getenv(MYCOMPANY)
	if (strlen(szCompanyName) <= 0)
	{
		szCompanyName = szMyName
	}

	// get time
	szTime = GetSysTime(True)
	Day = szTime.Day
	Month = szTime.Month
	Year = szTime.Year
	if (Day < 10)
	{
		szDay = "0@Day@"
	}
	else
	{
		szDay = Day
	}
	if (Month < 10)
	{
		szMonth = "0@Month@"
	}
	else
	{
		szMonth = Month
	}

	// get file name
	hbuf = GetCurrentBuf()
	szpathName = GetBufName(hbuf)
	szfileName = GetFileName(szpathName)
	nlength = StrLen(szfileName)

	// assemble the string
	hbuf = GetCurrentBuf()
	InsBufLine(hbuf, 0, "")
	InsBufLine(hbuf, 1, "/***************************************************************************************")
	InsBufLine(hbuf, 2, "****************************************************************************************")
	InsBufLine(hbuf, 3, "* FILE		: @szfileName@")
	InsBufLine(hbuf, 4, "* Description	: ")
	InsBufLine(hbuf, 5, "*			  ")
	InsBufLine(hbuf, 6, "* Copyright (c) @Year@ by @szCompanyName@. All Rights Reserved.")
	InsBufLine(hbuf, 7, "* ")
	InsBufLine(hbuf, 8, "* History:")
	InsBufLine(hbuf, 9, "* Version		Name       		Date			Description")
	InsBufLine(hbuf, 10, "   0.1		@szMyName@	@Year@/@szMonth@/@szDay@	Initial Version")
	InsBufLine(hbuf, 11, "   ")
	InsBufLine(hbuf, 12, "****************************************************************************************")
	InsBufLine(hbuf, 13, "****************************************************************************************/")
	InsBufLine(hbuf, 14, "")
	InsBufLine(hbuf, 15, "")

	// put the insertion point
	SetBufIns(hbuf, 16, 0)
}


/*==================================================================
* Function	: InsertFileHeader
* Description	: insert file header
*			  
* Input Para	: none
			  
* Output Para	: none
			  
* Return Value: none
==================================================================*/
macro Ly_InsertFunctionHeader()
{
	// get function name
	hbuf = GetCurrentBuf()
	szFunc = GetCurSymbol()
	ln = GetSymbolLine(szFunc)

	// assemble the string
	hbuf = GetCurrentBuf()
	InsBufLine(hbuf, ln, "")
	InsBufLine(hbuf, ln+1, "/*==================================================================")
	InsBufLine(hbuf, ln+2, "* Function	: @szFunc@")
	InsBufLine(hbuf, ln+3, "* Description	: ")
	InsBufLine(hbuf, ln+4, "* Input Para	: ")
	InsBufLine(hbuf, ln+5, "* Output Para	: ")
	InsBufLine(hbuf, ln+6, "* Return Value: ")
	InsBufLine(hbuf, ln+7, "==================================================================*/")

	// put the insertion point
	SetBufIns(hbuf, ln+8, 0)
}


/*==================================================================
* Function	: InsertFileHeader
* Description	: insert file header
*			  
* Input Para	: none
			  
* Output Para	: none
			  
* Return Value: none
==================================================================*/
macro Ly_InsertHFileBanner()
{
	// get file name
	hbuf = GetCurrentBuf()
	szpathName = GetBufName(hbuf)
	szfileName = GetFileName(szpathName)
	szfileName = toupper(szfileName)

	// create banner
	banner = "_"
	nlength = strlen(szfileName)
	
	i=0
	while (i < nlength)
	{
		if (szfileName[i] == ".")
		{
			banner = cat(banner, "_")
		}
		else
		{
			banner = cat(banner, szfileName[i])
		}

		i = i+1
	}

	banner = cat(banner, "_")

	// print banner
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	InsBufLine(hbuf, lnFirst, "#ifndef @banner@")
	InsBufLine(hbuf, lnFirst+1, "#define @banner@")
	InsBufLine(hbuf, lnFirst+2, "")
	InsBufLine(hbuf, lnFirst+3, "")
	InsBufLine(hbuf, lnFirst+4, "")
	InsBufLine(hbuf, lnFirst+5, "")
	InsBufLine(hbuf, lnFirst+6, "")
	InsBufLine(hbuf, lnLast+7, "#endif /*@banner@*/")

	SetBufIns(hbuf, lnFirst+4, 0)
}

/*==================================================================
* Function	: GetFileName
* Description	: get file name from path
*			  
* Input Para	: pathName	: path string
			  
* Output Para	: None
			  
* Return Value: name		: file name
==================================================================*/
macro GetFileName(pathName)
{
	nlength = strlen(pathName)
	i = nlength - 1
	name = ""
	while (i + 1)
	{
		ch = pathName[i]
		if ("\\" == "@ch@")
			break
		i = i - 1
	}
	i = i + 1
	while (i < nlength)
	{
		name = cat(name, pathName[i])
		i = i + 1
	}

	return name
}

