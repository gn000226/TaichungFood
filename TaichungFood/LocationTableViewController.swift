//
//  LocationTableViewController.swift
//  TaichungFood
//
//  Created by 陳暘璿 on 2020/12/1.
//

import UIKit

class LocationTableViewController: UITableViewController, UISearchBarDelegate {
    //所有物件Array
    var foods = [food]()
    //裝搜尋的Array
    var searchFoods = [food]()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tableViewVC: UITableView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var headerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "台中名產"
        tableView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 0.7471368044)
        getFoods()
        searchBar.delegate = self
        tableViewVC.delegate = self
        /* 設定header高度 > 避免圖片檔到資料 **/
        self.tableView.tableHeaderView?.frame.size = CGSize(width: self.tableView.bounds.width, height: 256)
    }
    //滑動時隱藏鍵盤
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view?.endEditing(true)
    }
    
    /* 搜尋設定 **/
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchBar.text ?? ""
        if searchText == "" {
            //沒輸入搜尋文字時顯示全部
            searchFoods = foods
        } else {
            //透過輸入的文字搜尋內容(uppercased() > 無論大小寫)
            searchFoods = foods.filter({ (Foods) -> Bool in
                return Foods.name!.uppercased().contains(searchText.uppercased())
            })
        }
        tableViewVC.reloadData()
    }
    
    /* 取得API資料 **/
    func getFoods () {
        if let locationUrl = "https://datacenter.taichung.gov.tw/swagger/OpenData/4d40ce70-21d1-48e7-ba7c-5a9257faf076".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: locationUrl) {
            let sessionData = URLSession.shared
            let task = sessionData.dataTask(with: url) { (data, response, error) in
                let decoder = JSONDecoder()
                //編碼格式
                decoder.dateDecodingStrategy = .iso8601
                //宣告data變數，將參數data(取得的API資料)指派給變數data
                //解碼方法
                if let data = data,
                   let foodResults = try? decoder.decode([food].self, from: data) {
                    self.foods = foodResults
                    self.searchFoods = foodResults
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            task.resume()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /* 有使用searchBar時，記得修改此處的長度設定 **/
        return searchFoods.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as! LocationTableViewCell
        /* 解決重複利用 > 滑動之前都先清空資料 **/
        cell.task?.cancel()
        /* 宣告變數抓取搜尋的資料 **/
        let food: food
        //假如searchBar輸入第一個字開始，就顯示搜尋過的資料，否則(沒輸入字)顯示所有資料
        if self.searchBar.searchTextField.isFirstResponder {
            food = self.searchFoods[indexPath.row]
            cell.lbName.text = food.name
        } else {
            food = self.foods[indexPath.row]
            cell.lbName.text = food.name
        }
        
        return cell
    }
    /* 點擊cell跳轉至下一頁 (present方法) **/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //storyboardID
        if let controller = storyboard?.instantiateViewController(identifier: "FoodDetailViewController") as? FoodDetailViewController {
            controller.foodDetail = searchFoods[indexPath.row]
            navigationController?.show(controller, sender: nil)
//            present(controller, animated: true, completion: nil)
        }
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
