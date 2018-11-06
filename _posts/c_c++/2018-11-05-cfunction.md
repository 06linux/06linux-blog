---
layout: post
title:  "C语言工具函数封装"
date:   2018-11-05 19:50:18 +0800
categories: c_c++
tags: 源码 C BaseUtil
---

* content
{:toc}


## C Function

当初学习 C语言的时候，做的一些练习。分享出来纪念一下



### strlen 

{% highlight c++ %}

	/*
	*    计算字符串的长度
	*/
	int strlen(const char* str)
	{
	    assert( str != NULL);
	    int len = 0;
	    while( *str++ != '\0')
	    {
	        len++;
	    }
	    
	    return len;
	}

{% endhighlight %}




### strcpy 

{% highlight c++ %}

	/*
	*        字符串复制函数
	*/
	char * strcpy(char* strDest, const char* strSrc)
	{
	    assert( (strDest != NULL) && (strSrc != NULL) );
	    char* address = strDest; //保存首地址

	    
	    while( (*strDest++ = *strSrc++) != '\0' )
	    {
	        ; // do nothing

	    }
	    
	    return address;
	}


{% endhighlight %}





### ConversionString 

{% highlight c++ %}

	/*
	*    定义函数 char * ConversionString(char* _pDest, const char * _pSrc, int _nFlag);
	*    表头文件 #include 
	*    函数描述    字符串大小写转换函数。
	*                        此函数从第一个字符开始转换，遇到字符串结束时('\0')才结束转换。
	*                        _pSrc 要转换的字符串首地址
	*                        _pDest 转换后的字符串首地址, _pDest要有足够的空间来容纳转换后的字符串
	                        _nFlag = 0, 大写转小写，小写转大写，其他字符不变
	                        _nFlag = 1, 全部转换为小写，其他字符不变
	                        _nFlag = 2 , 全部转换为大写，其他字符不变
	                        _nFlag 取其他值是，函数返回 NULL
	*     返回值 成功，返回 _pDest 的字符串起始地址。错误，返回NULL
	*        作 者 武立强
	*        时    间    2009-02-05
	*/
	char * ConversionString(char* _pDest, const char * _pSrc, int _nFlag)
	{
	    assert( NULL != _pSrc && NULL != _pDest );
	    char * pFirst = _pDest;
	    
	    if( 0 != _nFlag || 1 != _nFlag && 2 != _nFlag )
	    {
	        return NULL;
	    }
	        
	    while( '\0' != *_pSrc )
	    {
	        if( *_pSrc >= 'a' && *_pSrc <= 'z' && 0 == _nFlag )
	        {
	            *_pDest++ = *_pSrc++ - 32;
	        }
	        else if( *_pSrc >= 'A' && *_pSrc <= 'Z' && 0 == _nFlag )
	        {
	             *_pDest++ = *_pSrc++ + 32;
	        }
	        else if( *_pSrc >= 'A' && *_pSrc <= 'Z' && 1 == _nFlag )
	        {
	             *_pDest++ = *_pSrc++ + 32;
	        }
	        else if( *_pSrc >= 'a' && *_pSrc <= 'z' && 2 == _nFlag )
	        {
	            *_pDest++ = *_pSrc++ - 32;
	        }
	        else
	        {
	            *_pDest++ = *_pSrc++;
	        }
	    }
	    _pDest = NULL;
	    _pSrc = NULL;
	    return pFirst;
	}

{% endhighlight %}



### CharToInt 

{% highlight c++ %}

	/*
	*    函数原形    int CharToInt(const char* _pStr);
	*    表头文件    #include 
	*    函数描述    将字符串转换为整数，_pStr串中不能有 '+'、'-' 和 '.'，不支持小数和负数，
	*                        此函数从第一个字符开始转换，遇到非数字或字符串结束时('\0')才结束转换，并将结果返回。
	*        参 数    _pStr，要转换为整数的字符串，只能是由'0' 到'9'之间的字符组成的字符串。
	*     返回值    成功，返回转换后的整数。
	*                        失败，返回 -1
	*        作 者    武立强
	*        时    间    2009-02-18
	*        备 注    _pStr 字符串中的空格可以被过滤掉，_pStr中可以存在空格, 当您传入"" 或 " " 时，
	*                        函数将返回 0
	*/
	int CharToInt(const char* _pStr)
	{
	    assert( NULL != _pStr );

	    int nNumber = 0;

	    while( '\0' != *_pStr )
	    {
	        if( ' ' == *_pStr )
	        { 
	            // 过滤空格字符

	        }
	        else if( *_pStr < '0' || *_pStr > '9')
	        {
	            // 如果遇到非'0'--'9' 之间的字符,直接返回

	            return (-1);
	        }
	        else
	        {
	            nNumber = nNumber*10 + (*_pStr -48);
	        }
	        _pStr++;
	    }

	    return nNumber;
	}

	

{% endhighlight %}


### CharToDouble 

{% highlight c++ %}

	/*
	*    定义函数 double CharToDouble(const char* str);
	*    表头文件 #include 
	*    函数描述    将字符串转换成数字，支持整数、小数、正数、负数。此函数从第一个字符
	*                        开始转换，遇到非数字或字符串结束时('\0')才结束转换，并将结果返回。
	*                        参数str字符串可包含正负号（必须是第一个字符）、小数点。
	*     返回值 返回转换后的双精度浮点型数。
	*        作 者 武立强
	*        时    间    2009-02-05
	*        注    意    double 有精度问题
	*/
	double CharToDouble(const char* str)
	{
	    assert( NULL != str );

	    int nFlag = 0; // 是否有小数点存在, 0--不存在,1--存在

	    int nPositive = 1; //是否是正数, 0---负数, 1---正数

	    int nLen = 0; 
	    int nPlace = 0; // 小数点位置

	    double ldNum = 0;

	    // 判断第一个字符

	    if( '+' == *str )
	    {
	        nPositive = 1;
	        str++;
	    }
	    else if( '-' == *str )
	    {
	        nPositive = 0;
	        str++;
	    }
	    
	    while( '\0' != *str )
	    {
	        // 检查是否小数点重复

	        if( '.' == *str && 1 == nFlag )
	        {
	            break;
	        }
	        // 检查是存在否小数点

	        else if( '.' == *str )
	        {
	            nFlag = 1;
	            nPlace = nLen + 1;
	        }
	        else if( *str > '9' || *str < '0' )
	        {
	            break;
	        }
	        else
	        {
	            // (*str - 48)字符'0'转为数字0

	            ldNum = ldNum*10 + (*str - 48); 
	        }
	        nLen++;
	        str++;
	    }

	    if(nFlag)
	    {
	        int nTemp = 1;
	        for(int i=0; i<(nLen - nPlace); i++)
	        {
	            nTemp = nTemp * 10;
	        }
	        ldNum = ldNum / nTemp;
	    }

	    return ((nPositive == 1) ? ldNum : (-ldNum));
	}


{% endhighlight %}



### Input 

{% highlight c++ %}

	/*
	*    用一个函数给数组赋值
	*/
	void Input(int a[], int length)
	{
	    for(int i=0; i<length; i++)
	    {
	        scanf("%d", &a[i]);
	    }
	}
	

{% endhighlight %}



### IntToChar 

{% highlight c++ %}

	/*
	*    定义函数 char * IntToChar(char* pDestStr, int nSrcNum);
	*    表头文件 #include 
	*    函数描述    将整型数字转换为字符串,(正负数都可以)，pDestStr 要有足够的空间来
	*                        容纳转换后的字符串。
	*     返回值     成功:返回转换后的字符串     失败:返回NULL        
	*        作 者 武立强
	*        时    间    2009-02-06
	*        注    意    时刻注意指针现在指到那里了，malloc() 和free()的个数一定要相同
	*                        千万小心内存泄露，和野指针的出现。
	*/
	char * IntToChar(char* pDestStr, int nSrcNum)
	{
	    assert( NULL != pDestStr );
	    
	    int nTemp = 0;    //存储一个位的数字

	    int nPlace = 0;    //存储小数点的位置

	    int nNegative = 0;    // 1--负数, 0---非负数

	    char* pTemp = NULL; 
	    char* pFirst = NULL; 
	    int nLen = 0; // 转换后字符串的长度


	    pTemp =(char*)malloc( sizeof(char)*100 );
	    if(NULL == pTemp)
	    {
	        return NULL;
	    }
	    memset(pTemp, '\0', 100);
	    pFirst = pTemp;

	    // 判断是否是负数 

	    if(nSrcNum < 0)
	    {
	        nSrcNum = -nSrcNum;
	        nNegative = 1;
	    }

	    // 当循环结束后,nTemp 指向字符串的最后!

	    while( nSrcNum >= 10)
	    {
	        nTemp = nSrcNum % 10;
	        *pTemp = nTemp + 48;    // nTemp + 48 数字转成字符

	        nSrcNum = nSrcNum / 10; // 两个正数相除,结果取整

	        pTemp++;
	    }
	     *pTemp = nSrcNum + 48; 

	    if(nNegative)
	    {
	        *(++pTemp) = '-';
	    }
	    

	    nLen = strlen(pFirst);
	    pFirst = pDestStr;

	    //字符串反转

	    for(int i=0; i<nLen; i++)
	    {
	        *pDestStr++ = *pTemp--;
	    }
	    pTemp++; // 指向字符串开始

	    *pDestStr = '\0'; // 字符串结束, 切记!


	    // 释放分配在堆上的内存.

	    free(pTemp);
	    pTemp = NULL;
	    pDestStr = NULL;

	    return pFirst;
	}

	

{% endhighlight %}



### DoubleToChar 

