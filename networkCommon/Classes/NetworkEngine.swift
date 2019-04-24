//
//  NetwokEngine.swift
//  ProjectDemo
//
//  Created by retygu on 15/11/27.
//  Copyright © 2015年 retygu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MobileCoreServices

//MARK: 数据本地化
/************** UserDefaults **************/
let documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
//用户相关
let BIMToken = "bim_token"                                //登录返回拼接的token

typealias requestSuccessClosureToOC = (_ obj:Any)->Void
typealias requestSuccessClosure = (_ obj:JSON)->Void
typealias requestFailedClosure = (_ errorString:String)->Void
typealias requestProgress = (_ progress:Float)->Void

class NetwokEngine: NSObject {
    // 单例创建
    fileprivate static let netwokEngine: NetwokEngine = NetwokEngine()
    
    class func getInstance() -> NetwokEngine {
        return netwokEngine
    }
    // 重写init让其成为私有的，防止其他对象使用这个类的默认的‘()‘初始化方法来创建对象
    // 确保NetwokEngine()编译不通过
    fileprivate override init() {}
    
    var timer: Timer? // 显示文件下载进度定时器
    var statusLabelString = "" // 下载进度
    var downloadRequest: DownloadRequest?
    
    /**
     异步请求 get  无参数
     */
    func asynchronousGetRequestWithUrl(_ url: String, withSuccess successClosure: @escaping requestSuccessClosure, failed failedClosure: @escaping requestFailedClosure) {
        let urlEncoding = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let token:String = UserDefaults.standard.string(forKey: BIMToken)!
        
        let headers: HTTPHeaders = [
            "authorization": token,
            "Accept": "application/json"
        ]
        
        Alamofire.request(urlEncoding!, method: .get, headers: headers).responseJSON { response in
            if response.result.isSuccess {
                // 成功回调closure
                print(JSON(response.result.value!))
                let json = JSON(response.result.value!)
                successClosure(json)
            } else {
                // 失败回调closure
                failedClosure("数据请求出错，请稍后重试")
            }
        }
        
    }
    
    
    /**
     异步请求 get 带参数 没有token
     */
    func asynchronousGetRequestWithUrlAndParamsNoToken(_ url: String,withDataDic dataDic: NSDictionary, withSuccess successClosure: @escaping requestSuccessClosure, failed failedClosure: @escaping requestFailedClosure) {
        
        let urlEncoding = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        
        
        Alamofire.request(urlEncoding!, method: HTTPMethod.get, parameters: dataDic as? Parameters).responseJSON { response in
            if response.result.isSuccess {
                // 成功回调closure
                print(JSON(response.result.value!))
                successClosure(JSON(response.result.value!))
            } else {
                // 失败回调closure
                failedClosure("数据请求出错，请稍后重试")
            }
        }
    }
    
