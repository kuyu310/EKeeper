//
//  EKeeperNetworkManager.swift
//  swift第三方
//  本类提供的都是类方法，不是对象方法，直接引用类进行调用即可
//  李萌  All rights reserved.


import UIKit
import Alamofire
import Foundation
import SwiftyJSON
import ReachabilitySwift

//创建请求类枚举
enum RequestType: Int {
    case requestTypeGet
    case requestTypePost
    case requestTypeDelegate
}



//创建一个闭包
typealias sendVlesClosure = (AnyObject?, NSError?)->Void
typealias uploadClosure = (AnyObject?, NSError?,Int64?,Int64?,Int64?)->Void
class EKeeperNetworkManager: NSObject {
    
    
    //MARK: 网络请求中的GET,Post,DELETE
    class func request(_ type:RequestType ,URLString:String, Parameter:[String:AnyObject], block:@escaping sendVlesClosure) {
        
        switch type {
        case .requestTypeGet:
            Alamofire.request(URLString, method: .get,  parameters: Parameter, encoding: JSONEncoding.default).responseJSON {response in
                block(response.result.value as AnyObject?,nil)
                //把得到的JSON数据转为字典
            }
        case .requestTypePost:
            Alamofire.request(URLString,method: .post, parameters:Parameter).responseJSON {response in
                
                block(nil, response.result.error as NSError?)
                //把得到的JSON数据转为字典
            }
        case .requestTypeDelegate:
            Alamofire.request(URLString, method: .delete,  parameters: Parameter).responseJSON{responde in
                
            }
        }
        
    }
    
    //关于文件上传的方法
    //fileURL实例:let fileURL = NSBundle.mainBundle().URLForResource("Default",withExtension: "png")
    
    //MARK: - 照片上传
    /// - Parameters:
    ///   - urlString: 服务器地址
    ///   - params: ["flag":"","userId":""] - flag,userId 为必传参数
    ///        flag - 666 信息上传多张  －999 服务单上传  －000 头像上传
    ///   - data: image转换成Data
    ///   - name: fileName
    ///   - success:
    ///   - failture:
    
    
    
    class func upLoadImageRequest(urlString : String, params:[String:String], data: [Data], name: [String],success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()){
        
        let headers = ["content-type":"multipart/form-data"]
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                //666多张图片上传
                let flag = params["flag"]
                let userId = params["userId"]
                
                multipartFormData.append((flag?.data(using: String.Encoding.utf8)!)!, withName: "flag")
                multipartFormData.append( (userId?.data(using: String.Encoding.utf8)!)!, withName: "userId")
                
                for i in 0..<data.count {
                    multipartFormData.append(data[i], withName: "appPhoto", fileName: name[i], mimeType: "image/png")
                }
        },
            to: urlString,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let value = response.result.value as? [String: AnyObject]{
                            success(value)
                            let json = JSON(value)
                            //                            PrintLog(json)
                        }
                    }
                case .failure(let encodingError):
                    //                    PrintLog(encodingError)
                    failture(encodingError)
                }
        }
        )
    }
    
    //MARK:    文件上传
    
    class func uploadFile(_ urlString:String,fileURL:URL,block:@escaping uploadClosure) {
        //检测网络是否存在的方法
        
        //        Alamofire.upload(fileURL: fileURL, to: urlString)
        
        Alamofire.upload(fileURL, to: urlString, method: .put)
            .uploadProgress(queue: DispatchQueue.global(qos: .utility)) { Progress in // main queue by default
                
                print("上传进度: \(Progress.fractionCompleted)")
                
            }
            .downloadProgress { progress in // main queue by default
                print("Download Progress: \(progress.fractionCompleted)")
            }
            .responseJSON { response in
                debugPrint(response)
        }
        
    }
}



let reachability = Reachability()!

//MARK: 检测网络状态
extension EKeeperNetworkManager{
    
    
    class func NetworkStatusListener() {
        // 1、设置网络状态消息监听 2、获得网络Reachability对象
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            // 3、开启网络状态消息监听
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    class func closeNetWorkListener(){
        // 关闭网络状态消息监听
        reachability.stopNotifier()
        // 移除网络状态消息通知
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
        
        
    }
    
    // 主动检测网络状态，这个是个通知代理函数，不用去调用，会在收到通知后自动调用
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability // 准备获取网络连接信息
        
        if reachability.isReachable { // 判断网络连接状态
            print("网络连接：可用")
            if reachability.isReachableViaWiFi { // 判断网络连接类型
                print("连接类型：WiFi")
            } else {
                print("连接类型：移动网络")
                // getHostAddrss_GPRS()  // 通过外网获取主机IP地址，并且初始化Socket并建立连接
            }
        } else {
            print("网络连接：不可用")
                }
    }
    
 
}

