{% highlight c++ %}

	/*
	*    定义函数 char * DoubleToChar(char* pDestStr, double dSrcNum);
	*    表头文件 #include 
	*    函数描述    将浮点型数字转换为字符串,(正负数都可以)，pDestStr 要有足够的空间来
	*                        容纳转换后的字符串。double 保存16位有效数字,小数点以后最多15位
	*     返回值     成功:返回转换后的字符串     失败:返回NULL
	*        作 者 武立强
	*        时    间    2009-02-07        
	*        注    意    转换后,小数后最后一位,值不确定 
	*                        时刻注意指针现在指到那里了，malloc() 和free()的个数一定要相同
	*                        千万小心内存泄露,和野指针的出现。
	*/
	char * DoubleToChar(char* pDestStr, double dSrcNum)
	{
	    assert( NULL != pDestStr );
	    
	    const double EXPIOSE = 0.0000001;

	    int nTemp = 0; //存储一个位的数字

	    int nLen = 0; // 字符串的长度

	    int nNegative = 0; // 1--负数, 0---非负数

	    double dPointRight = 0; //小数点后边的数


	    char* pTemp = NULL; 
	    char* pFirst = NULL; 

	    pTemp =(char*)malloc( sizeof(char)*20 );
	    if(NULL == pTemp)
	    {
	        return NULL;
	    }
	    memset(pTemp, '\0', 20);
	    pFirst = pTemp;

	    // 判断正负数

	    if( dSrcNum < 0 )
	    {
	        nNegative = 1;
	        dSrcNum = 0 - dSrcNum;
	    }
	    dPointRight = dSrcNum - (int)dSrcNum; // 得到小数点后的数据


	    // 整数位处理

	    while( (int)dSrcNum >= 10 )
	    {
	        nTemp = (int)dSrcNum % 10;
	        *pTemp++ = nTemp + 48;    // nTemp + 48 数字转成字符

	        dSrcNum = (int)dSrcNum / 10; // 两个正数相除,结果取整

	    }
	  *pTemp++ = (char)(dSrcNum + 48); 
	    *pTemp = '\0';
	    nLen = strlen(pFirst);
	    pFirst = pDestStr;

	    if(nNegative)
	    {
	        *pDestStr++ = '-';
	    }

	    //字符串反转

	    pTemp--;
	    for(int i=0; i<nLen; i++)
	    {
	        *pDestStr++ = *pTemp--;
	    }
	    pTemp++; // 指向字符串开始

	    free(pTemp);
	    pTemp = NULL;

	    // 小数点处理

	    *pDestStr++ = '.';
	    
	    // 小数位处理，double 最多保存小数点后15位.(有效数字是16)

	    for(i=0; i<16-nLen; i++)
	    {
	        // double 数据有精度问题,最后一位数的四舍五入问题。

	        if( (dPointRight >= -EXPIOSE && dPointRight <= EXPIOSE) || (dPointRight-1 >= -EXPIOSE && dPointRight-1 <= EXPIOSE) )
	        {
	            break;
	        }
	        *pDestStr++ = (int)(dPointRight*10) + 48; 
	        dPointRight = (dPointRight*10) - (int)(dPointRight*10); // 得到小数点后的数据

	    }
	    
	    // 保证小数点后边至少一个 '0'

	    if( 0 == i)
	    {
	        *pDestStr++ = '0';
	        *pDestStr = '\0'; // 字符串结束, 切记!

	    }
	    else
	    {
	        *pDestStr = '\0'; // 字符串结束, 切记!

	    }

	    pDestStr = NULL;
	    return pFirst;
	}
	

{% endhighlight %}



### CharToIp 

{% highlight c++ %}

	/*
	*    函数原形    int CharToIp(const char* _pchIP);
	*    表头文件    #include 
	*                        #include
	*                        #include
	*    函数描述    将字符串形式表示的 IP 转换为一个整数。
	*        参 数    _pchIP, 要转换的IP字符串, 格式要严格按照 "192.168.0.1" 格式，
	*                        且字符串取值必须在 "0.0.0.0"(最小) 和 "255.255.255.255"(最大)之间。 
	*     返回值    返回转换后的整数形式。
	*        作 者    武立强
	*        时    间    2009-02-20
	*        备 注    
	*/
	int CharToIp(const char* _pchIP)
	{
	    assert( NULL != _pchIP );
	    
	    char szTemp[4][4];        // 用一个二维数组,分别保存字符串中以点分割的子串

	    int nLen = strlen(_pchIP);
	    int nRow = 0; //行下标 

	    int nCol = 0;    // 列下标


	    for(int i=0; i<nLen; i++)
	    {
	        if( '.' == _pchIP[i] )
	        {
	            szTemp[nRow][nCol] = '\0';
	            nRow++;
	            nCol = 0;
	        }
	        else
	        {
	            szTemp[nRow][nCol++] = _pchIP[i];
	        }
	    }
	    szTemp[nRow][nCol] = '\0'; // 别忘了最后的 '\0'


	    return ( (atoi(szTemp[0]) << 24) + (atoi(szTemp[1]) << 16) + (atoi(szTemp[2]) << 8) +atoi(szTemp[3]) ); 
	}


{% endhighlight %}


### IpToChar 

{% highlight c++ %}

	/*
	*    函数原形    char * IpToChar(const int nIP, char * _pchStrIP);
	*    表头文件    #include 
	*                        #include
	*                        #include
	*    函数描述    将一个整数转换为一个IP字符串。
	*        参 数    nIP,要转换的整数。
	*                        _pchStrIP, 存放转换后的IP 字符串。 
	*     返回值    返回转换后的IP字符串的首地址。
	*        作 者    武立强
	*        时    间    2009-02-20
	*        备 注    
	*/
	char * IpToChar(const int nIP, char * _pchStrIP)
	{
	    assert( NULL != _pchStrIP );

	    char szTemp[4] = "";
	    int nLen = 0;

	    for(int i=0; i<4 ; i++)
	    {
	        itoa( ((nIP >> (3-i)*8) & 0x000000FF), szTemp, 10);        // 将十进制整形转换为字符串

	        strcat(_pchStrIP, szTemp);
	        strcat(_pchStrIP, ".");
	    }
	    nLen = strlen(_pchStrIP);
	    _pchStrIP[nLen - 1] = '\0';        // 别忘了 '\0', 将最后一个多余的 '.' 用 '\0' 覆盖

	    
	    return _pchStrIP;
	}

{% endhighlight %}



### GetPassword 

{% highlight c++ %}

	/*
	*    定义函数 char * GetPassword(char* _pPassword, int _nLen, char _chShow);
	*    表头文件 #include 
	*                        #include 
	*    函数描述    密码读取函数，从终端度取密码。
	*                        _pPassword 要有足够的空间来容纳读取的密码。
	*                        _nLen 限制密码的最大长度
	*                        _chShow 为输入密码后回显的字符。值为 0 时不回显。
	*     返回值     返回 _pPassword 的字符串起始地址。     
	*        作 者 武立强
	*        时    间    2009-02-08
	*        注    意    \b Backspace \n Newline \r Carriage return 
	*                        getch() 读取一个字符,不回显.
	*                        特殊字符还没有被过滤掉！
	*/
	char * GetPassword(char* _pPassword, int _nLen, char _chShow)
	{
	    assert( NULL != _pPassword );

	    int nCourrent = 0;
	    char * pFirst = _pPassword;

	    while(1)
	    {
	        *_pPassword = getch();
	        
	        if( '\n' == *_pPassword || '\r' == *_pPassword )
	        {    
	            *_pPassword = '\0';
	            break;
	        }
	        else if( '\b' == *_pPassword && 0 == nCourrent )
	        {
	            continue;        
	        }
	        else if( '\b' == *_pPassword && 0 == _chShow )
	        {
	            _pPassword--;
	            nCourrent--;
	            continue;
	        }
	        else if( '\b' == *_pPassword )
	        {
	            _pPassword--;
	            nCourrent--;
	            printf("\b \b"); // 注意细节,中间有个空格

	            continue;
	        }
	        else if( nCourrent >= _nLen )
	        {
	            continue;    
	        }
	    
	        // 是否回显

	        if( 0 != _chShow )
	        {
	            printf("%c", _chShow);
	        }    
	        _pPassword++;
	        nCourrent++;
	    }
	    _pPassword = NULL;

	    return pFirst;
	}
	

{% endhighlight %}


### GetInput 

{% highlight c++ %}

	/*
	*    函数原形    char * GetInput(char* _pchInput, int _nLen, int _nShow);
	*    表头文件    #include 
	*                        #include 
	*    函数描述    用户输入读取函数，从终端读取用户的输入。
	*        参 数    _pchInput，存放读取的用户输入,要有足够的空间来容纳用户输入
	*                        _nLen，限制用户输入的最大长度
	*                        _nShow，标识是否回显，0--不回显， 1--回显输入
	*     返回值    成功，返回 _pchInput 的字符串起始地址。     
	*        作 者    武立强
	*        时    间    2009-02-18
	*        注    意    \b Backspace \n Newline \r Carriage return 
	*                        getch()从终端读取一个字符,不回显.
	*/
	char * GetInput(char* _pchInput, int _nLen, int _nShow)
	{
	    assert( NULL != _pchInput );

	    int nCourrent = 0;
	    char* pFirst = _pchInput;

	    while(1)
	    {
	        *_pchInput = getch();
	        
	        if( '\n' == *_pchInput || '\r' == *_pchInput )
	        {    
	            *_pchInput = '\0';
	            break;
	        }
	        else if( '\b' == *_pchInput && 0 == nCourrent )
	        {
	            continue;        
	        }
	        else if( '\b' == *_pchInput && 0 == _nShow )
	        {
	            _pchInput--;
	            nCourrent--;
	            continue;
	        }
	        else if( '\b' == *_pchInput )
	        {
	            _pchInput--;
	            nCourrent--;
	            printf("\b \b"); // 注意细节,中间有个空格

	            continue;
	        }
	        else if( nCourrent >= _nLen )
	        {
	            continue;    
	        }
	    
	        // 是否回显

	        if( 0 != _nShow )
	        {
	            printf("%c", *_pchInput);
	        }    
	        _pchInput++;
	        nCourrent++;
	    }
	    _pchInput = NULL;

	    return pFirst;
	}
	

{% endhighlight %}



### StringFilter 

{% highlight c++ %}

	/*
	*    函数原形    char * StringFilter(char * pStr, const char ch);
	*    表头文件    #include 
	*    函数描述    字符串过滤，直接修改原串! 将字符串 pStr 中所有的 ch字符过滤掉。
	*                        用于对单个字符的过滤，效率很高。
	*        参 数    pStr，要过滤的字符串。
	*                        ch，要过滤掉的字符。
	*     返回值    成功，返回过滤后字符串 pStr 的首地址。
	*        作 者    武立强
	*        时    间    2009-02-17
	*        备 注    StringFilter(pStr, ' '); ---用于过滤所有空格,很经典!
	*/
	char * StringFilter(char * pStr, char ch)
	{
	    assert( NULL != pStr );
	    
	    char * pStrFirst = pStr;
	    int nCount = 0;

	    // 自己偶尔发现的一个算法,很经典!

	    while( '\0' != *pStr )
	    {
	        if( ch == *pStr )
	        {
	            nCount++;
	        }
	        else
	        {    
	            *(pStr - nCount) = *pStr; // 向前移动

	        }
	        pStr++;
	    }

	    *(pStr - nCount) = '\0'; // 别忘了结束


	    return pStrFirst;
	}

	

{% endhighlight %}



### StringReplace 

