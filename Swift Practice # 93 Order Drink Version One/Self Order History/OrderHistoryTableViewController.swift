//
//  OrderHistoryTableViewController.swift
//  Swift Practice # 93 Order Drink Version One
//
//  Created by Dogpa's MBAir M1 on 2021/10/13.
//

import UIKit

class OrderHistoryTableViewController: UITableViewController {
    
    //orderListFromOrderingPage為接收第1頁的訂單
    var orderListFromOrderingPage: [AirtableFields]?
    
    //historyOederList為顯示tableView資料使用
    //historyOederList值有改變就更新tableView與存擋
    var historyOederList = [AirtableFields]() {
        didSet {
            tableView.reloadData()
            AirtableFields.saveselfOrder(historyOederList)
        }
    }
    
    //自定義Function addOrderHistoryToThisPage
    //如果接受第一頁的orderListFromOrderingPage不等於0也不等於nil
    //將addOrderHistoryToThisPage加入到historyOederList內後移除addOrderHistoryToThisPage的值
    func addOrderHistoryToThisPage () {
        if orderListFromOrderingPage?.count != 0 , orderListFromOrderingPage != nil {
            historyOederList = historyOederList + orderListFromOrderingPage!
            print("前一頁來的\(orderListFromOrderingPage), 現在這頁\(historyOederList)")
            orderListFromOrderingPage?.removeAll()
            print("最終前一頁來的\(orderListFromOrderingPage), 現在這頁\(historyOederList)")
        }else{
            print("前頁沒點餐")
        }
    }
    
    //自定義loadHistoryOrder讀取檔案
    func loadHistoryOrder () {
        if let loaddate = AirtableFields.LoadselfOrder() {
            historyOederList = loaddate
        }
    }
    
    /*
    override func viewDidLoad() {
    
        super.viewDidLoad()
        print("前一頁來的數量\(orderListFromOrderingPage?.count)")
        addOrderHistoryToThisPage ()
        
    }
     */
    //viewWillAppear內執行上面兩個自定義Function
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addOrderHistoryToThisPage ()
        loadHistoryOrder ()
    }

    // MARK: - Table view data source

    //numberOfSections回傳1
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //row為historyOederList總數
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return historyOederList.count
    }
    
    //顯示內容為historyOederList內每一個資料
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowHistoryTableViewCell", for: indexPath) as! ShowHistoryTableViewCell

        cell.showHistoryLabel.text = "\(historyOederList[indexPath.row].fields.orderTime)\n\(historyOederList[indexPath.row].fields.drinkName) \(historyOederList[indexPath.row].fields.drinkSize)\(historyOederList[indexPath.row].fields.drinkCount) 杯 \(historyOederList[indexPath.row].fields.sugarType)\(historyOederList[indexPath.row].fields.tempType)\n\(historyOederList[indexPath.row].fields.totalPrice)元"
            
        return cell
    }
    
    //刪除測試用基本上歷史訂單不刪除
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        historyOederList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }

}
