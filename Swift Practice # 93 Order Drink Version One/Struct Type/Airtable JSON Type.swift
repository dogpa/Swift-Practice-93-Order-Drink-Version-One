//
//  Airtable JSON Type.swift
//  Swift Practice # 93 Order Drink Version One
//
//  Created by Dogpa's MBAir M1 on 2021/10/12.
//


import Foundation

struct AirtableDrink: Codable {     //Airtable第一層
    var records : [AirtableFields]
}

struct AirtableFields: Codable {    //Airtable第二層，另外寫入可執行讀取及存擋的Function
    var fields: DrinkDetails
    
    static func saveselfOrder (_ orderInfo:[AirtableFields]) {
        let encoder = JSONEncoder()
        guard let date = try? encoder.encode(orderInfo) else { return }
        UserDefaults.standard.set(date, forKey: "OrderDate")
    }
    
    static func LoadselfOrder() ->[AirtableFields]? {
        let userDeFult = UserDefaults.standard
        guard let data = userDeFult.data(forKey: "OrderDate") else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode([AirtableFields].self, from: data)
    }
}

struct DrinkDetails: Codable {      //Airtable第三層
    var orderTime: String
    let drinkName: String
    let drinkSize: String
    let drinkCount: Int
    let tempType: String
    let sugarType: String
    let totalPrice: Int
}