{% highlight c++ %}

	/*
	*    定义函数 char * StringReplace(char* _pDest, const char* _pSrc, const char* _pKey, const char* _pReplace);
	*    表头文件 #include 
	*    函数描述    字符串替换函数, 在字符串 _pSrc 中查找 _pKey 串,并将其替换成 _pReplace 串, 将结果保存在_pDest中
	*                        _pSrc 要查找的原串
	*                        _pKey 要查找的关键串
	*                        _pReplace 要替换的内容
	*                        _pDest 保存处理后的字符串,要有足够的空间来容纳处理后的字符串
	*                        
	*     返回值     返回 _pDest    的字符串起始地址。
	*        作 者 武立强
	*        时    间    2009-02-08
	*        注    意    就两种情况,--匹配成功,---匹配失败
	*                        StringReplace(strDest, strSrc, " ", ""); ---实现过滤字符串空格的作用
	*/
	char * StringReplace(char* _pDest, const char* _pSrc, const char* _pKey, const char* _pReplace)
	{
	    assert( NULL != _pDest && NULL != _pSrc && NULL != _pKey && NULL != _pReplace );
	    
	    // const char * 不能通过指针改变所指向的字符串的值 

	    const char* pKeyFirst = NULL;
	    const char* pFirstFind = NULL; // 标记找到的第一个字符的位置

	    const char* pLastFind = NULL;    //标记找到的最后一个字符的位置

	    const char* pReplaceFirst = NULL;
	    char* pDestFirst = NULL;

	    int nFirstFind = 0 ; //第一个字符是否找到, 0--没找到, 1--找到 

	    int nLastFind = 0;    // 最后一个字符

	    
	    pKeyFirst = _pKey;
	    pReplaceFirst = _pReplace; 
	    pDestFirst = _pDest;

	    while( '\0' != *_pSrc )
	    {
	        // 逻辑比较部分, 确保完全匹配查找关键串 

	        if( 0 == nFirstFind && *_pSrc == *_pKey )
	        {
	            nFirstFind = 1;
	            pFirstFind = _pSrc;
	            _pKey++;
	        }
	        // 匹配成功

	        else if( 1 == nFirstFind && *_pSrc == *_pKey && '\0' == *(_pKey+1) )
	        {
	            nLastFind = 1;
	            pLastFind = _pSrc;
	            _pKey = pKeyFirst;
	        }
	        else if( 1 == nFirstFind && *_pSrc == *_pKey )
	        {
	            _pKey++;
	        }    
	        // 部分匹配,查找失败,要进行补救----- 将第一个字符移过去,从第二个字符开始从新匹配.

	        else if( 1 == nFirstFind && *_pSrc != *_pKey )
	        {    
	            *_pDest++ = *pFirstFind++;
	            _pSrc = pFirstFind;
	            nFirstFind = 0;
	            pFirstFind = NULL;
	            _pKey = pKeyFirst;
	        }
	                
	        // 找到,替换为目标串

	        if( 1 == nFirstFind && 1 == nLastFind )
	        {
	            while( '\0' != *_pReplace )
	            {
	                *_pDest++ = *_pReplace++;
	            }

	            nFirstFind = 0;
	            nLastFind = 0;
	            _pReplace = pReplaceFirst;
	            _pKey = pKeyFirst;
	        }
	        // 没找到

	        else if( 0 == nFirstFind && 0 == nLastFind )
	        {
	            *_pDest = *_pSrc;
	            _pDest++;
	        }
	        // 针对一个字符替换为另一个字符的情况

	        else if( 1 == nFirstFind && '\0' == *(_pKey) )
	        {
	            while( '\0' != *_pReplace )
	            {
	                *_pDest++ = *_pReplace++;
	            }

	            nFirstFind = 0;
	            nLastFind = 0;
	            _pReplace = pReplaceFirst;
	            _pKey = pKeyFirst;
	        }
	        // 最后一次循环了,还没完成---匹配失败

	        else if( 1 == nFirstFind && 0 == nLastFind && '\0' == *(_pSrc + 1) )
	        {
	            for(int i=0; i<=(_pSrc - pFirstFind+1); i++ )
	            {
	                *_pDest++ = *pFirstFind++;
	            }
	            nFirstFind = 0;
	            pFirstFind = NULL;
	            _pKey = pKeyFirst;
	        }
	    
	        _pSrc++;
	    }
	    *_pDest = '\0';

	    return pDestFirst;
	}

{% endhighlight %}



### StringFind 

{% highlight c++ %}

	/*
	*    定义函数 char * StringFind(char* _pSrc, const char* _pKey);
	*    表头文件 #include 
	*    函数描述    从字符串 _PSrc 中查找 _Pkey, 如果找到,返回第一个找到的地址,
	*                        如过没有找到,返回NULL。
	*                        _pSrc 要查找的原串
	*                        _pKey 要查找的关键串
	*     返回值     成功，返回第一个找到的字首地址。没有找到，返回NULL。
	*        作 者 武立强
	*        时    间    2009-02-09
	*/
	char * StringFind(char* _pSrc, const char* _pKey)
	{
	    assert( NULL != _pSrc && NULL != _pKey );

	    int nFirstFind = 0 ; //第一个字符是否找到, 0--没找到, 1--找到 

	    int nLastFind = 0;    // 最后一个字符

	    char* pFirstFind = NULL; // 标记找到的第一个字符的位置

	    const char* pKeyFirst = _pKey;

	    while( '\0' != *_pSrc )
	    {
	        // 逻辑比较部分, 确保完全匹配查找关键串 

	        if( 0 == nFirstFind && *_pSrc == *_pKey )
	        {
	            nFirstFind = 1;
	            pFirstFind = _pSrc;
	            _pKey++;
	        }
	        // 匹配成功

	        else if( 1 == nFirstFind && *_pSrc == *_pKey && '\0' == *(_pKey+1) )
	        {
	            return pFirstFind;
	        }
	        else if( 1 == nFirstFind && *_pSrc == *_pKey )
	        {
	            _pKey++;
	        }    
	        // 部分匹配,匹配失败

	        else if( 1 == nFirstFind && *_pSrc != *_pKey )
	        {    
	            nFirstFind = 0;
	            pFirstFind = NULL;
	            _pKey = pKeyFirst;
	        }

	        // 针对一个字符的情况

	        if( 1 == nFirstFind && '\0' == *(_pKey) )
	        {
	            return pFirstFind;
	        }
	        _pSrc++;
	    }

	    return NULL;
	}

{% endhighlight %}



### PrintKeyValue 

{% highlight c++ %}

	/*
	*    定义函数 char * PrintKeyValue(char* _pchDest, const char* _pchSrc, const char* _pchKey);
	*    表头文件 #include 
	*    函数描述    固定格式字符串解析函数。
	*                        字符串的格式："@ID:123456\n@TITLE:nba\n@DATE:2009-01-02\n@AUTHOR:zhansan\n"
	*                        _pchSrc 要查找的原串。
	*                        _pchKey 要匹配的关键串。
	*                        _pchDest 查找的结果。
	*     返回值     返回 _pchDest    的字符串起始地址。找不到返回 NULL
	*        作 者 武立强
	*        时    间    2009-02-10
	*        注    意 应用示例：当查找DATE 时返回 2009-01-02
	*/
	char * PrintKeyValue(char* _pchDest, const char* _pchSrc, const char* _pchKey)
	{
	    assert( NULL != _pchDest && NULL != _pchSrc && NULL != _pchKey );
	    
	    int nStartFind = 0; 
	    char* pchDestStart = NULL;
	    const char* pchKeyStart = NULL; // 指向关键字(参数)的开始地址;


	    pchKeyStart = _pchKey;
	    pchDestStart = _pchDest;

	    while( '\0' != *_pchSrc )
	    {
	        // 匹配成功

	        if( 1 == nStartFind && ':' == *_pchSrc && '\0' == *_pchKey )
	        {
	            _pchSrc++;
	            while( '@' != *_pchSrc && '\0' != *_pchSrc )
	            {
	                *_pchDest++ = *_pchSrc++;
	            }
	            *_pchDest = '\0';
	            _pchDest = NULL;
	            _pchSrc = NULL;

	            return pchDestStart;
	        }
	        // 逻辑处理

	        else if( '@' == *_pchSrc )
	        {
	            nStartFind = 1;
	        }
	        // 匹配失败

	        else if( 1 == nStartFind && ':' == *_pchSrc && '\0' != *_pchKey )
	        {
	            nStartFind = 0; 
	            _pchKey = pchKeyStart;
	        }
	        // 匹配失败

	        else if( 1 == nStartFind && '\0' == *_pchKey && ':' != *_pchSrc )
	        {
	            nStartFind = 0; 
	            _pchKey = pchKeyStart;
	        }
	        // 匹配失败

	        else if( 1 == nStartFind && *_pchSrc != *_pchKey )
	        {
	            nStartFind = 0; 
	            _pchKey = pchKeyStart;
	        }
	        else if( 1 == nStartFind && *_pchSrc == *_pchKey )
	        {
	            _pchKey++;
	        }

	        _pchSrc++;
	    }

	    return NULL;
	}


{% endhighlight %}




### IsNumberString 

{% highlight c++ %}

	/*
	*    定义函数 int IsNumberString(const char* _pStr);
	*    表头文件 #include 
	*    函数描述    测试字符串是否是一个数字串
	*     返回值     如果是数字串返回0,否则返回-1
	*        作 者 武立强
	*        时    间    2009-02-13
	*/
	int IsNumberString(const char* _pStr)
	{
	    assert( NULL != _pStr );
	    while( '\0' != *_pStr )
	    {
	        if( *_pStr > '9' || *_pStr < '0' )
	        {
	            return (-1);
	        }
	        _pStr++;
	    }
	    return 0;
	}
	

{% endhighlight %}


### StringReverse 

{% highlight c++ %}

	/*
	*    函数原形 char * StringReverse(char* _pchDest, const char* _pchSrc);
	*    表头文件 #include 
	*    函数描述    将字符串 _pchSrc 到序反转, 结果存放在 _pchDest 中, _pchDest 要有足够的空间
	*                        来容纳处理后的字符串
	*     返回值     _pchDest 字符串的首地址
	*        作 者 武立强
	*        时    间    2009-02-13
	*/
	char * StringReverse(char* _pchDest, const char* _pchSrc)
	{
	    assert( NULL != _pchDest && NULL != _pchSrc );
	    const char* pSrcFirst = _pchSrc;
	    char * pDestFirst = _pchDest;

	    // 将指针定位到字符串的结尾 '\0' 处

	    while( '\0' != *_pchSrc++ ) ;
	    
	    _pchSrc--;
	    while( _pchSrc-- >= pSrcFirst )
	    {
	        *_pchDest++ = *_pchSrc ;
	    }
	    *(_pchDest-1) = '\0';

	    return pDestFirst;
	}

{% endhighlight %}



### BinaryToOcatl 

