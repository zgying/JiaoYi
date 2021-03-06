//+------------------------------------------------------------------+
//|                                               压力阻力线交易.mq4 |
//|                                                           zgying |
//|                                             https://www.mql5.com 
//---查看当前订单，
   //有订单，
      // 满足止盈条件 关闭
      // 满足止损条件 关闭
      
   //没订单
      //操作模式
         //做震荡
            //压力
               //到达位置，做空
            
            //阻力
               //到达位置，做多
         
         //做突破
            //压力
               //到达位置，做空
            //阻力
               //到达位置，做多|
//+------------------------------------------------------------------+

#property copyright "zgying"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


//EA ID
#define EAID     "EA20171027"
#define MAGICMA  20171027

#include "..\Include\mylib.mqh"

//任务状态
int   TaskStatue = 0;

//---  Inputs
input string TaskServer = "http://54.146.141.130/"; //网站
input int    Interval = 10;   //10秒


//常量
//是否启用，货币对，压力线、阻力线，操作模式（做震荡，做突破？）,
//止盈止损？，止盈止损位置？

int    TakeProfit       = 5;             //单笔利润止盈
double Lots          = 0.1;            //数量
double MaximumRisk   = 0.02;           //风险系数

int    EAMode        = 2;              //是否启用  1, 清仓·  2 策略运行 
string HuoBiDui       = "";            //货币对
int    HuaDian       = 10;             //允许滑点
int    CaoZuoLX      = 0;              //操作类型  1 震荡  2 突破 3 震荡+突破 
double YaLi          = 0.0;            //压力线
double ZhuLi         = 0.0;            //阻力线
//--- input parameters

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer( Interval );     
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

//close all order
void OperClear()
{
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      //not ea order ,not ea symbol , do nothing;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
      if(OrderType()== OP_BUY )
        {
         if(!OrderClose(OrderTicket(),OrderLots(),Bid,HuaDian,White))
               Print("OrderClose error ",GetLastError());         
        }
       if(OrderType()==OP_SELL)
         {
          if(!OrderClose(OrderTicket(),OrderLots(),Ask,HuaDian,White))
               Print("OrderClose error ",GetLastError());
         }
     }
        
   return;
} 

// 有定单，判断是否止盈
void OperCheckforTakeProfit()
{
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;

   
      // 满足止盈条件 关闭
      // --todo 满足止损条件 关闭        
      PrintFormat( " %s: CheckProfit %.2f " , TimeToString(TimeCurrent()), OrderProfit() );      
      if( OrderProfit() > TakeProfit )
        {
         if(OrderType()==OP_BUY)
           {
            if(!OrderClose(OrderTicket(),OrderLots(),Bid,HuaDian,White))            
               Print("OrderClose error ",GetLastError());
            else
              {
               //TaskComplete();
               
               PrintFormat(" 订单止盈关闭:  OrderTicket: %d, Bid: %.5f  ", OrderTicket(),Bid);
              }
           }
           
          if(OrderType()==OP_SELL)
            {
             if(!OrderClose(OrderTicket(),OrderLots(),Ask,HuaDian,White))
               Print("OrderClose error ",GetLastError());
             else
               {
                //TaskComplete();
                PrintFormat(" 订单止盈关闭:  OrderTicket: %d, Bid: %.5f  ", OrderTicket(),Ask);
               }
            }
        }                  
     }
   return;
}


// //没订单
void OperCheckforOpen()
{
   
      int ticket;      
      //操作模式
      //震荡
      
      PrintFormat(" %s OperCheckforOpen: %d,%.5f,%.5f,%.5f,%.5f, ", TimeToString(TimeCurrent()),CaoZuoLX,YaLi,ZhuLi,Bid,Ask );
      if(CaoZuoLX==1)
       {
        // 买价大于压力线 =   突破压力线
         if( YaLi >0 && Bid >= YaLi)
           {
            //做空
             ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,HuaDian,0,0,"突破压力线",MAGICMA,0,Red);
             if(ticket<0) 
              Print("OrderSend failed with error #",GetLastError());              
             else 
              PrintFormat(" 下单成功：震荡模式：突破压力线 做空 Price：%.5f， Lots：%.2f", Bid,Lots ); 
           }
        //卖价低于阻力线  ==  突破阻力
          if( Ask >0 && ZhuLi >= Ask)
            {
            //做多
             ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,HuaDian,0,0,"突破阻力线",MAGICMA,0,Blue);
             if(ticket<0) 
              Print("OrderSend failed with error #",GetLastError());              
             else 
              PrintFormat(" 下单成功：震荡模式：突破阻力线 做多 Price：%.5f， Lots：%.2f", Bid,Lots ); 
             
            }
       }
       //突破
       if(CaoZuoLX==2)
       {        
        // 买价大于压力线 =   突破压力线
         if(  YaLi >0 && Bid >= YaLi  )
           {
            //做多
             ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,HuaDian,0,0,"突破阻力线",MAGICMA,0,Blue);
             if(ticket<0) 
              Print("OrderSend failed with error #",GetLastError());              
             else 
              PrintFormat(" 下单成功：突破模式：突破压力线 做多 Price：%.5f， Lots：%.2f", Bid,Lots ); 
           }
        //卖价低于阻力线  ==  突破阻力
          if( ZhuLi >0 && ZhuLi >= Ask )
            {
           //做空
             ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,HuaDian,0,0,"突破压力线",MAGICMA,0,Red);
             if(ticket<0) 
              Print("OrderSend failed with error #",GetLastError());              
             else 
              PrintFormat(" 下单成功：突破模式：突破阻力线 做空 Price：%.5f， Lots：%.2f", Bid,Lots ); 
            }        
       }
       
       
            //压力
               //到达位置，做空
            
            //阻力
               //到达位置，做多
         
         //做突破
            //压力
               //到达位置，做多
            //阻力
               //到达位置，做空
}


