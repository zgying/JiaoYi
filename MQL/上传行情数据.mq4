//+------------------------------------------------------------------+
//|                                                       上传行情数据.mq4 |
//|                                                           zgying |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "zgying"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//--- input parameters
input string   kaishirq;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
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
//---行情变化的时候，上传当前信息
      
// http://localhost:8080/?huobidui=EURCHF&shijian=201712011232&open=1.54525&high=1.54365&low=8.25454&close=1.5455&volumn=5426
   string url = "http://localhost:8080/?";   
   string str = StringFormat("huobidui=%s&shijian=%s&open=%.5f&high=%.5f&low=%.5f&close=%.5f&volumn=%d", Symbol(),TimeToString(TimeCurrent()),Open[1],High[1],Low[1],Close[1],Volume[1]);
   printf(str);

   
  }
//+------------------------------------------------------------------+
