//
//  BackEndTableViewController.swift
//  Swift Practice # 93 Order Drink Version One
//
//  Created by Dogpa's MBAir M1 on 2021/10/12.
//

import UIKit

class BackEndTableViewController: UITableViewController {

    //backEndDetailsArray為AirtableFields的空Array
    var backEndDetailsArray = [AirtableFields]()
    
    //viewDidLoad執行抓Airtable後台資料的Function
    override func viewDidLoad() {
        super.viewDidLoad()
        getAirtableDrinkBackEndInfo ()
    }
    
    //viewWillAppear執行抓Airtable後台資料的Function
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAirtableDrinkBackEndInfo ()
    }


    //自定義Function更改JSON的時間格式字串內容
    func changeDateType () {
        
        //透過迴圈將backEndDetailsArray的orderTime存入timeString
        //透過字串過濾只抓到timeString的秒數時間後存入到changeString
        //接著將backEndDetailsArray的orderTime變成新的changeString
        for i in 0...backEndDetailsArray.count - 1 {
            let timeString = backEndDetailsArray[i].fields.orderTime
            let timeIndex = timeString.index(timeString.startIndex, offsetBy: 19)
            let changeString = String(timeString.prefix(upTo: timeIndex))
            backEndDetailsArray[i].fields.orderTime = changeString
        }
    }
    
    //自定義Function抓Airtable的後台JSON
    func getAirtableDrinkBackEndInfo () {
        if let airtableJSONAPI = "https://api.airtable.com/v0/app8mwjZQZBSaI2DN/SwiftPractice93?api_key=".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let getBackEndUrl = URL(string: airtableJSONAPI) {
                URLSession.shared.dataTask(with: getBackEndUrl) {
                    data, response, error in
                    if let data = data {
                        let JSONDecoder = JSONDecoder()
                        JSONDecoder.dateDecodingStrategy = .iso8601
                        
                        do {
                            let getData = try JSONDecoder.decode(AirtableDrink.self, from: data)
                            self.backEndDetailsArray = getData.records
                            self.changeDateType ()
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }catch{
                            print(error)
                        }
                    }
                }.resume()
            }
        }
    }
    
    
    
    
    
    
    // MARK: - Table view data source

    
    //tableView相關
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return backEndDetailsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderInfoTableViewCell", for: indexPath) as! OrderInfoTableViewCell

        cell.priceLabel.text = "\(String(backEndDetailsArray[indexPath.row].fields.totalPrice)) 元"
        cell.sugarLabel.text = backEndDetailsArray[indexPath.row].fields.sugarType
        cell.tempLabel.text = backEndDetailsArray[indexPath.row].fields.tempType
        cell.sizeLabel.text = backEndDetailsArray[indexPath.row].fields.drinkSize
        cell.drinkCountLabel.text = "\(String(backEndDetailsArray[indexPath.row].fields.drinkCount)) 杯"
        cell.drinkNameLabel.text = backEndDetailsArray[indexPath.row].fields.drinkName
        cell.timeLabel.text = backEndDetailsArray[indexPath.row].fields.orderTime
        

            
        return cell
    }
    
}
