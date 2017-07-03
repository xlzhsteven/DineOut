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

class ItemFriendBindingViewModel: NSObject {
        
    override init() {
        super.init()
        loadData()
    }
    
    func loadData() {
        let URL = "https://universal-linking-xiaolong.herokuapp.com/sample.json"
        Alamofire.request(URL).responseObject { (response: DataResponse<Receipt>) in
            
            let resp = response.result.value
            print(resp?.total)
            
            if let items = resp?.items {
                for item in items {
                    print(item.itemName)
                    print(item.itemPrice)
                }
            }
        }
    }
    
    // MARK: helper method
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
    
}
