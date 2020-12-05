//
//  FoodDetailViewController.swift
//  TaichungFood
//
//  Created by 陳暘璿 on 2020/12/2.
//

import UIKit

class FoodDetailViewController: UIViewController {
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var lbArea: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var callTelephone: UIButton!
    
    /* 接上頁傳過來的值 **/
    var foodDetail: food!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        self.lbName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.lbPhone.textColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        self.lbArea.textColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        self.lbAddress.textColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        self.title = foodDetail.name
        setBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lbName.text = foodDetail.name
        lbPhone.text = foodDetail.number
        lbArea.text = foodDetail.area
        lbAddress.text = foodDetail.address
    }
    /* 跳轉至Map **/
    @IBAction func toMapView(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(identifier: "MapViewController") as! MapViewController
        controller.food = foodDetail
        show(controller, sender: nil)
    }
    /* 撥打電話 **/
        @IBAction func callTel(_ sender: UIButton) {
            /* 宣告alertController **/
            let controller = UIAlertController(title: foodDetail.name, message: nil, preferredStyle: .actionSheet)
            let phoneNumber = "\(foodDetail.number ?? "")"
            let first = Int(phoneNumber.prefix(1))  /* 取得字串第一個字元 **/
            let phoneAction = UIAlertAction(title: "通話 \(phoneNumber)", style: .default) { (_) in
                /* 播打電話功能 **/
                if var url = URL(string: "tel://\(phoneNumber)") {
                    if UIApplication.shared.canOpenURL(url) {
                        if first == 0 {     //判斷第一個字元是否為0 > 手機號碼或不是手機號碼
                            url = URL(string: "tel://\(phoneNumber)")!    //是手機就直接撥打
                        } else {
                            let phoneNumber04 = "04\(self.foodDetail.number ?? "")" //不是手機就加04在撥打
                            url = URL(string: "tel://\(phoneNumber04)")!
                            print("判斷是否有跑進這行 : \(url)")
                        }
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        print("無法撥打電話")
                    }
                } else {
                    print("不明的錯誤")
                }
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            controller.addAction(phoneAction)
            controller.addAction(cancelAction)
            present(controller, animated: true, completion: nil)
        }
    
//    @IBAction @objc func callTelephone(_ sender: Any) {
//        let first = Int(foodDetail.number!.prefix(1))  /* 取得字串第一個字元 **/
//        let urlStr: String
//        if first == 0 {     //判斷第一個字元是否為0 > 手機號碼或市話
//            urlStr = "tel://"+"\(foodDetail.number ?? "")"
//            print("判斷是否有跑進這行 : \(urlStr)")
//        } else {
//            urlStr = "tel://"+"04\(foodDetail.number ?? "")" //不是手機就將phoneNumberStr加04
//            print("判斷是否有跑進這行 : \(urlStr)")
//        }
//        if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                print("判斷是否有跑進這行open : \(url)")
//            } else {
//                UIApplication.shared.openURL(url)
//                print("判斷是否有跑進這行openURL : \(url)")
//            }
//        }
//    }
    
    /* 設定背景顏色 **/
    func setBackground() {
        let color7 = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 0.75).cgColor
        let color8 = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1).cgColor
        let color9 = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.colors = [color9, color8, color8, color8, color8, color7]
        view.layer.insertSublayer(gradient, at: 0)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