{% highlight c++ %}

	/*
	*    函数原形    char * BinaryToOcatl(char* _pchDest, const char* _pchSrc);
	*    表头文件    #include 
	*                        #include
	*                        #include
	*    函数描述    二进制转八进制。将二进制字符串转换为八进制字符串，_pchSrc 串中不能有 '+'、'-' 和 '.'
	*        参 数    _pchSrc，要转换的二进制串，只能是由'0' 和'1' 组成的字符串。
	*                        _pchDest，存放转换后的八进制串。要有足够的空间来容纳处理后的字符串
	*     返回值    成功，返回转换后 _pchDest 目标串的首地址
	*                        失败，返回NULL
	*        作 者    武立强
	*        时    间    2009-02-17
	*        备 注    目前还不支持小数
	*/
	char * BinaryToOcatl(char* _pchDest, const char* _pchSrc)
	{
	    assert( NULL != _pchDest && NULL != _pchSrc );

	    char* pchDestFirst = _pchDest;
	    char* pNewSrc = NULL;
	    char* pNewSrcFirst = NULL;
	    char szTemp[4] = ""; 
	    int nDestLenth = 0;
	    int nSrcLenth = 0;
	    bool bStart = false; // 表示第一个非 '0' 字符的开始


	    nSrcLenth = strlen(_pchSrc);

	    // 将_pchSrc 中开头的 '0' 和所有的空格全部过滤掉, 放在一个新串中

	    pNewSrc = (char*)malloc(sizeof(char) * (nSrcLenth + 1));
	    pNewSrcFirst = pNewSrc;
	    memset(pNewSrc, 0, (nSrcLenth + 1));

	    while( '\0' != *_pchSrc )
	    {
	        // 过滤空格

	        if( ' ' == *_pchSrc )
	        {
	            _pchSrc++;
	            continue;        
	        }

	        // 判断第一个 非 '0' 字符

	        if( !bStart && '0' != *_pchSrc )
	        {
	            bStart = true;
	            continue;
	        }

	        // 字符串中的字符只能是 '1', '0' 

	        if( bStart && ('1' == *_pchSrc || '0' == *_pchSrc) )
	        {
	            *pNewSrc = *_pchSrc;
	            pNewSrc++;
	        }
	        else if ( bStart && !('1' == *_pchSrc || '0' == *_pchSrc) )
	        {
	            // _pchSrc 串中有特殊字符,错误!

	            return NULL;
	        }
	        _pchSrc++;
	    }     
	    _pchSrc = NULL;
	    
	    // 将 pNewSrc 指针指到字符串的末尾

	    pNewSrc =pNewSrcFirst + ( strlen(pNewSrcFirst) - 1 );

	    while( pNewSrc >= pNewSrcFirst )
	    {
	        memset(szTemp, 0, 4);
	        for( int i=2; i>=0; i-- )
	        {
	            if( pNewSrc < pNewSrcFirst )
	            {
	                szTemp[i] = '0';
	            }
	            else
	            {
	                szTemp[i] = *pNewSrc;
	                pNewSrc--;
	            }    
	        }

	        // 对比转换

	        if( !strcmp(szTemp, "000") )
	        {
	            *_pchDest = '0';
	        }
	        else if( !strcmp(szTemp, "001") )
	        {
	            *_pchDest = '1';
	        }
	        else if( !strcmp(szTemp, "010") )
	        {
	            *_pchDest = '2';
	        }
	        else if( !strcmp(szTemp, "011") )
	        {
	            *_pchDest = '3';
	        }
	        else if( !strcmp(szTemp, "100") )
	        {
	            *_pchDest = '4';
	        }
	        else if( !strcmp(szTemp, "101") )
	        {
	            *_pchDest = '5';
	        }
	        else if( !strcmp(szTemp, "110") )
	        {
	            *_pchDest = '6';
	        }
	        else if( !strcmp(szTemp, "111") )
	        {
	            *_pchDest = '7';
	        }
	        else
	        {
	            // 错误

	            return NULL;
	        }
	        _pchDest++;    
	    }
	    *_pchDest = '\0';

	    // 释放内存

	    free(pNewSrcFirst);
	    pNewSrcFirst = NULL;
	    pNewSrc = NULL;
	    
	    nDestLenth = strlen(pchDestFirst);

	    // 将 _pchDest 串反转

	    for( int i=0; i< (nDestLenth/2); i++ )
	    {
	        char chTemp = 0;
	        chTemp = pchDestFirst[i];
	        pchDestFirst[i] = pchDestFirst[nDestLenth - 1 - i];
	        pchDestFirst[nDestLenth - 1 - i] = chTemp;
	    }

	    return pchDestFirst;
	}

{% endhighlight %}




### BinaryToHex 

{% highlight c++ %}

	/*
	*    函数原形    char * BinaryToHex(char* _pchDest, const char* _pchSrc);
	*    表头文件    #include 
	*                        #include
	*                        #include
	*    函数描述    二进制转十六进制。将二进制字符串转换为十六进制字符串，_pchSrc 串中不能有 '+'、'-' 和 '.'
	*        参 数    _pchSrc，要转换的二进制串，只能是由'0' 和'1' 组成的字符串。
	*                        _pchDest，存放转换后的十六进制串。要有足够的空间来容纳处理后的字符串
	*     返回值    成功，返回转换后 _pchDest 目标串的首地址
	*                        失败，返回NULL
	*        作 者    武立强
	*        时    间    2009-02-17
	*        备 注    目前还不支持小数
	*/
	char * BinaryToHex(char* _pchDest, const char* _pchSrc)
	{
	    assert( NULL != _pchDest && NULL != _pchSrc );

	    char* pchDestFirst = _pchDest;
	    char* pNewSrc = NULL;
	    char* pNewSrcFirst = NULL;
	    char szTemp[5] = ""; 
	    int nDestLenth = 0;
	    int nSrcLenth = 0;
	    bool bStart = false; // 表示第一个非 '0' 字符的开始


	    nSrcLenth = strlen(_pchSrc);

	    // 将_pchSrc 中开头的 '0' 和所有的空格全部过滤掉, 放在一个新串中

	    pNewSrc = (char*)malloc(sizeof(char) * (nSrcLenth + 1));
	    pNewSrcFirst = pNewSrc;
	    memset(pNewSrc, 0, (nSrcLenth + 1));

	    while( '\0' != *_pchSrc )
	    {
	        // 过滤空格

	        if( ' ' == *_pchSrc )
	        {
	            _pchSrc++;
	            continue;        
	        }

	        // 判断第一个 非 '0' 字符

	        if( !bStart && '0' != *_pchSrc )
	        {
	            bStart = true;
	            continue;
	        }

	        // 字符串中的字符只能是 '1', '0' 

	        if( bStart && ('1' == *_pchSrc || '0' == *_pchSrc) )
	        {
	            *pNewSrc = *_pchSrc;
	            pNewSrc++;
	        }
	        else if ( bStart && !('1' == *_pchSrc || '0' == *_pchSrc) )
	        {
	            // _pchSrc 串中有特殊字符,错误!

	            return NULL;
	        }
	        _pchSrc++;
	    }     
	    _pchSrc = NULL;
	    
	    // 将 pNewSrc 指针指到字符串的末尾

	    pNewSrc =pNewSrcFirst + ( strlen(pNewSrcFirst) - 1 );

	    while( pNewSrc >= pNewSrcFirst )
	    {
	        memset(szTemp, 0, sizeof(szTemp));
	        for( int i=3; i>=0; i-- )
	        {
	            if( pNewSrc < pNewSrcFirst )
	            {
	                szTemp[i] = '0';
	            }
	            else
	            {
	                szTemp[i] = *pNewSrc;
	                pNewSrc--;
	            }    
	        }

	        // 对比转换

	        if( !strcmp(szTemp, "0000") )
	        {
	            *_pchDest = '0';
	        }
	        else if( !strcmp(szTemp, "0001") )
	        {
	            *_pchDest = '1';
	        }
	        else if( !strcmp(szTemp, "0010") )
	        {
	            *_pchDest = '2';
	        }
	        else if( !strcmp(szTemp, "0011") )
	        {
	            *_pchDest = '3';
	        }
	        else if( !strcmp(szTemp, "0100") )
	        {
	            *_pchDest = '4';
	        }
	        else if( !strcmp(szTemp, "0101") )
	        {
	            *_pchDest = '5';
	        }
	        else if( !strcmp(szTemp, "0110") )
	        {
	            *_pchDest = '6';
	        }
	        else if( !strcmp(szTemp, "0111") )
	        {
	            *_pchDest = '7';
	        }
	        else if( !strcmp(szTemp, "1000") )
	        {
	            *_pchDest = '8';
	        }
	        else if( !strcmp(szTemp, "1001") )
	        {
	            *_pchDest = '9';
	        }
	        else if( !strcmp(szTemp, "1010") )
	        {
	            *_pchDest = 'A';
	        }
	        else if( !strcmp(szTemp, "1011") )
	        {
	            *_pchDest = 'B';
	        }
	        else if( !strcmp(szTemp, "1100") )
	        {
	            *_pchDest = 'C';
	        }
	        else if( !strcmp(szTemp, "1101") )
	        {
	            *_pchDest = 'D';
	        }
	        else if( !strcmp(szTemp, "1110") )
	        {
	            *_pchDest = 'E';
	        }
	        else if( !strcmp(szTemp, "1111") )
	        {
	            *_pchDest = 'F';
	        }
	        else
	        {
	            // 错误

	            return NULL;
	        }
	        _pchDest++;    
	    }
	    *_pchDest = '\0';

	    // 释放内存

	    free(pNewSrcFirst);
	    pNewSrcFirst = NULL;
	    pNewSrc = NULL;
	    
	    nDestLenth = strlen(pchDestFirst);

	    // 将 _pchDest 串反转

	    for( int i=0; i< (nDestLenth/2); i++ )
	    {
	        char chTemp = 0;
	        chTemp = pchDestFirst[i];
	        pchDestFirst[i] = pchDestFirst[nDestLenth - 1 - i];
	        pchDestFirst[nDestLenth - 1 - i] = chTemp;
	    }

	    return pchDestFirst;
	}

{% endhighlight %}




### OcatlToBinary 

{% highlight c++ %}

	/*
	*    函数原形    char * OcatlToBinary(char* _pchDest, const char* _pchSrc);
	*    表头文件    #include 
	*                        #include
	*                        #include
	*    函数描述    八进制转二进制。将八进制字符串转换为二进制字符串，_pchSrc 串中不能有 '+'、'-' 和 '.'
	*        参 数    _pchSrc，要转换的八进制串，只能是由'0' 到'7'之间的字符组成的字符串。
	*                        _pchDest，存放转换后的二进制串。要有足够的空间来容纳处理后的字符串
	*     返回值    成功，返回转换后 _pchDest 目标串的首地址
	*                        失败，返回NULL
	*        作 者    武立强
	*        时    间    2009-02-17
	*        备 注    目前还不支持小数
	*/
	char * OcatlToBinary(char* _pchDest, const char* _pchSrc)
	{
	    assert( NULL != _pchDest && NULL != _pchSrc );
	    
	    char* pchDestFirst = _pchDest;
	    char* pNewSrc = NULL;
	    char* pNewSrcFirst = NULL;
	    int nSrcLenth = 0;
	    bool bStart = false; // 表示第一个非 '0' 字符的开始

	    int nZeroCount = 0; // 表示前边 '0' 的个数


	    nSrcLenth = strlen(_pchSrc);
	    pNewSrc = (char*)malloc(sizeof(char) * (nSrcLenth + 1));
	    pNewSrcFirst = pNewSrc;
	    memset(pNewSrc, 0, (nSrcLenth + 1));

	    // 将_pchSrc 中开头的 '0' 和所有的空格全部过滤掉, 放在一个新串pNewSrc中

	    while( '\0' != *_pchSrc )
	    {
	        // 过滤空格

	        if( ' ' == *_pchSrc )
	        {
	            _pchSrc++;
	            continue;        
	        }

	        // 判断第一个 非 '0' 字符

	        if( !bStart && '0' != *_pchSrc )
	        {
	            bStart = true;
	            continue;
	        }

	        // 字符串中的字符只能是 '0' 到 '7' 之间的字符 

	        if( bStart && ('0' <= *_pchSrc && '7' >= *_pchSrc) )
	        {
	            *pNewSrc = *_pchSrc;
	            pNewSrc++;
	        
	        }
	        else if ( bStart && !('0' <= *_pchSrc && '7' >= *_pchSrc) )
	        {
	            // _pchSrc 串中有特殊字符,错误!

	            return NULL;
	        }
	        _pchSrc++;
	    } 
	    _pchSrc = NULL;
	    pNewSrc = pNewSrcFirst;

	    // 逻辑转换

	    while( '\0' != *pNewSrc )
	    {
	        if( '0' == *pNewSrc )
	        {
	            strcat(_pchDest, "000");            
	        }
	        else if( '1' == *pNewSrc )
	        {
	            strcat(_pchDest, "001");
	        }
	        else if( '2' == *pNewSrc )
	        {
	            strcat(_pchDest, "010");
	        }
	        else if( '3' == *pNewSrc )
	        {
	            strcat(_pchDest, "011");
	        }
	        else if( '4' == *pNewSrc )
	        {
	            strcat(_pchDest, "100");
	        }
	        else if( '5' == *pNewSrc )
	        {
	            strcat(_pchDest, "101");
	        }
	        else if( '6' == *pNewSrc )
	        {
	            strcat(_pchDest, "110");
	        }
	        else if( '7' == *pNewSrc )
	        {
	            strcat(_pchDest, "111");
	        }
	        else
	        {
	            // 错误

	            return NULL;
	        }
	        _pchDest += 3;
	        pNewSrc++;
	    }

	    // 释放内存

	    free(pNewSrcFirst);
	    pNewSrcFirst = NULL;
	    pNewSrc = NULL;
	    
	    nZeroCount = 0; //使用前清零

	    bStart = false;
	    _pchDest = pchDestFirst;

	    // 将 _pchDest 最前边开始的 '0' 过滤掉

	    while( '\0' != *_pchDest )
	    {
	        // 找到第一个非 '0' 字符

	        if( !bStart && '0' != *_pchDest )
	        {
	            nZeroCount = (_pchDest - pchDestFirst); // 得到前边0的个数

	            bStart = true;
	        }

	        if( bStart )
	        {
	            *(_pchDest - nZeroCount) = *_pchDest; // 向前移动

	        }
	        _pchDest++;
	    }
	    *(_pchDest - nZeroCount) = '\0'; //别忘了 '\0'


	    return pchDestFirst;
	}

