//
//  MapViewController.swift
//  TaichungFood
//
//  Created by 陳暘璿 on 2020/12/2.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var foodMapView: MKMapView!
    var foods: [food]?
    var food: food?
    /* 建立CLLocationManager實體 > 定位 > 取得自己的位置 **/
    let locationManager = CLLocationManager()
    /* 是否取得現在位置 **/
    var getLocation = true
    /* 設定點擊大頭的註解標註Annotation > 裝註解的變數 **/
    var annotation: MKAnnotation!
    /* 經緯度，導航用 **/
    var latitude = 0.0
    var longtitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        foodMapView.delegate = self
        addressToGeo()
        /* 呼叫顯示範圍 **/
        setMapRegion()
        /* 啟用授權requestWhenInUseAuthorization() > 取得自己的位置 **/
        locationManager.requestWhenInUseAuthorization()
        /* 顯示使用者位置 **/
        foodMapView.showsUserLocation = true
    }
    /* 地址轉為經緯度 **/
    func addressToGeo() {
        let geoCoder = CLGeocoder()
        let foodMark = "台中市\(food?.area ?? "")\(food?.address ?? "")"
        print("顯示地址：\(foodMark)")
        geoCoder.geocodeAddressString(foodMark) { (placemarks, error) in
            if placemarks != nil && placemarks!.count > 0 {
                if let placemark = placemarks!.first {
                    let location = placemark.location!
                    /* 點擊mark 將畫面移到正中 **/
                    self.setMapCenter(center: location.coordinate)
                    /*  **/
                    self.setMapAnnotation(location)
                }
            }
        }
    }
    /* 設定選取的位置到mapView正中央 **/
    func setMapCenter(center: CLLocationCoordinate2D) {
        foodMapView.setCenter(center, animated: false)
    }
    
    /* Mark圖釘字樣顯示設定 **/
    func setMapAnnotation(_ location: CLLocation) {
        let coordinate = location.coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = (food?.name)!
        annotation.subtitle = (food?.address)!
        foodMapView.addAnnotation(annotation)
    }
    
    /* 設定顯示地圖範圍 **/
    func setMapRegion() {
        /* 設定顯示範圍跨的經緯度半徑為0.003 **/
        let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)

        //將設定的範圍給MKCoordinateRegion() > 顯示在畫面上
        var region = MKCoordinateRegion()
        region.span = span
        foodMapView.setRegion(region, animated: true)
        foodMapView.regionThatFits(region)
    }
    
    /* didSelect > 撰寫mapView **/
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        <#code#>
//    }
    
    /* 顯示圖釘對話欄設定 **/
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        /* user location已經有預設圖示無需給予新的圖示 */
        if annotation is MKUserLocation {
            return nil
        }
        let identifier = "annotation"
        //轉為MKPinAnnotationView
        var annotationView = foodMapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            /* 沒設定圖釘樣式就使用預設的樣式 > 要使用MKPinAnnotationView才能設定點擊事件 */
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        /* 打開點擊對話欄 **/
        annotationView?.canShowCallout = true
        /* 自訂圖釘樣式 **/
        annotationView?.image = UIImage(named: "pin")
        let detailButton = UIButton(type: .detailDisclosure)
        /* 設定點擊button **/
        annotationView?.rightCalloutAccessoryView = detailButton
        return annotationView
    }
    /* 點擊對話資訊欄的button觸發事件設定 > 設定為導航 **/
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //設定開始點為 > 使用者位置
        let start = mapView.userLocation.coordinate
        //設定結束點為 > 點擊圖釘當下的位置
        let end = view.annotation!.coordinate
        setDirect(start: start, end: end)
    }
    /* 導航功能設定 **/
    @objc func setDirect(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) {
        //取得開始與結束的位置
        let placemarkStart = MKPlacemark(coordinate: start, addressDictionary: nil)
        let placemarkEnd = MKPlacemark(coordinate: end, addressDictionary: nil)
        
        //設定地圖標註註解
        let mapItemStart = MKMapItem(placemark: placemarkStart)
        let mapItemEnd = MKMapItem(placemark: placemarkEnd)
        
        mapItemStart.name = "我的位置"
        mapItemEnd.name = food?.name
        /* 宣告array > 裝初始位置及結束位置以及Item > 帶到內建導航 **/
        let mapItem = [mapItemStart, mapItemEnd ]
        /* 設定導航模式：開車、走路、搭車 > 帶到內建導航  **/
        let action = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        MKMapItem.openMaps(with: mapItem, launchOptions: action)
    }
}

/* 擴展類別 **/
extension MapViewController {
    /* 取得自己的位置 **/
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !foodMapView.isUserLocationVisible {
            foodMapView.setCenter(userLocation.coordinate, animated: true)
        }
        if getLocation == false {
            getLocation = true
                //center > 中心點座標，latitudinalMeters, longitudinalMeters > region 顯示範圍
                let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                //設定顯示至mapView上面
                mapView.setRegion(region, animated: true)
        }
    }
    
    func addMaker() {
        
    }
}

