/* diy.em --  self define useful editing macros **/

/* 
在source insight中添加多行注释和快速添加#if 0的方法
2017-06-01 13:58 by fanhuanliugang, 813 阅读, 0 评论, 收藏, 编辑
1，添加函数

project-》open project中打开Base，在utils.em文件中添加：MultiLineComment和AddMacroComment函数
*/

macro MultiLineComment()
{

    hwnd = GetCurrentWnd()

    selection = GetWndSel(hwnd)

    LnFirst =GetWndSelLnFirst(hwnd)      //取首行行号

    LnLast =GetWndSelLnLast(hwnd)      //取末行行号

    hbuf = GetCurrentBuf()

 

    if(GetBufLine(hbuf, 0) =="//magic-number:tph85666031"){

        stop

    }

 

    Ln = Lnfirst

    buf = GetBufLine(hbuf, Ln)

    len = strlen(buf)
	tc = GetBufLineCount (hbuf)

 

    while(Ln <= Lnlast) {

        buf = GetBufLine(hbuf, Ln)  //取Ln对应的行

        if(buf ==""){                   //跳过空行

            Ln = Ln + 1

            continue

        }

 

        if(StrMid(buf, 0, 1) == "/"){       //需要取消注释,防止只有单字符的行

            if(StrMid(buf, 1, 2) == "/"){

                PutBufLine(hbuf, Ln, StrMid(buf, 2, Strlen(buf)))

            }

        }

 

        if(StrMid(buf,0,1) !="/"){          //需要添加注释

            PutBufLine(hbuf, Ln, Cat("//", buf))

        }

        Ln = Ln + 1

    }

 
	
    SetWndSel(hwnd, selection)
	// put the insertion point inside the header comment
	setCursor(hbuf, tc, Ln, 0)
}
/** add #if 0 注释 **/
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

			sel.lnFirst = sel.lnFirst – 1

			sel.lnLast = sel.lnLast – 1

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
	selfstr("        ")
	selfstr("        break;")
	selfstr("    case :")
	selfstr("        ")
	selfstr("        break;")
	selfstr("    case :")
	selfstr("        ")
	selfstr("        break;")
	selfstr("    case :")
	selfstr("        ")
	selfstr("        break;")
	selfstr("    case :")
	selfstr("        ")
	selfstr("        break;")
	selfstr("    case :")
	selfstr("        ")
	selfstr("        break;")
	selfstr("    default :")
	selfstr("        break;")
	selfstr("    }")
}


macro ifelseifelse()
{
    selfstr("    if(    )")
    selfstr("    {")
    selfstr("        ")
    selfstr("    }")
    selfstr("    else if (    )")
    selfstr("    {")
    selfstr("        ")
    selfstr("    }")
    selfstr("    else if (    )")
    selfstr("    {")
    selfstr("        ")
    selfstr("    }")
    selfstr("    else if (    )")
    selfstr("    {")
    selfstr("        ")
    selfstr("    }")
    selfstr("    else if (    )")
    selfstr("    {")
    selfstr("        ")
    selfstr("    }")
    selfstr("    else if (    )")
    selfstr("    {")
    selfstr("        ")
    selfstr("    }")
    selfstr("    else")
    selfstr("    {")
    selfstr("        ")
    selfstr("    }")
}

macro ifelse()
{
    selfstr("    if(     )")
    selfstr("    {")
    selfstr("        ")
    selfstr("    }")
    selfstr("    else")
    selfstr("    {")
    selfstr("        ")
    selfstr("    }")
}

macro helps()
{
    selfstr("void help()")
    selfstr("{")
    selfstr("    char tips[] = {")
    selfstr("       \"  \\n\"")
    selfstr("       \"  \\n\"")
    selfstr("       \"  \\n\"")
    selfstr("       \"  \\n\"")
    selfstr("       \"  \\n\"")
    selfstr("       \"  \\n\"")
    selfstr("       \"  \\n\"")
    selfstr("       \"  \\n\"")
    selfstr("       \"  \\n\"")
    selfstr("       \"  \\n\"")
    selfstr("       \"  \\n\"")
    selfstr("       \"  \\n\"")
    selfstr("    };")
    selfstr("    ")
    selfstr("    printf(tips);")
    selfstr("")
    selfstr("}")
}

