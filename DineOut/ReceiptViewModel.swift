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
    
    func loadData(success: @escaping (Receipt) -> Void) {
        let URL = "https://universal-linking-xiaolong.herokuapp.com/sample.json"
        Alamofire.request(URL).responseObject { (response: DataResponse<Receipt>) in
            
            if let resp = response.result.value {
                success(resp)
            }
        }
    }
    
}