{% endhighlight %}




### HexToBinary 

{% highlight c++ %}

	/*
	*    函数原形    char * HexToBinary(char* _pchDest, const char* _pchSrc);
	*    表头文件    #include 
	*                        #include
	*                        #include
	*    函数描述    十六进制转二进制。将十六进制字符串转换为二进制字符串，_pchSrc 串中不能有 '+'、'-' 和 '.'
	*        参 数    _pchSrc，要转换的十六进制串，只能是由'0' 到'7'和 'A'到 'F'之间的字符组成的字符串。
	*                        _pchDest，存放转换后的二进制串。要有足够的空间来容纳处理后的字符串
	*     返回值    成功，返回转换后 _pchDest 目标串的首地址
	*                        失败，返回NULL
	*        作 者    武立强
	*        时    间    2009-02-17
	*        备 注    目前还不支持小数
	*/
	char * HexToBinary(char* _pchDest, const char* _pchSrc)
	{
	    assert( NULL != _pchDest && NULL != _pchSrc );
	    
	    char* pchDestFirst = _pchDest;
	    char* pNewSrc = NULL;
	    char* pNewSrcFirst = NULL;
	    int nSrcLenth = 0;
	    bool bStart = false; // 表示第一个非 '0' 字符的开始

	    int nZeroCount = 0; // 表示前边 '0' 的个数


	    nSrcLenth = strlen(_pchSrc);
	    pNewSrc = (char*)malloc(sizeof(char) * (nSrcLenth + 1));
	    pNewSrcFirst = pNewSrc;
	    memset(pNewSrc, 0, (nSrcLenth + 1));

	    // 将_pchSrc 中开头的 '0' 和所有的空格全部过滤掉, 放在一个新串pNewSrc中

	    while( '\0' != *_pchSrc )
	    {
	        // 过滤空格

	        if( ' ' == *_pchSrc )
	        {
	            _pchSrc++;
	            continue;        
	        }

	        // 判断第一个 非 '0' 字符

	        if( !bStart && '0' != *_pchSrc )
	        {
	            bStart = true;
	            continue;
	        }

	        // 字符串中的字符只能是 '0' 到 '9' 和 'A'到 'F' 之间的字符 

	        if( bStart && (('0' <= *_pchSrc && '7' >= *_pchSrc) || ('A' <= *_pchSrc && 'F' >= *_pchSrc)) )
	        {
	            *pNewSrc = *_pchSrc;
	            pNewSrc++;
	        
	        }
	        else if ( bStart && !(('0' <= *_pchSrc && '7' >= *_pchSrc) || ('A' <= *_pchSrc && 'F' >= *_pchSrc)) )
	        {
	            // _pchSrc 串中有特殊字符,错误!

	            return NULL;
	        }
	        _pchSrc++;
	    } 
	    _pchSrc = NULL;
	    pNewSrc = pNewSrcFirst;

	    // 逻辑转换

	    while( '\0' != *pNewSrc )
	    {
	        if( '0' == *pNewSrc )
	        {
	            strcat(_pchDest, "0000");            
	        }
	        else if( '1' == *pNewSrc )
	        {
	            strcat(_pchDest, "0001");
	        }
	        else if( '2' == *pNewSrc )
	        {
	            strcat(_pchDest, "0010");
	        }
	        else if( '3' == *pNewSrc )
	        {
	            strcat(_pchDest, "0011");
	        }
	        else if( '4' == *pNewSrc )
	        {
	            strcat(_pchDest, "0100");
	        }
	        else if( '5' == *pNewSrc )
	        {
	            strcat(_pchDest, "0101");
	        }
	        else if( '6' == *pNewSrc )
	        {
	            strcat(_pchDest, "0110");
	        }
	        else if( '7' == *pNewSrc )
	        {
	            strcat(_pchDest, "0111");
	        }
	        else if( '8' == *pNewSrc )
	        {
	            strcat(_pchDest, "1000");
	        }
	        else if( '9' == *pNewSrc )
	        {
	            strcat(_pchDest, "1001");
	        }
	        else if( 'A' == *pNewSrc )
	        {
	            strcat(_pchDest, "1010");
	        }
	        else if( 'B' == *pNewSrc )
	        {
	            strcat(_pchDest, "1011");
	        }
	        else if( 'C' == *pNewSrc )
	        {
	            strcat(_pchDest, "1100");
	        }
	        else if( 'D' == *pNewSrc )
	        {
	            strcat(_pchDest, "1101");
	        }
	        else if( 'E' == *pNewSrc )
	        {
	            strcat(_pchDest, "1110");
	        }
	        else if( 'F' == *pNewSrc )
	        {
	            strcat(_pchDest, "1111");
	        }
	        else
	        {
	            // 错误

	            return NULL;
	        }
	        _pchDest += 4;
	        pNewSrc++;
	    }

	    // 释放内存

	    free(pNewSrcFirst);
	    pNewSrcFirst = NULL;
	    pNewSrc = NULL;
	    
	    nZeroCount = 0; //使用前清零

	    bStart = false;
	    _pchDest = pchDestFirst;

	    // 将 _pchDest 最前边开始的 '0' 过滤掉

	    while( '\0' != *_pchDest )
	    {
	        // 找到第一个非 '0' 字符

	        if( !bStart && '0' != *_pchDest )
	        {
	            nZeroCount = (_pchDest - pchDestFirst); // 得到前边0的个数

	            bStart = true;
	        }

	        if( bStart )
	        {
	            *(_pchDest - nZeroCount) = *_pchDest; // 向前移动

	        }
	        _pchDest++;
	    }
	    *(_pchDest - nZeroCount) = '\0'; //别忘了 '\0'


	    return pchDestFirst;
	}

	

{% endhighlight %}



### BinaryStringToInt 

{% highlight c++ %}

	
	/*
	*    函数原形    int BinaryStringToInt(const char* _pStr);
	*    表头文件    #include 
	*    函数描述    二进制字符串转换为整形数字。_pStr 串中不能有 '+'、'-' 和 '.'
	*        参 数    _pStr，要转换的二进制串，只能是由'0'和 '1'字符组成的字符串。
	*     返回值    成功，返回转换后的整数
	*                        失败，返回-1
	*        作 者    武立强
	*        时    间    2009-02-17
	*        备 注    _pStr 字符串中的空格可以被过滤掉,_pStr中可以存在空格, 当您传入"" 或 " " 时，
	*                        函数将返回 0
	*/
	int BinaryStringToInt(const char* _pStr)
	{
	    assert( NULL != _pStr );

	    int nNumber = 0;

	    while( '\0' != *_pStr )
	    {
	        if( ' ' == *_pStr )
	        { 
	            // 过滤空格字符

	        }
	        else if( *_pStr < '0' || *_pStr > '1')
	        {
	            // 如果遇到非'0'--'1' 之间的字符,直接返回 -1

	            return -1;
	        }
	        else
	        {
	            nNumber = nNumber*2 + (*_pStr -48);
	        }
	        _pStr++;
	    }

	    return nNumber;
	}


{% endhighlight %}




### IntToBinaryString 

{% highlight c++ %}

	/*
	*    函数原形    char * IntToBinaryString(char* _pchBinStr, int nNumber);
	*    表头文件    #include 
	*    函数描述    将整数转换为二进制字符串，只支持正数转换, 不支持负数和 0 的转换 
	*        参 数    nNumber，要转换的正整数
	*                        _pchBinStr 存放转换后的二进制字符串。要有足够的空间来容纳转换后的字符串
	*     返回值    成功，返回转换后的二进制字符串
	*                        失败，返回NULL
	*        作 者    武立强
	*        时    间    2009-02-18
	*        备 注    目前还不支持小数
	*/
	char * IntToBinaryString(char* _pchBinStr, int nNumber)
	{
	    assert( NULL != _pchBinStr );

	    char * pchFirst = _pchBinStr;

	    if( nNumber <= 0 )
	    {
	        return NULL;
	    }

	    while( nNumber > 0 )
	    {
	        *_pchBinStr = (nNumber % 2) + 48; // +48 是将数字转换为字符, '0'=48 

	        nNumber = nNumber / 2; // 两个整数相除,结果取整

	        _pchBinStr++;
	    }
	    *_pchBinStr = '\0'; 
	    
	    int nLen = 0;
	    nLen = _pchBinStr - pchFirst; //转换后字符串的长度


	    // 将字符串反转(记住此算法)

	    for(int i=0; i<(nLen/2); i++)
	    {
	        char chTemp = 0; // 每次都初始化为 0

	        chTemp = pchFirst[i];
	        pchFirst[i] = pchFirst[nLen - 1 - i];
	        pchFirst[nLen - 1 - i] = chTemp;
	    }

	    return pchFirst;
	}

{% endhighlight %}




### FileCopy 

