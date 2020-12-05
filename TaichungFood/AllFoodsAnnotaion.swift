//
//  AllFoodsAnnotaion.swift
//  TaichungFood
//
//  Created by 陳暘璿 on 2020/12/4.
//

import MapKit

class AllFoodsAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    /* 取得資訊 **/
    var food: food?
    /* 設定標註標題 **/
    var title: String? {
        food?.name
    }
    /* 設定標註內容 **/
    var subtitle: String? {
        food?.address
    }
    
    init(feature: MKGeoJSONFeature) {
        coordinate = feature.geometry[0].coordinate
        
    }
}
