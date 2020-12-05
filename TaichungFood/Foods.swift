//
//  Foods.swift
//  TaichungFood
//
//  Created by 陳暘璿 on 2020/12/1.
//

import Foundation

struct food: Codable {
    let id : String?
    let name: String?
    let area: String?
    let number: String?
    let address: String?
    
    /* 利用enum將API屬性名稱轉為自定義的變數 **/
    enum CodingKeys: String, CodingKey {
        case id = "編號"
        case name = "攤名"
        case area = "區域"
        case number = "電話"
        case address = "地址"
    }
    
    struct fodResult: Decodable   {
        let foods: [food]
    }
    
    
}
