//+------------------------------------------------------------------+
//|                                                      监控连续小阴阳.mq4 |
//|                                                           zgying |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "zgying"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);
      
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
      
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   printf(" %s, OnChartEvent. ",TimeToStr(TimeCurrent()));
   
   //判断连续小阴阳
   int n 
   最近n个
      open，close 相差不大? <10
         open 越来越高
         close 越来越高
         high 很少
         close  很少
   
  }
//+------------------------------------------------------------------+
