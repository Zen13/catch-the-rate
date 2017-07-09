//
//  ManagerData.swift
//  CatchTheRate
//
//  Created by Zen on 09.07.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class ManagerData {
    
    func loadJSON(currency: String) {
        
        //print(currency)
        let realm = try! Realm()
        
        let sourceCurrency = "USD"
        let format = "1"
        let myKey = "3e23650eb8dce40a60ab8ab1c0808b0c"
        let url = "http://apilayer.net/api/live?access_key=" + myKey + "&currencies=\(currency)&source=" + sourceCurrency + "&format=" + format
        
        // получаем данные при помощи API
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                print("JSON: \(json["quotes"][sourceCurrency+currency].stringValue)")
                
                // Создаем строку таблицы с данными
                let onlineCurrency = CatchData()
                onlineCurrency.currencies = currency
                onlineCurrency.sourceCurrency = sourceCurrency
                onlineCurrency.format = format
                onlineCurrency.rezult = json["quotes"][sourceCurrency+currency].stringValue
                
                try! realm.write {
                    // добавляем строку в таблицу с данными
                    realm.add(onlineCurrency)
                    //self.currenciesLabel.text = sourceCurrency + "/" + currencies
                    //self.rezultLabel.text = onlineCurrency.rezult
                }
                
            case .failure(let error):
                print(error)
            }
            
            
        }
    }
    
    
}