    /**
     异步请求 get 带参数 有token
     */
    func asynchronousGetRequestWithUrlAndParams(_ url: String,withDataDic dataDic: NSDictionary, withSuccess successClosure: @escaping requestSuccessClosure, failed failedClosure: @escaping requestFailedClosure) {
        
        let urlEncoding = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let token:String = UserDefaults.standard.string(forKey: BIMToken)!
        
        let headers: HTTPHeaders = [
            "authorization": token,
            "Accept": "application/json"
        ]
        
        Alamofire.request(urlEncoding!, method: HTTPMethod.get, parameters: dataDic as? Parameters, headers: headers).responseJSON { response in
            if response.result.isSuccess {
                // 成功回调closure
                let json = JSON(response.result.value!)
                print(json)
                if json["code"].stringValue == "402" || json["code"].stringValue == "401" || json["code"].stringValue == "403"    //accessToken过期跳回登录
                {
                    //退出登录
//                    CommonMethod.logOutApp()
                }
                else
                {
                    successClosure(json)
                }
            }
            else
            {
                // 失败回调closure
                failedClosure("数据请求出错，请稍后重试")
            }
        }
    }
    
    
    /**
     异步请求数据post 有token
     Accept": "application/json
     */
    func asynchronousPostRequestWithUrl(_ url: String, withDataDic dataDic: NSDictionary, withSuccess successClosure: @escaping requestSuccessClosure, failed failedClosure: @escaping requestFailedClosure) {
        let urlEncoding = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let token:String = UserDefaults.standard.string(forKey: BIMToken)!
        
        let headers: HTTPHeaders = [
            "authorization": token,
            "Accept": "application/json"
        ]
        
        Alamofire.request(urlEncoding!, method: .post, parameters: dataDic as? Parameters, headers: headers).responseJSON { response in
            if response.result.isSuccess {
                // 成功回调closure
                let json = JSON(response.result.value!)
                print(json)
                if json["code"].stringValue == "402" || json["code"].stringValue == "401" || json["code"].stringValue == "403"    //accessToken过期跳回登录
                {
                    //退出登录
//                    CommonMethod.logOutApp()
                }
                else
                {
                    successClosure(json)
                }
            } else {
                // 失败回调closure
                failedClosure("数据请求出错，请稍后重试")
            }
        }
    }
    
    
    /**
     异步请求数据post 带token
     Content-Type":"application/json
     */
    func asynchronousPostRequestWithUrlWithToken(_ url: String, withDataDic dataDic: NSDictionary, withSuccess successClosure: @escaping requestSuccessClosure, failed failedClosure: @escaping requestFailedClosure) {
        let urlEncoding = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let token:String = UserDefaults.standard.string(forKey: BIMToken)!
        
        Alamofire.request(urlEncoding!, method: HTTPMethod.post, parameters: dataDic as? Parameters, headers: ["Content-Type":"application/json", "authorization": token]).responseJSON { response in
            if response.result.isSuccess {
                // 成功回调closure
                print(JSON(response.result.value!))
                successClosure(JSON(response.result.value!))
            } else {
                // 失败回调closure
                failedClosure("数据请求出错，请稍后重试")
            }
        }
        
    }
    
    
    /**
     异步请求数据post 无token
     */
    func asynchronousPostRequestWithUrlNoToken(_ url: String, withDataDic dataDic: NSDictionary, withSuccess successClosure: @escaping requestSuccessClosure, failed failedClosure: @escaping requestFailedClosure) {
        
        let urlEncoding = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let authorization = "Basic YXBwOmFwcA=="
        
        let headers: HTTPHeaders = [
            "Authorization": authorization,
//            "Accept": "application/json"
        ]
        
        Alamofire.request(urlEncoding!, method: HTTPMethod.post, parameters: dataDic as? Parameters, headers: headers).responseJSON { response in
            if response.result.isSuccess {
                // 成功回调closure
                print(JSON(response.result.value!))
                successClosure(JSON(response.result.value!))
            } else {
                // 失败回调closure
                failedClosure("数据请求出错，请稍后重试")
            }
        }
    }
    
