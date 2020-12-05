//
//  Connection.swift
//  TaichungFood
//
//  Created by 陳暘璿 on 2020/12/1.
//

import Foundation
import MapKit
import CoreLocation

class NetworkController {
    
    /* 宣告Array裝foods **/
    var foodsArray = [food]()
    
    /* 串接API資料 **/
    func  fetchLocation() {
        //建立API連線，假如沒有連線成功，則return空的
        guard let locationUrl = URL(string: " https://datacenter.taichung.gov.tw/swagger/OpenData/4d40ce70-21d1-48e7-ba7c-5a9257faf076")
        else { return }
        
        let sessionData = URLSession.shared
        let task = sessionData.dataTask(with: locationUrl) { (data, response, error) in
            //宣告data變數，將參數data(取得的API資料)指派給變數data
            guard let data = data else { return }
            
            //宣告解碼變數，利用MKGeoJSONDecoder() > 要import MapKit
            let decoder = MKGeoJSONDecoder()
            let features = try? decoder.decode(data) as? [MKGeoJSONFeature]
        }
        
    }
}
