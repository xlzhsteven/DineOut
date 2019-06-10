//
//  ItemFriendBindingViewModel.swift
//  DineOut
//
//  Created by Xiaolong Zhang on 7/2/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire

class ReceiptViewModel: NSObject {
    
//    var receipt: Receipt?
    
    override init() {
        super.init()
    }
    
//  func loadData(_ base64ImageString: String, success: @escaping (Receipt) -> Void) {
     func loadData(_ base64ImageString: String, success: @escaping (Receipt) -> Void) {
//    let URL = "https://universal-linking-xiaolong.herokuapp.com/sample.json"
//    Alamofire.request(URL).responseObject { (response: DataResponse<Receipt>) in
//      if let resp = response.result.value {
//        success(resp)
//      }
//    }
    let URL = "http://10.225.86.122:5000/test"
    let parameters = ["data": base64ImageString]
    Alamofire.request(URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseObject { (response: DataResponse<Receipt>) in
      if let resp = response.result.value {
        success(resp)
      }
    }
  }
  
}
