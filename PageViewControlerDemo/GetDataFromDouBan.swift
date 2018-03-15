//
//  GetDataFromDouBan.swift
//  PageViewControlerDemo
//
//  Created by min-mac on 16/3/12.
//  Copyright © 2016年 EgeTart. All rights reserved.
//

import Foundation
import Alamofire   //导入Alamofire, 以便执行网络请求

class GetDataFromDouBan {
    
    /**
     用来从豆瓣开放平台中获取数据的帮助方法
     
     - parameter dataURL:         请求URL(对应电影，音乐，图书的请求地址)
     - parameter type:            类型分别是subjects，musics，books
     - parameter keyword:         搜索关键字
     - parameter completedHandle: 数据接收到之后的处理函数
     */
    static func getData(dataURL: String, type: String, keyword: String, completedHandle: @escaping (_ data: [NSDictionary]) -> Void) {
        
        //请求数据
        Alamofire.request(dataURL, method: .get, parameters: ["q": keyword, "count": "10"], encoding: URLEncoding.default, headers: nil).responseJSON { response in
            //获取返回的内容
            if let result = response.value as? [String: Any] {
                
                //拿到电影，音乐，图书的信息
                if let data = result[type] as? [NSDictionary] {
                    //回到主线程，执行UI更新等操作
                    OperationQueue.main.addOperation({
                        completedHandle(data)
                    })
                }
            }
        }
        //请求数据
//        Alamofire.request(.GET, dataURL, parameters: ["q": keyword, "count": "10"], encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
//
//            //获取返回的内容
//            if let result = response.result.value {
//
//                //拿到电影，音乐，图书的信息
//                if let data = result[type] as? [NSDictionary] {
//                    //回到主线程，执行UI更新等操作
//                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                        completedHandle(data: data)
//                    })
//                }
//            }
//        }
    }
    
}