//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
      
      //PrintFormat("%s: Symbol: %s, OnTick: Ask: %.5f,  Bid: %.5f,Bars %d" ,TimeToString(TimeCurrent()),Symbol(),Ask,Bid,Bars);   
      if(Symbol() != HuoBiDui )
         return;
       
      //有效性检查     
      if(Bars<50 || IsTradeAllowed()==false)
         return;
         
      PrintFormat(" %s OperCheckforOpen: %d,%.5f,%.5f,%.5f,%.5f, ", TimeToString(TimeCurrent()),CaoZuoLX,YaLi,ZhuLi,Bid,Ask );   
         
      //满足盈利条件，止盈
      OperCheckforTakeProfit();   
         
      //判断操作要求
      switch(EAMode) 
      { 
     
      case 1:     
            //清空所有订单
            OperClear();            
      case 2:    
            //根据操作策略和压力阻力线进行操作
            if(CalculateCurrentOrders(Symbol(),MAGICMA)==0) 
               OperCheckforOpen();        
      default: 
         return;
      }
  }


//+------------------------------------------------------------------+
//| 从网站获取压力阻力和策略
//+------------------------------------------------------------------+
void GetCommandFromWeb()
{
   string cookie=NULL,headers; 
   char post[],result[]; 
   int res; 
   
   ResetLastError(); 
   int timeout=5000; 
   
   res=WebRequest("GET",TaskServer,cookie,NULL,timeout,post,0,result,headers); 
   
   if(res==-1) 
     { 
      Print("Error in WebRequest. Error code  =",GetLastError());       
     } 
   else 
     { 

      //[{"TaskID":"1","HuoBiDui":"EURCHF","HuaDian":"10","CaoZuoLX":"1","YaLi":"1.16","ZhuLi":"1.155","ZhuanTai":"1"}]  
      string str = CharArrayToString(result);//jv.toString();           
      string keys[],vals[];
     
      json2array(str,keys,vals);
                
      HuoBiDui      = getValbyKey( "HuoBiDui", keys,vals) ;  // jo.getString("HuoBiDui");             //货币对
      HuaDian       = StringToInteger(getValbyKey( "HuaDian", keys,vals));              //允许滑点
      CaoZuoLX      = StringToInteger(getValbyKey( "CaoZuoLX", keys,vals));               //操作类型  1 震荡  2 突破
      YaLi          = StringToDouble( getValbyKey( "YaLi", keys,vals) );               //压力线
      ZhuLi         = StringToDouble( getValbyKey( "ZhuLi", keys,vals) );              //阻力线
      TakeProfit    = StringToInteger(getValbyKey( "TakeProfitAsUSD", keys,vals));              //允许滑点
      
      
      
      string logs = StringFormat(" %s: HuoBiDui:%s,HuaDian:%d, CaoZuoLX:%d,YaLi:%f,ZhuLi:%f ", TimeToString(TimeCurrent()), HuoBiDui, HuaDian, CaoZuoLX, YaLi, ZhuLi );
      PrintFormat(" %s: HuoBiDui:%s,HuaDian:%d, CaoZuoLX:%d,YaLi:%.5f,ZhuLi:%.5f,TakeProfit %d ", TimeToString(TimeCurrent()), HuoBiDui, HuaDian, CaoZuoLX, YaLi, ZhuLi,TakeProfit );
      
      
     }
}


//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
   //---定时从网站获取命令要求   
   GetCommandFromWeb();

   
   
  }
//+------------------------------------------------------------------+
