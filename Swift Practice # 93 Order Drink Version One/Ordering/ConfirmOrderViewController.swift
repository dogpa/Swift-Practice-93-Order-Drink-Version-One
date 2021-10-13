//
//  ConfirmOrderViewController.swift
//  Swift Practice # 93 Order Drink Version One
//
//  Created by Dogpa's MBAir M1 on 2021/10/12.
//

import UIKit

class ConfirmOrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var confrinOrderTableView: UITableView!      //顯示第2頁傳來的使用者訂單內容
    
    @IBOutlet weak var showOrderItemLabel: UILabel!             //顯示每筆訂單內容與金額
    
    @IBOutlet weak var sentOrderButton: UIButton!               //送出訂單的button用來設定layout.cornerRadius
    
    //自定義變數readyToSendMenuToBackEndArrary為型別[AirtableFields]Array的空字串
    //並用didSet偵測改變的值去做判斷執行不同的事
    var readyToSendMenuToBackEndArrary = [AirtableFields]() {
        didSet {
            //如果readyToSendMenuToBackEndArrary為nil顯示訂單的label字為"歡迎點餐"
            if readyToSendMenuToBackEndArrary == nil {
                showOrderItemLabel.text = "歡迎點餐"
                
            //如果不為nil判斷數量如果為0一樣顯示"歡迎點餐"
            //如果不為0則將readyToSendMenuToBackEndArrary內的每一個Array內的值變成字串加入到自定義showOrderStringArray
            //接著showOrderStringArray的值顯示在Label(透過For迴圈來完成。
            }else{
                
                print(readyToSendMenuToBackEndArrary.count)
                
                if readyToSendMenuToBackEndArrary.count != 0 {
                    var showOrderStringArray:[String] = []
                    for i in 0...readyToSendMenuToBackEndArrary.count - 1 {
                        let stringSavingIntoshowOrderString = "\(i+1). \(readyToSendMenuToBackEndArrary[i].fields.drinkName) \(readyToSendMenuToBackEndArrary[i].fields.drinkCount)杯 \(readyToSendMenuToBackEndArrary[i].fields.totalPrice) 元"
                        showOrderStringArray.append(stringSavingIntoshowOrderString)
                    }
                    showOrderItemLabel.text = ""
                    for x in 0...showOrderStringArray.count - 1{
                        showOrderItemLabel.text = "\((showOrderItemLabel.text ?? "")+showOrderStringArray[x])\n"
                    }
                }else{
                    showOrderItemLabel.text = "歡迎點餐"
                }

            }
        }
    }
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(readyToSendMenuToBackEndArrary.count)  //測試列印
        
        //透過view的1/10的值來作為sentOrderButton的cornerRadius的值
        let buttonCornerRadius = view.frame.maxY - view.frame.minY
        sentOrderButton.layer.cornerRadius = buttonCornerRadius * 0.1/2
        
    }

    
    //TableView相關
    //回傳一個numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //numberOfRowsInSection數量回傳readyToSendMenuToBackEndArrary總數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readyToSendMenuToBackEndArrary.count
    }
    
    //ShowOrderToConfirmTableViewCell內的showOrderDetailsLabel
    //顯示readyToSendMenuToBackEndArrary的每一個的訂單資料
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowOrderToConfirmTableViewCell", for: indexPath) as! ShowOrderToConfirmTableViewCell
        cell.showOrderDetailsLabel.text = "\(readyToSendMenuToBackEndArrary[indexPath.row].fields.drinkName) \(readyToSendMenuToBackEndArrary[indexPath.row].fields.drinkSize) \(readyToSendMenuToBackEndArrary[indexPath.row].fields.drinkCount) 杯 \(readyToSendMenuToBackEndArrary[indexPath.row].fields.sugarType) \(readyToSendMenuToBackEndArrary[indexPath.row].fields.tempType)"
        return cell
    }
    
    //刪除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        readyToSendMenuToBackEndArrary.remove(at: indexPath.row)
        confrinOrderTableView.deleteRows(at: [indexPath], with: .automatic)
        confrinOrderTableView.reloadData()
    }
    
    
    
    //透過unwindSegue傳第2頁的資料過來後
    //新增到readyToSendMenuToBackEndArrary的第１個接著confrinOrderTableView更新頁面
    @IBAction func unwindToOrderingPageViewController(_ unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? OrderDrinkPageViewController {
            let readyInsertOrderInfo = sourceViewController.orderPageInfoReayToPass
            readyToSendMenuToBackEndArrary.append(readyInsertOrderInfo!)
            confrinOrderTableView.reloadData()
            
            
        }
        
    }
    
    
    //送出訂單的IBAction
    @IBAction func orderSnetTOBackEnd(_ sender: UIButton) {
        //若是readyToSendMenuToBackEndArrary為0表示購物車沒東西
        //顯示警告
        if  readyToSendMenuToBackEndArrary.count == 0 {
           
            let alertCOntroller = UIAlertController(title: "尚未點餐喔", message: "先點餐吧", preferredStyle: .alert)
            alertCOntroller.addAction(UIAlertAction(title: "了解", style: .default, handler: nil))
            present(alertCOntroller, animated: true, completion: nil)
        
            
        //若是購物車有資料表示有訂單要送出
        }else{
            
            //透過For迴圈將購物車的每一筆資料逐一上傳到Airtable後台
            //透過URLRequest並設定setValue指定ApiKey與內容(Authorization授權)
            //並設定httpMethod為上傳的"POST"
            //並設定上傳為"application/json"的"Content-Type"
            //再透過httpBody來將指定好的內容(sentAllOrderToBackEnd)送出
            //透過URLSession.shared.dataTask(with: request)的方式上傳
            for orderCount in 0...readyToSendMenuToBackEndArrary.count - 1 {
                let sentAllOrderToBackEnd = AirtableDrink(records: [.init(fields: .init(orderTime: readyToSendMenuToBackEndArrary[orderCount].fields.orderTime, drinkName: readyToSendMenuToBackEndArrary[orderCount].fields.drinkName, drinkSize: readyToSendMenuToBackEndArrary[orderCount].fields.drinkSize, drinkCount: readyToSendMenuToBackEndArrary[orderCount].fields.drinkCount, tempType: readyToSendMenuToBackEndArrary[orderCount].fields.tempType, sugarType: readyToSendMenuToBackEndArrary[orderCount].fields.sugarType, totalPrice: readyToSendMenuToBackEndArrary[orderCount].fields.totalPrice))])
                if let backEndUrl = "https://api.airtable.com/v0/app8mwjZQZBSaI2DN/SwiftPractice93".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
                    if let url = URL(string: backEndUrl) {
                        var request = URLRequest(url: url)
                        request.setValue("Bearer ", forHTTPHeaderField: "Authorization")
                        request.httpMethod = "POST"
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        let JEncoder = JSONEncoder()
                        JEncoder.dateEncodingStrategy = .iso8601
                        request.httpBody = try? JEncoder.encode(sentAllOrderToBackEnd)
                        URLSession.shared.dataTask(with: request) { (data, response, error) in
                                if let data = data , let content = String(data: data, encoding: .utf8) {
                                    do {
                                        print("成功\(content)")
                                    }catch{
                                        print(error)
                                    }
                                }
                        }.resume()
                    }
                }

            }
            
            //上傳後將購物車資料傳給第3頁
            //因為是Tab Bar的方式透過找self.tabBarController?.viewControllers?的位置來指定資料
            //第3頁的orderListFromOrderingPage就是這頁的購物車資料 (傳過去)
            if let thePageToSeeOrderHistory = self.tabBarController?.viewControllers?[1] as? OrderHistoryTableViewController {
                thePageToSeeOrderHistory.orderListFromOrderingPage = readyToSendMenuToBackEndArrary
            }
            
            //傳過去後清空購物車，也就是移除readyToSendMenuToBackEndArrary內所有的值
            //並重新更新confrinOrderTableView
            readyToSendMenuToBackEndArrary.removeAll()
            confrinOrderTableView.reloadData()
            
        }
    
    
    }
}

/*
 
 let notification = Notification.Name("sentOrderToSelfHistory")
 NotificationCenter.default.post(name: notification, object: nil, userInfo: ["sentOder":readyToSendMenuToBackEndArrary])
 print(readyToSendMenuToBackEndArrary)
 readyToSendMenuToBackEndArrary.removeAll()
 confrinOrderTableView.reloadData()
 */