{% highlight c++ %}

	
	/*
	*    函数原形    int FileCopy(const char* pDestFileName, const char* pSrcFileName);
	*    表头文件    #include 
	*    函数描述    复制文件函数。将 pSrcFileName 文件复制到 pDestFileName 处，
	*                        如果 pDestFileName 文件存在，将回覆盖此文件。
	*        参 数    pSrcFileName，要复制的源文件名
	*                        pDestFileName, 源文件复制后的文件，如果系统中存在此名称的文件，将会覆盖掉！
	*     返回值    成功，返回 1
	*                        失败，返回 0
	*        作 者    武立强
	*        时    间    2009-02-19
	*        备 注    在复制前要先判断目标文件是否存在，否则会覆盖掉已经存在的文件
	*/
	int FileCopy(const char* pDestFileName, const char* pSrcFileName)
	{
	    assert( NULL != pDestFileName && NULL != pSrcFileName );
	    
	    FILE *fpDest = NULL;
	    FILE *fpSrc = NULL;

	    // 打开源文件, 只读

	    fpSrc = fopen(pSrcFileName, "rb"); 
	    if( NULL == fpSrc )
	    {
	        // 打开文件失败

	        return 0;
	    }

	    // 打开目的文件,只写

	    fpDest = fopen(pDestFileName, "wb");
	    if( NULL == fpDest )
	    {
	        // 打开文件失败

	        fclose(fpSrc);
	        return 0;
	    }

	    while( !feof(fpSrc) )
	    {
	        int nCount = 0; // 读取字节的个数

	        char szBuf[500] = "";
	        // 一次读写500个字节,效率还可以！

	        nCount = fread(szBuf, sizeof(char), 500, fpSrc);
	        fwrite(szBuf, sizeof(char), nCount, fpDest);    
	    }

	    fclose(fpDest);
	    fclose(fpSrc);

	    return 1;
	}


{% endhighlight %}



### CheckFileIsEmpty 

{% highlight c++ %}

	/*
	*    函数原形    int CheckFileIsEmpty(const char* _pchFileName);
	*    表头文件    #include 
	*    函数描述    检查一个文件是否为空文件
	*        参 数    _pchFileName, 文件名字符串
	*     返回值    1，表示文件是空文件
	*                        0，表示文件非空
	*                        -1，函数执行失败（打开文件失败）
	*        作 者    武立强
	*        时    间    2009-02-19
	*        备 注    
	*/
	int CheckFileIsEmpty(const char* _pchFileName)
	{
	    assert( NULL != _pchFileName );

	    char chTemp = 0;
	    int nRead = 0;
	    FILE * fp = NULL;

	    // 打开文件， 只读

	    fp = fopen(_pchFileName, "rb");
	    if( NULL == fp )
	    {
	        return -1;
	    }
	    
	    // 读一个字节

	    nRead = fread(&chTemp, sizeof(char), 1, fp);
	    if( 1 == nRead )
	    {
	        return 1;
	    }
	    else
	    {
	        return 0;
	    }

	    // 关闭文件

	    fclose(fp);
	}

{% endhighlight %}



### CheckIsFileExist 

{% highlight c++ %}

	/*
	*    函数原形    int CheckIsFileExist(const char* _pchFileName);
	*    表头文件    #include 
	*    函数描述    检查文件是否存在。
	*        参 数    _pchFileName, 文件路径名
	*     返回值    1，文件存在
	*                        0，文件不存在
	*        作 者    武立强
	*        时    间    2009-02-19
	*        备 注    
	*/
	int CheckIsFileExist(const char* _pchFileName)
	{
	    assert( NULL != _pchFileName );

	    FILE * fp = NULL;
	    fp = fopen(_pchFileName, "r");
	    if( NULL == fp)
	    {
	        return 0;
	    }
	    else
	    {
	        return 1;
	    }

	    fclose(fp);
	}


{% endhighlight %}




### GetCurrentTimeString 

{% highlight c++ %}

	/*
	*    函数原形    char * GetCurrentTimeString(char* _pchTimeStr);
	*    表头文件    #include 
	*                        #include
	*                        #include
	*    函数描述    当前系统时间转换为字符串格式。生成的字符串格式为："2009-2-21 9:39:29"（18个字符）
	*        参 数    _pchTimeStr，存放转换后的字符串。要有足够的空间来存放转换后的字符串
	*     返回值    返回_pchTimeStr首地址。
	*        作 者    武立强
	*        时    间    2009-02-21
	*        备 注    使用前要将_pchTimeStr所指向的内容全部清零(必须清零,要不会出错)
	*/
	char * GetCurrentTimeString(char* _pchTimeStr)
	{
	    assert( NULL != _pchTimeStr );
	    
	    time_t timep = 0;
	    struct tm *p = NULL;
	    char szTemp[5] = "";
	    
	    time(&timep);
	    p=localtime(&timep); /*取得当地时间*/

	    // 年

	    strcat(_pchTimeStr, itoa(1900 + p->tm_year, szTemp, 10) );
	    strcat(_pchTimeStr, "-");

	    // 月

	    strcat(_pchTimeStr, itoa(1 + p->tm_mon, szTemp, 10) );
	    strcat(_pchTimeStr, "-");
	    
	    // 日

	    strcat(_pchTimeStr, itoa(p->tm_mday, szTemp, 10) );
	    strcat(_pchTimeStr, " ");

	    // 时

	    strcat(_pchTimeStr, itoa(p->tm_hour, szTemp, 10) );
	    strcat(_pchTimeStr, ":");

	    // 分

	    strcat(_pchTimeStr, itoa(p->tm_min, szTemp, 10) );span style=fclosecolor: rgb(255, 0, 0);color: rgb(255, 0, 0);;color: rgb(0, 0, 204); color: rgb(255, 0, 255); color: rgb(0, 0, 204);
	    strcat(_pchTimeStr, ":");

	    // 秒

	    strcat(_pchTimeStr, itoa(p->tm_sec, szTemp, 10) );

	    return _pchTimeStr;
	}

{% endhighlight %}




### GetCurrentTimeOneElements 

{% highlight c++ %}

	/*
	*    函数原形    int GetCurrentTimeOneElements(const int nFlag);
	*    表头文件    #include 
	*                        #include
	*                        #include
	*    函数描述    得到当前系统时间的一个基本元素。例如，年、月、日、时、分、秒、星期
	*        参 数    nFlag，表示位，只能是 0 -6 之间的正整数。
	*     返回值    nFlag = 0，返回当前年
	*                        nFlag = 1，返回当前月（1-12）
	*                        nFlag = 2，返回当前日（1-31）
	*                        nFlag = 3，返回当前时（0-23）
	*                        nFlag = 4，返回当前分（0-59）
	*                        nFlag = 5，返回当前秒（0-59）
	*                        nFlag = 6，返回当前星期（1-7）
	*                        当nFlag为其他值是，返回 -1
	*                        
	*        作 者    武立强
	*        时    间    2009-02-21
	*        备 注    
	*/
	int GetCurrentTimeOneElements(const int nFlag)
	{
	    if( nFlag < 0 || nFlag > 6)
	    {
	        return (-1);
	    }

	    time_t timep = 0;
	    struct tm *p = NULL;
	    const int arrWeekDay[7] = {7,1,2,3,4,5,6};
	    
	    time(&timep);
	    p=localtime(&timep); /*取得当地时间*/

	    switch( nFlag )
	    {
	    case 0:
	        // 以整数形式返回年份

	        return (1900 + p->tm_year);
	        break;

	    case 1:
	        // 月

	        return (1 + p->tm_mon);
	        break;

	    case 2:
	        // 日

	        return (p->tm_mday);
	        break;

	    case 3:
	        // 时

	        return (p->tm_hour);
	        break;

	    case 4:
	        // 分

	        return (p->tm_min);
	        break;

	    case 5:
	        // 秒

	        return (p->tm_sec);
	        break;

	    case 6:
	        // 星期

	        return ( arrWeekDay[p->tm_wday] );
	        break;
	    
	    default:
	        return (-1);
	    }
	    
	    return (-1);
	}

{% endhighlight %}




### IniFileAnalyse 

{% highlight c++ %}

	/*
	*    函数原形    char * IniFileAnalyse(const char* _pchFileName, const char* _pchArea, const char* _pchKey, char* _pchValue);
	*    表头文件    #include 
	*                        #include
	*    函数描述    固定格式的文件解析。文件建议.ini 后缀，当然也可以是其他的文件,文件的格式
	*                        要求如下：example.ini
	*                                [login]            //    [域名]
	*                                name=admin        //    key = value
	*                                password=888888
	*                                ...
	*                        文件可以有多个域，但不能有重名的域。
	*                        每一行可以有空格,
	*                        每一行长度不能超过500个字符
	*        参 数    _pchFileName, 文件名
	*                        _pchArea，域名
	*                        _pchKey，要查找的关键字
	*                        _pchValue，存放找到的结果，要有足够的空间来 存放找到的结果!
	*     返回值    如果查找成功，返回第一个找到_pchKey所对应的_pchValue串的首地址
	*                        没有找到后函数调用失败都返回 NULL        
	*        作 者    武立强
	*        时    间    2009-02-22
	*        备 注    用到了StringFilter()函数。
	*/
	char * IniFileAnalyse(const char* _pchFileName, const char* _pchArea, const char* _pchKey, char* _pchValue)
	{
	    assert(    NULL != _pchFileName && NULL != _pchArea && NULL != _pchKey && NULL != _pchValue );

	    FILE * fp = NULL;
	    char szTemp[501] = ""; // 支持文件一行最多500个字符

	    int nKeyLength = strlen(_pchKey);

	    // 打开文件,只读

	    fp = fopen(_pchFileName, "r");
	    if( NULL == fp )
	    {
	        printf("IniFileAnalyse: open %s file error!\n");
	        return NULL;
	    }
	    
	    while( !feof(fp) )
	    {
	        // 读取一行数据, 将最后的那个 '\n' 也读进来了!

	        fgets(szTemp, sizeof(szTemp), fp);
	        StringFilter(szTemp, ' ');    // 过滤所有空格

	        StringFilter(szTemp, '\n'); // 过滤 '\n'


	        if( '[' == szTemp[0] )
	        {
	            // 找到一个域的开始

	            // 将 '[' 和 ']' 分别过滤掉

	            StringFilter(szTemp, '[');
	            StringFilter(szTemp, ']');
	        }
	        else
	        {
	            continue;
	        }
	    
	        if( !strcmp(szTemp, _pchArea) )
	        {
	            // 找到一个域

	            ;
	        }
	        else
	        {
	            continue;
	        }

	        while( !feof(fp) )
	        {
	            fgets(szTemp, sizeof(szTemp), fp);
	            StringFilter(szTemp, ' ');    // 过滤所有空格

	            
	            if( '[' == szTemp[0] )
	            {
	                // 已经到了下一个域了,还没有找到,直接返回

	                fclose(fp);
	                return NULL;
	            }
	            // 比较前 nKeyLength 个是否相等

	            else if( !strncmp(szTemp, _pchKey, nKeyLength) )
	            {
	                // 找到了_pchKey相同的字符串

	                StringFilter(szTemp, '\n'); // 过滤最后的那个 '\n'

	                strcpy(_pchValue, (szTemp + nKeyLength + 1));
	                fclose(fp);
	                return _pchValue;            
	            }        
	        }
	    }

	    fclose(fp);
	    return NULL;
	}

	

{% endhighlight %}




### StringMove 

