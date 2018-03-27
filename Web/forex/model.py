import web

db = web.database(dbn='mysql', user='zgying', pw='soya21SOYA21', host='forexdog.cvzux6ajk8wf.us-east-1.rds.amazonaws.com',db='forex')

def append(huobi,shijian,open,high,low,close,volumn):
   db.insert('HangQing', HuoBiDui=huobi,ShiJian=shijian,Open=open,High=high,Low=low,Close=close,Volumn=volumn)


#def append(huobi,shijian):
#    db.insert('HangQing', HuoBiDui=huobi,ShiJian=shijian)