macro num2str()
{
	selfstr("/* Error codes: informative error codes */")
	selfstr("#define FDT_ERR_NOTFOUND	1")
	selfstr("	/* FDT_ERR_NOTFOUND: The requested node or property does not exist */")
	selfstr("#define FDT_ERR_EXISTS		2")
	selfstr("	/* FDT_ERR_EXISTS: Attempted to create a node or property which")
	selfstr("	 * already exists */")
	selfstr("#define FDT_ERR_NOSPACE		3")
	selfstr("	/* FDT_ERR_NOSPACE: Operation needed to expand the device")
	selfstr("	 * tree, but its buffer did not have sufficient space to")
	selfstr("	 * contain the expanded tree. Use fdt_open_into() to move the")
	selfstr("	 * device tree to a buffer with more space. */")
	selfstr("")
	selfstr("/* Error codes: codes for bad parameters */")
	selfstr("#define FDT_ERR_BADOFFSET	4")
	selfstr("	/* FDT_ERR_BADOFFSET: Function was passed a structure block")
	selfstr("	 * offset which is out-of-bounds, or which points to an")
	selfstr("	 * unsuitable part of the structure for the operation. */")
	selfstr("#define FDT_ERR_BADPATH		5")
	selfstr("	/* FDT_ERR_BADPATH: Function was passed a badly formatted path")
	selfstr("	 * (e.g. missing a leading / for a function which requires an")
	selfstr("	 * absolute path) */")
	selfstr("#define FDT_ERR_BADPHANDLE	6")
	selfstr("	/* FDT_ERR_BADPHANDLE: Function was passed an invalid phandle.")
	selfstr("	 * This can be caused either by an invalid phandle property")
	selfstr("	 * length, or the phandle value was either 0 or -1, which are")
	selfstr("	 * not permitted. */")
	selfstr("#define FDT_ERR_BADSTATE	7")
	selfstr("	/* FDT_ERR_BADSTATE: Function was passed an incomplete device")
	selfstr("	 * tree created by the sequential-write functions, which is")
	selfstr("	 * not sufficiently complete for the requested operation. */")
	selfstr("")
	selfstr("/* Error codes: codes for bad device tree blobs */")
	selfstr("#define FDT_ERR_TRUNCATED	8")
	selfstr("	/* FDT_ERR_TRUNCATED: Structure block of the given device tree")
	selfstr("	 * ends without an FDT_END tag. */")
	selfstr("#define FDT_ERR_BADMAGIC	9")
	selfstr("	/* FDT_ERR_BADMAGIC: Given \"device tree\" appears not to be a")
	selfstr("	 * device tree at all - it is missing the flattened device")
	selfstr("	 * tree magic number. */")
	selfstr("#define FDT_ERR_BADVERSION	10")
	selfstr("	/* FDT_ERR_BADVERSION: Given device tree has a version which")
	selfstr("	 * can't be handled by the requested operation.  For")
	selfstr("	 * read-write functions, this may mean that fdt_open_into() is")
	selfstr("	 * required to convert the tree to the expected version. */")
	selfstr("#define FDT_ERR_BADSTRUCTURE	11")
	selfstr("	/* FDT_ERR_BADSTRUCTURE: Given device tree has a corrupt")
	selfstr("	 * structure block or other serious error (e.g. misnested")
	selfstr("	 * nodes, or subnodes preceding properties). */")
	selfstr("#define FDT_ERR_BADLAYOUT	12")
	selfstr("	/* FDT_ERR_BADLAYOUT: For read-write functions, the given")
	selfstr("	 * device tree has it's sub-blocks in an order that the")
	selfstr("	 * function can't handle (memory reserve map, then structure,")
	selfstr("	 * then strings).  Use fdt_open_into() to reorganize the tree")
	selfstr("	 * into a form suitable for the read-write operations. */")
	selfstr("")
	selfstr("/* \"Can't happen\" error indicating a bug in libfdt */")
	selfstr("#define FDT_ERR_INTERNAL	13")
	selfstr("	/* FDT_ERR_INTERNAL: libfdt has failed an internal assertion.")
	selfstr("	 * Should never be returned, if it is, it indicates a bug in")
	selfstr("	 * libfdt itself. */")
	selfstr("")
	selfstr("/* Errors in device tree content */")
	selfstr("#define FDT_ERR_BADNCELLS	14")
	selfstr("	/* FDT_ERR_BADNCELLS: Device tree has a #address-cells, #size-cells")
	selfstr("	 * or similar property with a bad format or value */")
	selfstr("")
	selfstr("#define FDT_ERR_BADVALUE	15")
	selfstr("	/* FDT_ERR_BADVALUE: Device tree has a property with an unexpected")
	selfstr("	 * value. For example: a property expected to contain a string list")
	selfstr("	 * is not NUL-terminated within the length of its value. */")
	selfstr("")
	selfstr("#define FDT_ERR_BADOVERLAY	16")
	selfstr("	/* FDT_ERR_BADOVERLAY: The device tree overlay, while")
	selfstr("	 * correctly structured, cannot be applied due to some")
	selfstr("	 * unexpected or missing value, property or node. */")
	selfstr("")
	selfstr("#define FDT_ERR_NOPHANDLES	17")
	selfstr("	/* FDT_ERR_NOPHANDLES: The device tree doesn't have any")
	selfstr("	 * phandle available anymore without causing an overflow */")
	selfstr("")
	selfstr("#define FDT_ERR_MAX		17")
	selfstr("")
	selfstr("")
	selfstr("struct fdt_errtabent {")
	selfstr("	const char *str;")
	selfstr("};")
	selfstr("")
	selfstr("#define FDT_ERRTABENT(val) \\")
	selfstr("	[(val)] = { .str = #val, }")
	selfstr("")
	selfstr("static struct fdt_errtabent fdt_errtable[] = {")
	selfstr("	FDT_ERRTABENT(FDT_ERR_NOTFOUND),")
	selfstr("	FDT_ERRTABENT(FDT_ERR_EXISTS),")
	selfstr("	FDT_ERRTABENT(FDT_ERR_NOSPACE),")
	selfstr("")
	selfstr("	FDT_ERRTABENT(FDT_ERR_BADOFFSET),")
	selfstr("	FDT_ERRTABENT(FDT_ERR_BADPATH),")
	selfstr("	FDT_ERRTABENT(FDT_ERR_BADPHANDLE),")
	selfstr("	FDT_ERRTABENT(FDT_ERR_BADSTATE),")
	selfstr("")
	selfstr("	FDT_ERRTABENT(FDT_ERR_TRUNCATED),")
	selfstr("	FDT_ERRTABENT(FDT_ERR_BADMAGIC),")
	selfstr("	FDT_ERRTABENT(FDT_ERR_BADVERSION),")
	selfstr("	FDT_ERRTABENT(FDT_ERR_BADSTRUCTURE),")
	selfstr("	FDT_ERRTABENT(FDT_ERR_BADLAYOUT),")
	selfstr("	FDT_ERRTABENT(FDT_ERR_INTERNAL),")
	selfstr("	FDT_ERRTABENT(FDT_ERR_BADNCELLS),")
	selfstr("	FDT_ERRTABENT(FDT_ERR_BADVALUE),")
	selfstr("	FDT_ERRTABENT(FDT_ERR_BADOVERLAY),")
	selfstr("	FDT_ERRTABENT(FDT_ERR_NOPHANDLES),")
	selfstr("};")
	selfstr("#define FDT_ERRTABSIZE	(sizeof(fdt_errtable) / sizeof(fdt_errtable[0]))")
	selfstr("")
	selfstr("const char *fdt_strerror(int errval)")
	selfstr("{")
	selfstr("	if (errval > 0)")
	selfstr("		return \"<valid offset/length>\";")
	selfstr("	else if (errval == 0)")
	selfstr("		return \"<no error>\";")
	selfstr("	else if (errval > -FDT_ERRTABSIZE) {")
	selfstr("		const char *s = fdt_errtable[-errval].str;")
	selfstr("")
	selfstr("		if (s)")
	selfstr("			return s;")
	selfstr("	}")
	selfstr("")
	selfstr("	return \"<unknown error>\";")
	selfstr("}")
	selfstr("")
}
