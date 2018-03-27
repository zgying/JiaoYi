//+------------------------------------------------------------------+
//|                                                       updata.mq4 |
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
  

void upload()
{
   string cookie=NULL,headers;
   char post[],result[];
   int res;   
   string baseurl = "http://52.90.65.55/?";   
   string urlstr = StringFormat("huobi=%s&shijian=%s&open=%.5f&high=%.5f&low=%.5f&close=%.5f&volumn=%d", Symbol(),TimeToString(TimeCurrent()),Open[1],High[1],Low[1],Close[1],Volume[1]);
   //string urlstr = StringFormat("huobi=%s&shijian=%s", Symbol(),TimeToString(TimeCurrent(),TIME_MINUTES));
   printf( baseurl + urlstr);
   
   ResetLastError();

   int timeout=5000; 
   
   res=WebRequest("POST", baseurl + urlstr,cookie,NULL,timeout,post,0,result,headers);
   
   if(res==-1)
     {
      Print("Error in WebRequest. Error code  =",GetLastError());      
     }
   else
   {
      printf("return : %d  %s",res,CharArrayToString(result));
   }   

}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
   
      upload();
      
  }