{% highlight c++ %}

	/*
	*    函数原形    char * StringMove(char* _pchDest, const char* _pchSrc, int nNumber);
	*    表头文件    #include 
	*                        #include
	*    函数描述    字符串循环移动。将字符串循环向左或向右移动 nNumber 个字符。
	*        参 数    _pchSrc，要移动的原串
	*                        nNumber，移动的位数，当 nNumber > 0 时，向左移动， nNumber < 0时，向右移动
	*                        _pchKey，要查找的关键字
	*                        _pchDest，存放移动后的字符串，要有足够的空间来存放处理后的字符串。
	*     返回值    返回 _pchDest 字符串的首地址。
	*        作 者    武立强
	*        时    间    2009-02-22
	*        备 注    此函数可用于简单的加密和解密运算。
	*/
	char * StringMove(char* _pchDest, const char* _pchSrc, int nNumber)
	{
	    assert( NULL != _pchDest && NULL != _pchSrc);

	    int nSrcLen = strlen(_pchSrc);
	        
	    if( nNumber >= 0 )
	    {
	        // 向左移动

	        nNumber = nNumber % nSrcLen;    // 处理移动的位数大于字符串长度时的情况

	        strcpy(_pchDest, _pchSrc + nNumber);
	        strncat(_pchDest, _pchSrc, nNumber);
	    }
	    else
	    {
	        //向右移动

	        nNumber = (0 - nNumber);
	        nNumber = nNumber % nSrcLen;
	        strcpy(_pchDest, _pchSrc + (nSrcLen - nNumber));
	        strncat(_pchDest, _pchSrc, nSrcLen - nNumber);
	    }

	    return _pchDest;
	}

{% endhighlight %}




### StringExclusiveEncription 

{% highlight c++ %}

	/*
	*    函数原形    void StringExclusiveEncription(char* _pchSrc, int _nLen, char _chKey);
	*    表头文件    #include 
	*                        #include
	*    函数描述    异或运算加密函数,直接修改原串。
	*                        将一个字符串的每一个字符和一个特定的字符异或运算
	*                        第一次异或----加密
	*                        第二次异或----解密
	*        参 数    _pchSrc，要加密的原串
	*                        _nLen, 原串的长度，用 strlen() 函数可以得到。
	*                        _chKey，加密的密钥
	*     返回值    无返回值
	*        作 者    武立强
	*        时    间    2009-02-22
	*        备 注    Exclusive:异或。Encription:加密
	*/
	void StringExclusiveEncription(char* _pchSrc, int _nLen, char _chKey)
	{
	    assert( NULL != _pchSrc );

	    for(int i=0; i<_nLen; i++)
	    {
	        _pchSrc[i] = _pchSrc[i] ^ _chKey; // 异或运算

	    }
	    return ;
	}

{% endhighlight %}




### StringInverseEncription 

{% highlight c++ %}

	/*
	*    函数原形    void StringInverseEncription(char* _pchSrc, int _nLen);
	*    表头文件    #include 
	*               #include
	*    函数描述    取反运算加密函数,直接修改原串。
	*                        将一个字符串的每一个字符取反
	*                        第一次取反----加密
	*                        第二次取反----解密
	*        参 数    _pchSrc，要加密的原串
	*                        _nLen, 原串的长度，用 strlen() 函数可以得到。
	*     返回值    无返回值
	*        作 者    武立强
	*        时    间    2009-02-22
	*        备 注    Inverse:相反的。Encription:加密
	*/
	void StringInverseEncription(char* _pchSrc, int _nLen)
	{
	    assert( NULL != _pchSrc );    

	    for(int i=0; i<_nLen; i++)
	    {
	        _pchSrc[i] = ~_pchSrc[i];    // 取反运算

	    }
	    return ;
	}

{% endhighlight %}




### GetMaxNumber 

{% highlight c++ %}

	/*
	*    函数原形    int GetMaxNumber(int _nArr[], int _nLen);
	*    表头文件    #include 
	*    函数描述    得到一个数组中最大的数 (冒泡法)
	*        参 数    _nArr，数组名
	*                        _nLen, 数组的长度
	*     返回值    数组中最大的数
	*        作 者    武立强
	*        时    间    2009-02-22
	*        备 注    
	*/
	int GetMaxNumber(int _nArr[], int _nLen)
	{
	    assert( NULL != _nArr );
	    
	    int nTemp = _nArr[0];

	    for(int i=0; i<_nLen; i++)
	    {
	        if( nTemp < _nArr[i] )
	        {
	            nTemp = _nArr[i];
	        }
	    }

	    return nTemp;
	}
	

{% endhighlight %}



### GetSecondMaxNumber 

{% highlight c++ %}

	/*
	*    函数原形    int GetSecondMaxNumber(int _nArr[], int _nLen);
	*    表头文件    #include 
	*    函数描述    得到一个数组中第二大的数 (冒泡法)
	*        参 数    _nArr，数组名
	*                _nLen, 数组的长度
	*     返回值     数组中最大的数
	*        作 者   武立强
	*        时间    2009-02-22
	*        备 注    
	*/
	int GetSecondMaxNumber(int _nArr[], int _nLen)
	{
	    assert( NULL != _nArr );

	    int nFirst = _nArr[0];
	    int nSecond = _nArr[0];
	    
	    // 得到最大的数

	    for(int i=0; i<_nLen; i++)
	    {
	        if( nFirst < _nArr[i] )
	        {
	            nFirst = _nArr[i];
	        }
	    }

	    // 得到第二大的数

	    for(i=0; i<_nLen; i++)
	    {
	        if( nSecond < _nArr[i] && _nArr[i] != nFirst )
	        {
	            nSecond = _nArr[i];
	        }
	    }

	    return nSecond;
	}

{% endhighlight %}



### GetSubString 

{% highlight c++ %}

	/*
	*    函数原形    char * GetSubString(char * _pchSubStr, const char* _pchStr, int _nStart, int _nEnd);
	*    表头文件    #include 
	*                        #include
	*    函数描述    得到一个字符串中的子串
	*        参 数    _pchStr，原字符串
	*                        _nStart, 原字符串开始下标
	*                        _nEnd，原字符串结束下标
	*                        _pchSubStr，存放找到的子串，要有足够的空间来存放处理后的子串。
	*     返回值    _pchSubStr子串的首地址。
	*        作 者    武立强
	*        时    间    2009-02-22
	*        备 注    
	*/
	char * GetSubString(char * _pchSubStr, const char* _pchStr, int _nStart, int _nEnd)
	{
	    assert( NULL != _pchSubStr && NULL != _pchStr );

	    int nSrcLen = strlen(_pchStr);
	    char* _pchFirst = _pchSubStr;

	    // 逻辑判断, 是否超出原串的范围

	    if( _nStart < 0 || _nEnd < 0 )
	    {
	        return NULL;
	    }
	    else if( _nStart >= nSrcLen || _nEnd >= nSrcLen )
	    {
	        return NULL;
	    }
	    else if( _nStart > _nEnd )
	    {
	        return NULL;
	    }

	    for(int i=0; i<(_nEnd - _nStart + 1); i++)
	    {
	        *_pchSubStr++ = *(_pchStr++ + _nStart);
	    }
	    *_pchSubStr = '\0';

	    return _pchFirst;
	}


{% endhighlight %}




### MuitCharFilterToOne 

{% highlight c++ %}

	/*
	*    函数原形    char * MuitCharFilterToOne(char* _pchStr, char _chKey);
	*    表头文件    #include 
	*    函数描述    直接修改原串，将字符串_pchStr中的多个chKey过滤成一个
	*        参 数    _pchStr，原字符串
	*                        _chKey，要过滤的字符
	*     返回值    _pchStr串的首地址。
	*        作 者    武立强
	*        时    间    2009-02-22
	*        备 注    MuitCharFilterToOne(str, char ' '); 将多个空格过滤成一个
	*/
	char * MuitCharFilterToOne(char* _pchStr, char _chKey)
	{
	    assert( NULL != _pchStr);
	    
	    char* pchFirst = _pchStr;
	    int nCount = 0;
	    int nFind = 0; 

	    while( '\0' != *_pchStr )
	    {
	        if( 0 == nFind && _chKey == *_pchStr )
	        {
	            nFind = 1;
	            *(_pchStr - nCount) = *_pchStr; // 向前移动

	        }
	        else if( 1 == nFind && _chKey == *_pchStr )
	        {
	            nCount++;
	        }
	        else
	        {
	            nFind = 0;
	            *(_pchStr - nCount) = *_pchStr; // 向前移动

	        }

	        _pchStr++;
	    }
	    
	    *(_pchStr - nCount) = '\0';

	    return pchFirst;
	}

{% endhighlight %}




### GetKeyStr 

{% highlight c++ %}

	/*
	*    函数原形    char * GetKeyStr(char* _pStr);
	*    表头文件    #include 
	* #include 
	* #include 
	*    函数描述    得到键盘的字符串值
	*        参 数    _pStr，存放生成的字符串
	*     返回值    _pStr串的首地址。
	*        作 者    武立强
	*        时    间    2009-04-03
	*        备 注    
	*/
	char * GetKeyStr(char* _pStr)
	{
	    assert(NULL != _pStr);
	    
	    char ch = getch();
	    if( ch < 0 )
	    {
	        ch = getch();
	        if( 72 == ch )
	        {
	            strcpy(_pStr, "up");
	        }
	        else if( 80 == ch )
	        {
	            strcpy(_pStr, "down");
	        }
	        else if( 75 == ch )
	        {
	            strcpy(_pStr, "left");
	        }
	        else if( 77 == ch )
	        {
	            strcpy(_pStr, "right");
	        }
	    }
	    else if( 13 == ch )
	    {
	        strcpy(_pStr, "enter");
	    }
	    else if( 27 == ch )
	    {
	        strcpy(_pStr, "esc");
	    }
	    else if( 9 == ch )
	    {
	        strcpy(_pStr, "tab");
	    }
	    else if( 8 == ch )
	    {
	        strcpy(_pStr, "backspace");
	    }
	    else if( 32 == ch )
	    {
	        strcpy(_pStr, "space");
	    }
	    else
	    {
	        _pStr[0] = ch;
	        _pStr[1] = '\0';
	    }
	    
	    return _pStr;
	}


{% endhighlight %}



### memmove 

{% highlight c++ %}

	/*
	*    函数原形    void * memmove(void* _pDest, const void* _pSrc, int _nCount);
	*    表头文件    #include 
	*    函数描述    内存移动函数,将内存中的内容从一个地方移动到另一个地方
	*        参 数    _pSrc，源内存首地址
	* _pDest,目的内存首地址
	*     返回值    目的内存首地址
	*        作 者    武立强
	*        时    间    2009-04-08
	*        备 注    
	*/
	void * memmove(void* _pDest, const void* _pSrc, int _nCount)
	{
	    assert( _pDest && NULL != _pSrc);
	    
	    char* pDest = (char*)_pDest;
	    char* pSrc = (char*)_pSrc;

	    for(int i=0; i<_nCount; color: rgb(0, 0, 204); nSrcLen color: rgb(0, 0, 204); nCountbrtabspan style=i++)
	    {
	        pDest[i] = pSrc[i];
	        pSrc[i] = '\0';
	    }

	    return _pDest;
	}


