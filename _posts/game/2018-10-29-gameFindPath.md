---
layout: post
title:  "地图寻路算法封装"
date:   2018-10-29
categories: game
tags: game 源码 cocos2d-x 寻路算法
---

* content
{:toc}



### 下载代码

[游戏寻路算法>>>]({{ site.url }}/assets/open-src/base/BaseStepPathFinder.zip)

---


### 捐赠本站

您的支持是我们坚持的动力。 
[捐赠地址>>>](https://openbook.wiki/about/#%E6%8D%90%E8%B5%A0%E6%9C%AC%E7%AB%99)



## 寻路代码 

{% highlight C++ %}


/*
 *  BaseStepPathFinder.h
 *  CCGame
 *
 *  Created by linux_wuliqiang@163.com on 2015-03-30.
 *  Copyright 2015 Beijing. All rights reserved.
 *
 *	最优寻路算法，可以设置最多行走步数限制
 *
 *
 *	备注说明：寻路前，必须先 MapDataClear 重置地图数据，确保一个干净的地图寻路数据
 *
 *	使用举例：
 *
 *
 */
#import "Base.h"
#ifndef __BaseStepPathFinder_H__
#define __BaseStepPathFinder_H__
#define  BaseStepPathFinder_MaxHeight	1000		// 寻路最大高度
class BaseStepPathFinder
{
    
public:     // 构造析构函数
    BaseStepPathFinder();      
    ~BaseStepPathFinder();
    
    static BaseStepPathFinder* Instance();
    
public:     
    
    /*
     *  寻路前，必须调用 InitMapData 先进行初始化，然后才可以寻路
     */
    void        InitMapData(int _mapWidth, int _mapHeight);
    void        FreeMapData();
    
    /*
     *  设置地图数据中的某一个点，是否可以通过
     */
    void        SetPass(BasePoint _mapGrid, bool _isCanPass);
    
    /*
     *  网格点是否可以通过
     */
    bool        IsPass(BasePoint _mapGrid);
    
    /*
     *	函数说明：	寻路查找，输出最优路径到数组中
     *	参数说明：	_startMapGrid, 起始网格点
     *				_targetMapGrid, 目标网格点
     *				_maxMoveStep, 限制最大的移动步数
     *				_outArray, （输出参数）寻路查找的结果, 存储 BasePointInt 对象
     *	函数返回：	返回 _outArray 数组中 元素的个数
     *
     *	备注说明：	地势，从低到高查找
     *
     *
     */
    int         FindPath(BasePoint _startMapGrid ,BasePoint _targetMapGrid, int _maxMoveStep, vector<BasePoint>* _outArr);
    
    
    
    /*
     *	函数说明：	输出所有的可以行走网格点到数组中, 以 _startMapGrid 点为中心点， _maxMoveStep 为移动步数，输出所有的可以移动到的网格点
     *	参数说明：	_startMapGrid, 起始网格点
     *				_maxMoveStep, 限制最大的移动步数
     *				_outArray, （输出参数）寻路查找的结果, 存储 BasePointInt 对象
     *	函数返回：	返回 _outArray 数组中 元素的个数
     *
     *	备注说明：	地势从高向低查找
     *
     */
    int         FindAllPath(BasePoint _startMapGrid, int _maxMoveStep,  vector<BasePoint>* _outArr);
    
    
  
    
    /*
     *  调试输出
     */
    int         DebugPrintMapData();
    
private:
    
    void        SetMapData(BasePoint _mapGrid, int _value);
    int         GetMapData(BasePoint _mapGrid);
    
    
    /*
     *	函数说明：	寻路查找，在查找过程中，不断设置地形的高度
     *	参数说明：	_targetMapGrid, 目标网格点，在开始的时候，设置地形高度为 0
     *				_maxHeight, 限制最大的移动步数
     *	函数返回：	0
     *
     *	备注说明：	每增加一步，高度 +1
     *
     */
    int         Find(BasePoint _targetMapGrid, int _currHeight, int _maxHeight);
    
    /*
     *  类内部调用, 从高地形，向低地形查找
     */
    int         SetPathToArray(BasePoint _startMapGrid,  vector<BasePoint>* _outArr);
    
    /*
     *  查找并设置所有的可以行走的点 (地势从高向低进行查找)
     *  注意，_maxMoveStep 越大，距离中心位置越近
     *  _maxMoveStep 越小，距离中心位置越远
     */
    int         SetAllPathToArray(BasePoint _startMapGrid, int _maxMoveStep, vector<BasePoint>* _outArr);
    
    /*
     *  清除寻路数据为初始化状态
     */
    void        MapDataClear();
    
    /**
     *  临时寻路数据设置
     */
    void        MapDataSetPass(BasePoint _mapGrid, bool _isCanPass);
    bool        MapDataIsPass(BasePoint _mapGrid);
    
private:
    
    int			mapWidth;		// 地图的宽度
	int			mapHeight;		// 地图的高度
	
	int**		pMapData;		// 地图数据（－1，表示不能通过 >=0, 表示可以通过）--- 当前使用的寻路地图 (临时寻路数据)
	int**		pMapDataInit;	// 地图数据 --- 初始的地图通行状态
	
	int			currSearchHeight;	// 当前搜索的地形的高度
    
};
#endif // __BaseStepPathFinder_H__



#include "BaseStepPathFinder.h"
static BaseStepPathFinder* gBaseStepPathFinder = NULL;

BaseStepPathFinder* BaseStepPathFinder::Instance()
{
    if(NULL == gBaseStepPathFinder)
    {
        gBaseStepPathFinder = new BaseStepPathFinder();
    }
    
    return gBaseStepPathFinder;
}
BaseStepPathFinder::BaseStepPathFinder()
{
    mapWidth = 0;
	mapHeight = 0;
	
	pMapData = NULL;
	pMapDataInit = NULL;
	
	currSearchHeight = 0;	
}
BaseStepPathFinder::~BaseStepPathFinder()
{
    FreeMapData();
}
void BaseStepPathFinder::InitMapData(int _mapWidth, int _mapHeight)
{
    if(_mapWidth <=0 || _mapHeight <= 0) return;
	
	FreeMapData();		// 先清除
	
	mapWidth = _mapWidth;
	mapHeight = _mapHeight;
	
	pMapData = MALLOCXX(mapHeight, mapWidth, int);
	pMapDataInit = MALLOCXX(mapHeight, mapWidth, int);
	
	for(int i=0; i<ARRLEN(pMapData); i++)   // 行
	{
		for(int j=0; j<ARRLEN(pMapData[i]); j++) // 列
		{
			pMapData[i][j] = BaseStepPathFinder_MaxHeight;		// 默认可以通过
			pMapDataInit[i][j] = BaseStepPathFinder_MaxHeight;	// 默认可以通过
		}
	}
}
void BaseStepPathFinder::FreeMapData()
{
    FREEXX(pMapData);
	FREEXX(pMapDataInit);
	
	mapWidth = 0;
	mapHeight = 0;
}
void BaseStepPathFinder::SetPass(BasePoint _mapGrid, bool _isCanPass)
{
    int mapGridX = _mapGrid.x;
	int mapGridY = _mapGrid.y;
	
	if(mapGridX < 0 || mapGridX >= mapWidth)	return;
	if(mapGridY < 0 || mapGridY >= mapHeight)	return;
	
	if(mapGridY < ARRLEN(pMapDataInit) && mapGridX < ARRLEN(pMapDataInit[mapGridY]) )  // 防止数组越界
	{
		if(_isCanPass)
		{
			pMapDataInit[mapGridY][mapGridX] = BaseStepPathFinder_MaxHeight;
		}
		else
		{
			pMapDataInit[mapGridY][mapGridX] = -1;	// 不可以通过
		}
	} 
}
void  BaseStepPathFinder::MapDataSetPass(BasePoint _mapGrid, bool _isCanPass)
{
    int mapGridX = _mapGrid.x;
	int mapGridY = _mapGrid.y;
	
	if(mapGridX < 0 || mapGridX >= mapWidth)	return;
	if(mapGridY < 0 || mapGridY >= mapHeight)	return;
	
	if(mapGridY < ARRLEN(pMapData) && mapGridX < ARRLEN(pMapData[mapGridY]) )  // 防止数组越界
	{
		if(_isCanPass)
		{
			pMapData[mapGridY][mapGridX] = BaseStepPathFinder_MaxHeight;
		}
		else
		{
			pMapData[mapGridY][mapGridX] = -1;	// 不可以通过
		}
	}
}

void BaseStepPathFinder::SetMapData(BasePoint _mapGrid, int _value)
{
    int mapGridX = _mapGrid.x;
	int mapGridY = _mapGrid.y;
	
	if(mapGridX < 0 || mapGridX >= mapWidth)	return;
	if(mapGridY < 0 || mapGridY >= mapHeight)	return;
	
	if(mapGridY < ARRLEN(pMapData) && mapGridX < ARRLEN(pMapData[mapGridY]) )  // 防止数组越界
	{
		pMapData[mapGridY][mapGridX] = _value;
	}
}
int BaseStepPathFinder::GetMapData(BasePoint _mapGrid)
{
    int mapGridX = _mapGrid.x;
	int mapGridY = _mapGrid.y;
	
	if(mapGridX < 0 || mapGridX >= mapWidth)	return (-1);
	if(mapGridY < 0 || mapGridY >= mapHeight)	return (-1);
	
	if(mapGridY < ARRLEN(pMapData) && mapGridX < ARRLEN(pMapData[mapGridY]) )  // 防止数组越界
	{
		return pMapData[mapGridY][mapGridX];
	}
	
	return (-1);
}
bool BaseStepPathFinder::IsPass(BasePoint _mapGrid)
{
    int mapGridX = _mapGrid.x;
	int mapGridY = _mapGrid.y;
	
	if(mapGridX < 0 || mapGridX >= mapWidth)	return false;
	if(mapGridY < 0 || mapGridY >= mapHeight)	return false;
	
	if(mapGridY < ARRLEN(pMapDataInit) && mapGridX < ARRLEN(pMapDataInit[mapGridY]) )  // 防止数组越界
	{
		if(pMapDataInit[mapGridY][mapGridX] >= 0)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
	return false;
}
bool BaseStepPathFinder::MapDataIsPass(BasePoint _mapGrid)
{
    int mapGridX = _mapGrid.x;
	int mapGridY = _mapGrid.y;
	
	if(mapGridX < 0 || mapGridX >= mapWidth)	return false;
	if(mapGridY < 0 || mapGridY >= mapHeight)	return false;
	
	if(mapGridY < ARRLEN(pMapData) && mapGridX < ARRLEN(pMapData[mapGridY]) )  // 防止数组越界
	{
		if(pMapData[mapGridY][mapGridX] >= 0)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
	return false;
}

void BaseStepPathFinder::MapDataClear()
{
    for(int i=0; i<ARRLEN(pMapData); i++)   // 行
	{
		for(int j=0; j<ARRLEN(pMapData[i]); j++) // 列
		{
			pMapData[i][j] = pMapDataInit[i][j];
		}
	}
}

int BaseStepPathFinder::FindAllPath(BasePoint _startMapGrid, int _maxMoveStep,  vector<BasePoint>* _outArr)
{
    if(NULL == _outArr) return 0;
	if(_maxMoveStep <= 0) return 0;
	
	// 是否越界
	if(_startMapGrid.x < 0 || _startMapGrid.x >= mapWidth)	return 0;
	if(_startMapGrid.y < 0 || _startMapGrid.y >= mapHeight)	return 0;
	
	_outArr->clear();// 先清除
	MapDataClear();
    
    MapDataSetPass(_startMapGrid, true);// 设置当前点可以通过
	SetAllPathToArray(_startMapGrid, _maxMoveStep, _outArr);
	
	return _outArr->size();
}
int BaseStepPathFinder::FindPath(BasePoint _startMapGrid ,BasePoint _targetMapGrid, int _maxMoveStep, vector<BasePoint>* _outArr)
{
    if(NULL == _outArr) return 0;
	if(_maxMoveStep <= 0) return 0;
	
	// 是否越界
	if(_startMapGrid.x < 0 || _startMapGrid.x >= mapWidth)	return 0;
	if(_startMapGrid.y < 0 || _startMapGrid.y >= mapHeight)	return 0;
	
	if(_targetMapGrid.x < 0 || _targetMapGrid.x >= mapWidth)	return 0;
	if(_targetMapGrid.y < 0 || _targetMapGrid.y >= mapHeight)	return 0;
	
    
    _outArr->clear();// 先清除
    MapDataClear();
    
    MapDataSetPass(_startMapGrid, true);    // 当前点可以过
    MapDataSetPass(_targetMapGrid, true);   // 目标点可以过
    
	
	//DebugPrintMapData();
    Find(_targetMapGrid, 0, _maxMoveStep);// 目标点高度从0 开始
	//DebugPrintMapData();
	
    
	// 成功找到目标点
	if( GetMapData(_startMapGrid) <  BaseStepPathFinder_MaxHeight)
	{
		currSearchHeight = GetMapData(_startMapGrid);
        SetPathToArray(_startMapGrid, _outArr);
	}
	
	return _outArr->size();
}
int BaseStepPathFinder::Find(BasePoint _targetMapGrid, int _currHeight, int _maxHeight)
{
    if(_currHeight > _maxHeight) return 0;
	
	// 是否越界
	if(_targetMapGrid.x < 0 || _targetMapGrid.x >= mapWidth)	return 0;
	if(_targetMapGrid.y < 0 || _targetMapGrid.y >= mapHeight)	return 0;
	
	// 当前网格点
	int mapGridX = _targetMapGrid.x;
	int mapGridY = _targetMapGrid.y;
	
	
	if(mapGridY < ARRLEN(pMapData) && mapGridX < ARRLEN(pMapData[mapGridY]) )  // 防止数组越界
	{
		// 不可以通过
		if(pMapData[mapGridY][mapGridX] < 0)
		{
			return 0;
		}
		// 不是最优路径
		if(_currHeight >= pMapData[mapGridY][mapGridX])
		{
			return 0;
		}
		
		pMapData[mapGridY][mapGridX] = _currHeight;
		
		// 递归调用(越往后，高度越大)
        Find(BasePoint(mapGridX-1, mapGridY), _currHeight+1, _maxHeight);  // 左边
        Find(BasePoint(mapGridX+1, mapGridY), _currHeight+1, _maxHeight);  // 右边
        Find(BasePoint(mapGridX, mapGridY+1), _currHeight+1, _maxHeight);  // 上边
        Find(BasePoint(mapGridX, mapGridY-1), _currHeight+1, _maxHeight);  // 下边
	}
	
	return 0;
}
int BaseStepPathFinder::SetPathToArray(BasePoint _startMapGrid,  vector<BasePoint>* _outArr)
{
    //if(NULL == _outArr) return 0;   // 在外面判断
	if(currSearchHeight < 0) return 0;
	
	// 是否越界
	if(_startMapGrid.x < 0 || _startMapGrid.x >= mapWidth)	return 0;
	if(_startMapGrid.y < 0 || _startMapGrid.y >= mapHeight)	return 0;
	
	// 当前网格点
	int mapGridX = _startMapGrid.x;
	int mapGridY = _startMapGrid.y;
	
	if(mapGridY < ARRLEN(pMapData) && mapGridX < ARRLEN(pMapData[mapGridY]) )  // 防止数组越界
	{
		// 不可以通过
		if(pMapData[mapGridY][mapGridX] < 0)
		{
			return 0;
		}
		
		// 非最优路径（不可以行走,只能往低处走）
		if(pMapData[mapGridY][mapGridX] > currSearchHeight)
		{
			return 0;
		}
		
		// 添加到行走数组中
        _outArr->push_back(BasePoint(mapGridX, mapGridY));
        
		currSearchHeight--;   // 地形高度
		
		// 递归调用 (不断向低处走)
        SetPathToArray(BasePoint(mapGridX-1, mapGridY), _outArr);     // 左边
        SetPathToArray(BasePoint(mapGridX+1, mapGridY), _outArr);     // 右边
        SetPathToArray(BasePoint(mapGridX, mapGridY+1), _outArr);     // 上边
        SetPathToArray(BasePoint(mapGridX, mapGridY-1), _outArr);     // 下边
	}
	
	return 0;
}
int BaseStepPathFinder::SetAllPathToArray(BasePoint _startMapGrid, int _maxMoveStep, vector<BasePoint>* _outArr)
{
    //if(NULL == _outArr) return 0; // 在外面判断
	if(_maxMoveStep < 0) return 0;
	
	// 是否越界
	if(_startMapGrid.x < 0 || _startMapGrid.x >= mapWidth)	return 0;
	if(_startMapGrid.y < 0 || _startMapGrid.y >= mapHeight)	return 0;
	
	// 当前网格点
	int mapGridX = _startMapGrid.x;
	int mapGridY = _startMapGrid.y;
    
    if(mapGridY < ARRLEN(pMapData) && mapGridX < ARRLEN(pMapData[mapGridY]) )  // 防止数组越界
	{
		// 不可以通过
		if(pMapData[mapGridY][mapGridX] < 0)
		{
			return 0;
		}
        
        // 当前网格已经被查找过
		if(pMapData[mapGridY][mapGridX] < BaseStepPathFinder_MaxHeight)
		{
            // 当前查找，是从远处返回来的 （注意，_maxMoveStep 越大，距离中心位置越近）
            if(_maxMoveStep <= pMapData[mapGridY][mapGridX])
            {
                return 0;
            }
		}
        
        // 第一次找到该点
        if(BaseStepPathFinder_MaxHeight == pMapData[mapGridY][mapGridX])
        {
            // 添加到行走数组中
            _outArr->push_back(BasePoint(mapGridX, mapGridY));
        }
        
        pMapData[mapGridY][mapGridX] = _maxMoveStep;  // 更新地势
        
		// 递归调用(越往后，高度越小)
        SetAllPathToArray(BasePoint(mapGridX-1, mapGridY), _maxMoveStep-1, _outArr);  // 左边
        SetAllPathToArray(BasePoint(mapGridX+1, mapGridY), _maxMoveStep-1, _outArr);  // 右边
        SetAllPathToArray(BasePoint(mapGridX, mapGridY+1), _maxMoveStep-1, _outArr);  // 上边
        SetAllPathToArray(BasePoint(mapGridX, mapGridY-1), _maxMoveStep-1, _outArr);  // 下边
	}
    
	return 0;
}
int BaseStepPathFinder::DebugPrintMapData()
{
#ifdef GAME_DEBUG_MODE
	
	printf("BaseStepPathFinder->DebugPrintMapData, Start \n");
	
	int mapGridY = 0;
	int mapGridX = 0;
	
	for (mapGridY=0; mapGridY< ARRLEN(pMapData) && mapGridY <1; mapGridY++)  // 打印 1行
	{
		printf("----------------------------------------  \n");
		for (mapGridX=0 ; mapGridX< ARRLEN(pMapData[mapGridY]); mapGridX++) // 列
		{
			printf("%02d", mapGridX);
		}
		printf("\n");
	}
    
    printf("pMapDataInit Table: \n");
	
	for (mapGridY=0; mapGridY< ARRLEN(pMapDataInit); mapGridY++)  // 行
	{
		printf("%02d ", mapGridY);
		
		for (mapGridX=0 ; mapGridX< ARRLEN(pMapDataInit[mapGridY]); mapGridX++) // 列
		{
			if(pMapDataInit[mapGridY][mapGridX] < 0)
			{
				printf("X ");  // 不可以通过
			}
			else if(pMapDataInit[mapGridY][mapGridX] < BaseStepPathFinder_MaxHeight)
			{
				printf("* "); // 已经查找过
			}
			else
			{
				printf("@ "); // 可以通过
			}
			
		}
		
		printf("\n");
	}
	
	
	printf("pMapData Table: value \n");
	for (mapGridY=0; mapGridY< ARRLEN(pMapData); mapGridY++)  // 行
	{
		printf("%02d ", mapGridY);
		
		for (mapGridX=0 ; mapGridX< ARRLEN(pMapData[mapGridY]); mapGridX++) // 列
		{
			if(pMapData[mapGridY][mapGridX] < 0)
			{
				printf("X ");  // 不可以通过
			}
			else if(pMapData[mapGridY][mapGridX] < BaseStepPathFinder_MaxHeight)
			{
				printf("%02d", pMapData[mapGridY][mapGridX]); // 已经查找过
			}
			else
			{
				printf("@ "); // 可以通过
			}
		}
		
		printf("\n");
	}
	
	
	printf("pMapData Table: (通行能力, O 表示可以行走点) \n");
	for (mapGridY=0; mapGridY< ARRLEN(pMapData); mapGridY++)  // 行
	{
		printf("%02d ", mapGridY);
		
		for (mapGridX=0 ; mapGridX< ARRLEN(pMapData[mapGridY]); mapGridX++) // 列
		{
			if(pMapData[mapGridY][mapGridX] < 0)
			{
				printf("X ");  // 不可以通过
			}
			else if(pMapData[mapGridY][mapGridX] < BaseStepPathFinder_MaxHeight)
			{
				printf("* "); // 已经查找过
			}
			else
			{
				printf("@ "); // 可以通过
			}
            
		}
		
		printf("\n");
	}
	
	printf("BaseStepPathFinder->DebugPrintMapData, End \n\n\n");
	
#endif
	
	return 0;
}




{% endhighlight %}