    /**
     parameter ： Json类型
     异步请求数据post
     encoding: JSONEncoding.default
     */
    func asynchronousPostRequestWithUrlJson(_ url: String, withDataDic dataDic: NSDictionary, withSuccess successClosure: @escaping requestSuccessClosure, failed failedClosure: @escaping requestFailedClosure) {
        let urlEncoding = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        
        let token = UserDefaults.standard.string(forKey: BIMToken)!
        
        Alamofire.request(urlEncoding!, method: .post, parameters: dataDic as? Parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "authorization": token]).responseJSON { response in
            if response.result.isSuccess {
                // 成功回调closure
                print(JSON(response.result.value!))
                successClosure(JSON(response.result.value!))
            } else {
                // 失败回调closure
                failedClosure("数据请求出错，请稍后重试")
            }
        }
    }
    
    /**
     parameter ： Json类型
     异步请求数据put
     encoding: JSONEncoding.default
     */
    func asynchronousPutRequestWithUrlJson(_ url: String, withDataDic dataDic: NSDictionary, withSuccess successClosure: @escaping requestSuccessClosure, failed failedClosure: @escaping requestFailedClosure) {
        let urlEncoding = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        
        let token = UserDefaults.standard.string(forKey: BIMToken)!
        
        Alamofire.request(urlEncoding!, method: .put, parameters: dataDic as? Parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "authorization": token]).responseJSON { response in
            if response.result.isSuccess {
                // 成功回调closure
                print(JSON(response.result.value!))
                successClosure(JSON(response.result.value!))
            } else {
                // 失败回调closure
                failedClosure("数据请求出错，请稍后重试")
            }
        }
    }
    
    /**
     系统方法网络请求传入数组
     parameter ： Json类型
     异步请求数据post
     */
    func asynchronousPostRequestArrWithUrlJson(_ url: String, withDataArr dataArr: Array<Any>, withSuccess successClosure: @escaping requestSuccessClosure, failed failedClosure: @escaping requestFailedClosure) {
        let urlEncoding = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let token = UserDefaults.standard.string(forKey: BIMToken)!
        
        // 2. 请求(可以改的请求)
        let request:NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: urlEncoding!)! as URL)
        // ? POST
        // 默认就是GET请求
        request.httpMethod = "POST"
        
        // ? 数据体
        var jsonData:NSData? = nil
        do {
            jsonData  = try JSONSerialization.data(withJSONObject: dataArr, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
        } catch {
            
        }
        // 将字符串转换成数据
        request.httpBody = (jsonData! as Data)
        
        request.allHTTPHeaderFields = ["Content-Type":"application/json", "authorization": token]
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            DispatchQueue.main.async(execute: {
                if error != nil
                {
                    // 失败回调closure
                    failedClosure("数据请求出错，请稍后重试")
                }
                else
                {
                    // 成功回调closure
                    print(JSON(data as Any))
                    successClosure(JSON(data as Any))
                }
            })
        }
        task.resume()
    }
    
    /**
     *上传音频
     */
    func asynchronousPostAudioUploadRequestWithUrl(_ url: String,withFile filePath:String ,withSuccess successClosure: @escaping requestSuccessClosure, failed failedClosure: @escaping requestFailedClosure) {
        
        
        let urlEncoding = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            let date = NSDate()
            let timeInterval = date.timeIntervalSince1970 * 1000
            
            multipartFormData.append(NSURL.fileURL(withPath: filePath), withName: "file", fileName: "\(timeInterval).wav", mimeType: "audio/x-wav")
            
        }, to: "\(urlEncoding!)") { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                    print(response.result.value!)
                    successClosure(JSON(response.result.value!))
                }
                
            case .failure(let encodingError):
                print(encodingError)
                // 失败回调closure
                failedClosure("数据请求出错，请稍后重试")
            }
        }
        
    }
    
    /**
     *上传PDF
     */
    func asynchronousPostPDFFileUploadRequestWithUrl(_ url: String,withFile filePath:String ,withSuccess successClosure: @escaping requestSuccessClosure, failed failedClosure: @escaping requestFailedClosure) {
        
        
        let urlEncoding = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            let date = NSDate()
            let timeInterval = date.timeIntervalSince1970 * 1000
            
            let mimeType1 = self.mimeType(pathExtension: "pdf")
            multipartFormData.append(NSURL.fileURL(withPath: filePath), withName: "file", fileName: "\(timeInterval).pdf", mimeType: mimeType1)
            
        }, to: "\(urlEncoding!)") { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                    print(response.result.value!)
                    successClosure(JSON(response.result.value!))
                }
                
            case .failure(let encodingError):
                print(encodingError)
                // 失败回调closure
                failedClosure("数据请求出错，请稍后重试")
            }
        }
        
    }
    
    
    /**
     *上传图片
     */
    func asynchronousPostUploadRequestWithUrl(_ url: String, withImages imageArr: NSArray, withSuccess successClosure: @escaping requestSuccessClosure, failed failedClosure: @escaping requestFailedClosure) {
        let urlEncoding = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                // 将本地的文件上传至服务器
                for i in 0..<imageArr.count {
                    
                    let dddd = imageArr[i] as! UIImage
                    
//                    let imageData = CommonLogic.image(with: dddd)
                    
                    let imageData = UIImageJPEGRepresentation(dddd, 1.0)
                    
                    let date = NSDate()
                    let timeInterval = date.timeIntervalSince1970 * 1000
                    
                    multipartFormData.append(imageData!, withName: "file", fileName: "\(timeInterval).jpg", mimeType: "image/jpg")
                }
        },
            //to: "\(urlEncoding!)/post",
            to: "\(urlEncoding!)",
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        print(response.result.value!)
                        successClosure(JSON(response.result.value!))
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                    // 失败回调closure
                    failedClosure("数据请求出错，请稍后重试")
                }
        }
        )
    }
    
    /*
     //根据后缀获取对应的Mime-Type
     1.固定获取mimeType
     let mimeType1 = mimeType(pathExtension: "pdf")
     
     2.动态获取mimeType
     let url = URL(fileURLWithPath: path)
     let mimeType2 = mimeType(pathExtension: url.pathExtension)
     */
    func mimeType(pathExtension: String) -> String {
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                           pathExtension as NSString,
                                                           nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?
                .takeRetainedValue() {
                return mimetype as String
            }
        }
        //文件资源类型如果不知道，传万能类型application/octet-stream，服务器会自动解析文件类
        return "application/octet-stream"
    }
    
    //文件下载,带进度条
    func downloadFileWithProgress(url: String, filePath:String , withProgress requestProgress: @escaping requestProgress,withSuccess successClosure: @escaping requestSuccessClosure, failed failedClosure: @escaping requestFailedClosure) -> DownloadRequest
    {
        let urlEncoding = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

        //指定下载路径和保存文件名
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in

            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (URL(fileURLWithPath: filePath), [.removePreviousFile, .createIntermediateDirectories])
        }

        downloadRequest = Alamofire.download(urlEncoding!, to: destination)
            .downloadProgress(closure: { (progress) in
                requestProgress(Float(progress.completedUnitCount) / Float(progress.totalUnitCount))
            })
            .responseData { response in

                if response.result.isSuccess
                {
//                    successClosure(JSON(response.result.value!))
                    successClosure(JSON(response))
                }
                else
                {
                    failedClosure("下载失败，请稍后再试")

                    let fileU = URL(fileURLWithPath: filePath)
                    do {
                        try FileManager.default.removeItem(at: fileU)
                    }
                    catch {}
                }
        }
        return downloadRequest!
    }
    
    /**
     下载附件,不带进度条
     */
    func asynchronousDownloadNoProgressRequestWithUrl(_ url: String, withPathName pathName: String, withViewController controller:UIViewController, withSuccess successClosure: @escaping requestSuccessClosure, failed failedClosure: @escaping requestFailedClosure) {
        let urlEncoding = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        
        //指定下载路径和保存文件名
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            
            let fileURL = documentsURL.appendingPathComponent(pathName)
            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            print(fileURL)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        downloadRequest = Alamofire.download(urlEncoding!, to: destination)
            .responseData { response in
                
                if response.result.isSuccess {
                    if let path = response.destinationURL?.path {
                        print("=======")
                        print(path)
                    }
//                    successClosure(JSON(response.result.value!))
                    successClosure(JSON(response))
                    
                } else {
                    failedClosure("下载失败，请稍后再试")
                    
                    let documentsU = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let fileU = documentsU.appendingPathComponent("/" + pathName)
                    do {
                        try FileManager.default.removeItem(at: fileU)
                    } catch {
                        
                    }
                }
        }
    }
}