{% endhighlight %}




### memcpy 

{% highlight c++ %}

	/*
	*    函数原形    void * memcpy(void* _pDest, const void* _pSrc, int _nCount);
	*    表头文件    #include 
	*    函数描述    内存拷贝函数,将内存中的内容从一个地方拷贝到另一个地方
	*        参 数    _pSrc，源内存首地址
	*                _pDest,目的内存首地址
	*     返回值    目的内存首地址
	*        作 者    武立强
	*        时    间    2009-04-08
	*        备 注    
	*/
	void * memcpy(void* _pDest, const void* _pSrc, int _nCount)
	{
	    assert( _pDest && NULL != _pSrc);
	    
	    char* pDest = (char*)_pDest;
	    char* pSrc = (char*)_pSrc;

	    for(int i=0; i<_nCount; i++)
	    {
	        pDest[i] = pSrc[i];
	    }

	    return _pDest;
	}

	

{% endhighlight %}



### CheckIsEmailStr 

{% highlight c++ %}

	/*
	*    函数原形 int CheckIsEmailStr(const char* _pStr);
	*    表头文件 #include 
	*    函数描述 检查字符串是否是邮件格式, 即 xxx@xxx格式字符串
	*        参 数 _pStr，字符串的首地址
	*     返回值 0, 正确
	* -1,错误
	* 作 者 武立强
	* 时 间 2009-04-08
	* 备 注 
	*/
	int CheckIsEmailStr(const char* _pStr)
	{
	    assert(NULL != _pStr);

	    if( '\0' == *_pStr)
	    {
	        return (-1);
	    }
	    else
	    {
	        _pStr++;
	    }

	    while( '\0' != *_pStr )
	    {
	        if( '@' == *_pStr && '\0' != *(_pStr+1) )
	        {
	            return 0;
	        }
	        _pStr++;
	    }
	    
	    return (-1);
	}


{% endhighlight %}



### IsPalindrome 

{% highlight c++ %}

	/*
	* 函数原形 int IsPalindrome(const char* _pStr);
	* 表头文件 #include 
	* #include 
	* #include 
	* 函数描述 判断一个字符串是否为回文，用栈的思路实现。
	* 回文，即 abcba 形式，从前后看，字符串都一样。
	* 参数 _pStr，要判断的字符串
	* 返回值 0, 回文
	* -1, 非回文
	* 注释 
	*/
	int IsPalindrome(const char* _pStr)
	{
	    assert( NULL != _pStr );

	    int nStrLen = 0;            // 标志_pStr 的长度

	    int nHalfLen = 0;            // 取其一半长度

	    int nStartIndex = 0;        // 开始比较的下标

	    char* pData = NULL;            // 存储数据首地址



	    nStrLen = strlen(_pStr);
	    if( 1 == nStrLen )
	    {
	        return 0;    // 就一个字符，是回文 

	    }

	    nHalfLen = nStrLen / 2;        // 两个整数相除，结果取整

	    pData = (char*)malloc(sizeof(char)*(nHalfLen + 1));
	    if( NULL == pData )
	    {
	        printf("malloc error...");
	        return (-1);
	    }

	    // 将前一半字符取出

	    for(int i=0; i<nHalfLen; i++)
	    {
	        pData[i] = _pStr[i];
	    }
	    pData[i] = '\0';

	    if( 0 == nStrLen%2 )
	    {
	        // _pStr 长度为偶数时

	        nStartIndex = nHalfLen;
	    }
	    else
	    {
	        // _pStr 长度为奇数时

	        nStartIndex = nHalfLen + 1;
	    }
	    
	    // 逆序比较

	    for(i= nHalfLen -1; i>=0; i--)
	    {
	        if( pData[i] != _pStr[nStartIndex] )
	        {
	            free(pData);        // 返回前释放内存

	            return (-1);
	        }
	        nStartIndex++;
	    }

	    free(pData);
	    return 0;
	} 


{% endhighlight %}



### CheckBracketsIsMatch 

{% highlight c++ %}

	/*
	* 函数原形 int CheckBracketsIsMatch(const char* _pStr);
	* 表头文件 #include 
	* #include 
	* #include 
	* 函数描述 检查一个字符串中的括号是否匹配（用栈的思路实现）
	* 参数 _pStr，要判断的字符串
	* 返回值 0, 匹配
	* -1, 不匹配
	* 注释 
	*/
	int CheckBracketsIsMatch (const char* _pStr)
	{
	    assert( NULL != _pStr );

	    // 过滤字符串，只保留括号字符

	    char* pStr = (char*)malloc(strlen(_pStr) + 1);
	    if( NULL == pStr )
	    {
	        printf("malloc error...");
	        return (-1);
	    }
	    char* pStrFirst = pStr;

	    while( '\0' != *_pStr)
	    {
	        if( *_pStr == '[' || *_pStr == ']' 
	            || *_pStr == '{' || *_pStr == '}' 
	            || *_pStr == '(' || *_pStr == ')')
	        {
	            *pStr = *_pStr ;
	            pStr++;
	        }

	        _pStr++;
	    }
	    *pStr = '\0';
	    pStr = pStrFirst;    // 将指针指向开头

	    
	    int nStrLen = 0;            // 标志 pStr 的长度

	    int nHalfLen = 0;            // 取其一半长度

	    int nStartIndex = 0;        // 开始比较的下标

	    char* pData = NULL;    

	    nStrLen = strlen(pStr);
	    // 判断长度

	    if( 1 == nStrLen || 0 == nStrLen )
	    {
	        free(pStr);
	        return (-1);    // 肯定不匹配

	    }
	    else if( 0 != nStrLen%2 )
	    {
	        // 长度为奇数,肯定不匹配

	        free(pStr);
	        return (-1);        
	    }

	    nHalfLen = nStrLen / 2;        // 两个整数相除，结果取整

	    pData = (char*)malloc(sizeof(char)*(nHalfLen + 1));
	    if( NULL == pData )
	    {
	        printf("malloc error...");
	        free(pStr);
	        return (-1);
	    }

	    // 将前一半字符取出

	    for(int i=0; i<nHalfLen; i++)
	    {
	        pData[i] = pStr[i];
	    }
	    pData[i] = '\0';

	    nStartIndex = nHalfLen;


	    printf("----->%s \n", pStr);
	    printf("----->%s \n", pData);

	    // 逆序比较

	    for(i= nHalfLen -1; i>=0; i--)
	    {
	        if( ('[' == pData[i] && ']' != pStrspan style=span style=;color: rgb(0, 0, 204);[nStartIndex]) 
	            || ('{' == pData[i] && '}' != pStr[nStartIndex]) 
	            || ('(' == pData[i] && ')' != pStr[nStartIndex]) 
	            )
	        {
	            free(pStr);
	            free(pData);        // 返回前释放内存

	            return (-1);        // 不匹配

	        }
	        nStartIndex++;
	    }

	    free(pStr);
	    free(pData);
	    return 0;
	} 


{% endhighlight %}




### BSearch 

{% highlight c++ %}

	/**************************************************
	* 函数名:    BSearch
	* 参数:
	*    形参:
	*        _pList : 顺序存储结构的线性表
	*        _key :    查找关键字
	*        _nLow : 查找范围下界
	*        _nHigh : 查找范围上界
	* 返回值:    查找结果，-1表示查找失败，否则为查找到的元素下标
	* 功能:
	*        对顺序存储结构的线性表进行递归二分查找
	* 作者:        左建华
	* 编写明细:
	*        2008-05-29    Created        左建华
	*    
	**************************************************/
	int BSearch(SeqList* _pList, DataType _key, int _nLow, int _nHigh)
	{    
	    if( _nLow>_nHigh )
	    {
	         return -1;    
	    }

	    int nMiddle = (_nLow+_nHigh)/2;
	    if( _pList->data[nMiddle] == _key )
	    {
	        return nMiddle;
	    }
	    
	    if( _pList->data[nMiddle] > _key )
	    {
	         return BSearch( _pList, _key, _nLow, nMiddle-1 );
	    } 
	    else
	    {
	         return BSearch( _pList, _key, nMiddle+1, _nHigh );
	    }
	}


{% endhighlight %}




### DeleteRepeat 

{% highlight c++ %}

	/*
	* 函数原形 void DeleteRepeat(LinkList* _pHead);
	* 表头文件 #include 
	* #include 
	* 函数描述 删除链表中重复的数据，只保留一个
	* 参数 _pHead，链表头结点指针
	* 返回值 void
	* 注释 例如，链表中数据11123，运行此函数后数据变成123
	*/
	void DeleteRepeat(LinkList _pHead)
	{
	    assert( NULL != _pHead );
	    
	    Node* pHere = NULL;
	    Node* pHereLast = NULL;        // 当前结点

	    Node* pNode = _pHead;        // 当前结点的上一个结点


	    while(pNode)
	    {
	        pHere = pNode->next;    
	        pHereLast = pNode;        
	        while(pHere)            // 从pHere 开始，一直到链表结束

	        {
	            if(pHere->data == pNode->data)
	            {
	                // 重复数据结点,删除

	                pHereLast->next = pHere->next;
	                free(pHere);
	                pHere = pHereLast;
	            }
	            pHereLast = pHere;
	            pHere = pHere->next;
	        }
	        pNode = pNode->next;
	    }
	}

{% endhighlight %}



### Convert 

{% highlight c++ %}

	/*
	* 函数原形 int Convert(int _nNum, int _nB, char* _pOutStr);
	* 表头文件 #include 
	* 函数描述 将十进制的 Num (只能是正数)转换成 B 进制数，
	* 以字符串的形式输出结果
	* 参数 _nNum，使进制数
	* _nB，表示要转换为 B 进制
	* _pOutStr，（输出参数）转换后的字符串，要有足够的空间容纳转换后的字符串 
	* 返回值 0，成功
	* -1，失败
	* 注释 目前不支持负数。 思路：Num 除 B 取余到排
	*/
	int Convert(int _nNum, int _nB, char* _pOutStr)
	{
	    if( _nNum < 0 )
	    {
	        return (-1);
	    }
	    if( 0 == _nNum )
	    {
	        *_pOutStr = '0';
	        return 0;
	    }
	    
	    int nTemp = _nNum;
	    int nLen = 0;            //转换后的数的位数


	    // 计算转换后的数的位数

	    while( 1 != nTemp )
	    {
	        nTemp /= 2;
	        nLen++;
	    }
	    nLen += 1;
	    
	    int* pB = (int*)malloc(sizeof(int)*nLen);
	    if( NULL == pB )
	    {
	        return (-1);
	    }
	    
	    nTemp = _nNum;
	    for(int i=0; i<nLen; i++)
	    {
	        pB[i] = nTemp % 2;
	        nTemp /= 2;
	    }

	    // 输出转换后的 B 进制数(逆序输出)

	    for(i=nLen-1; i>=0; i--)
	    {
	        _pOutStr[(nLen-1) - i] = pB[i] + '0';    // 将整数转换为字符

	    }
	    _pOutStr[nLen] = '\0';

	    free(pB);
	    return 0;
	}

{% endhighlight %}



