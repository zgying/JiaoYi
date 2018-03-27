import web
import model

urls = (
    '/', 'Index'        
)


class Index:    
    def GET(self):
        return "it is index"
    
    def POST(self):
        d = web.input();
        model.append(d.huobi,d.shijian,d.open,d.high,d.low,d.close,d.volumn)
##        model.append(d.huobi,d.shijian)
        return web.seeother('/')

if __name__ == '__main__':
    app = web.application(urls, globals())
    app.run()