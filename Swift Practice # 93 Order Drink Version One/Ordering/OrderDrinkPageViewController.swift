//
//  OrderDrinkPageViewController.swift
//  Swift Practice # 93 Order Drink Version One
//
//  Created by Dogpa's MBAir M1 on 2021/10/12.
//

import UIKit

class OrderDrinkPageViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var orderPageInfoReayToPass: AirtableFields?                //自定義變數orderPageInfoReayToPass存飲料資料
    
    @IBOutlet weak var drinkPickerView: UIPickerView!           //點飲料的PickerView
    
    @IBOutlet weak var sizeOfDrinkPickView: UIPickerView!       //點大小的PickerView
    
    @IBOutlet weak var numbersDrinkPickerView: UIPickerView!    //點數量的PickerView
    
    @IBOutlet weak var tempPickerView: UIPickerView!            //點溫度的PickerView
    
    @IBOutlet weak var sugarPickerView: UIPickerView!           //點甜度的PickerView
    
    var drinkTypeIndex: Int?        //抓drinkPickerView第ㄧ個omponent的選到的值
    var drinkNameIndex: Int?        //抓drinkPickerView第二個omponent的選到的值飲料名稱
    var numberIndex: Int?           //抓numbersDrinkPickerView選到的值數量
    var sizeIndex: Int?             //抓sizeOfDrinkPickView選到的值大小
    var tempIndex: Int?             //抓tempPickerView選到的值溫度
    var sugarIndex: Int?            //抓sugarPickerView選到的值甜度
    var checkOnlyIce = 0            //用來判斷飲料是否只有冷飲
    var passPrice = 0               //用來儲存飲料總數
    
    //透過自定義struct存所有料名稱並顯示於drinkPickerView
    let drinkShowOnPickerArray = [
        Drink(type: "找特殊", name: ["1號珍四季春波椰", "2號紅茶瑪其朵", "3號黃金烏龍拿鐵", "4號波霸奶茶", "5號冰淇淋綠茶", "6號仙草奶凍", "*7號檸檬養樂多"]),
        Drink(type: "找好茶", name: ["茉莉綠茶", "阿薩姆紅茶", "四季春茶", "黃金烏龍", "檸檬綠", "梅果綠", "桔子綠", "8冰綠", "*養樂多綠", "*冰淇淋紅茶", "旺來紅", "*鮮柚綠"]),
        Drink(type: "找奶茶", name: ["奶茶", "奶綠", "紅茶瑪其朵", "烏龍瑪其朵", "黃金烏龍奶茶", "四季奶青", "阿華田", "可可芭蕾"]),
        Drink(type: "找口感", name: ["波霸紅茶", "波霸綠茶", "波霸奶茶", "波霸奶綠", "波霸烏龍奶茶", "珍珠紅茶", "珍珠綠茶", "珍珠奶茶", "珍珠奶綠", "椰果奶茶", "布丁奶茶"]),
        Drink(type: "找新鮮", name: ["檸檬汁", "金桔檸檬", "檸檬梅汁", "*檸檬養樂多", "8冰茶", "*鮮柚汁", "*葡萄柚多多"]),
        Drink(type: "找紅茶拿鐵", name: ["紅茶拿鐵", "綠茶拿鐵", "黃金烏龍拿鐵", "阿華田拿鐵", "可可芭蕾拿鐵"])
    ]
    //sizeArray存飲料的容量並顯示於sizeOfDrinkPickView
    let sizeArray = ["中杯","大杯"]
    
    //numbersOfArray顯示杯數顯示在numbersDrinkPickerView
    let numbersOfArray = ["1","2","3","4","5","6","7","8","9","10"]
    
    //tempArray為溫度，顯示在tempPickerView
    let tempArray = ["正常冰","少冰","去冰","常溫","溫","熱"]
    
    //sugarArray為甜度，顯示在sugarPickerView
    let sugarArray = ["正常甜","少糖","半糖","微糖","無糖"]
    
    //建立字典模式的fiftyLanMenuComparePrice
    //後續透過進來字典找相對應的key，回給相對應的假格
    let fiftyLanMenuComparePrice = [
        "1號珍四季春波椰中杯": 30,
        "2號紅茶瑪其朵中杯": 40,
        "3號黃金烏龍拿鐵中杯": 50,
        "4號波霸奶茶中杯": 40,
        "5號冰淇淋綠茶中杯": 40,
        "6號仙草奶凍中杯": 40,
        "*7號檸檬養樂多中杯": 55,
        
        "1號珍四季春波椰大杯": 40,
        "2號紅茶瑪其朵大杯": 50,
        "3號黃金烏龍拿鐵大杯": 60,
        "4號波霸奶茶大杯": 50,
        "5號冰淇淋綠茶大杯": 50,
        "6號仙草奶凍大杯": 50,
        "*7號檸檬養樂多大杯": 70,
        
        //找好茶系列
        "茉莉綠茶中杯": 25,
        "阿薩姆紅茶中杯": 25,
        "四季春茶中杯": 25,
        "黃金烏龍中杯": 25,
        "檸檬綠中杯": 40,
        "梅果綠中杯": 40,
        "桔子綠中杯": 40,
        "8冰綠中杯": 40,
        "*養樂多綠中杯": 40,
        "*冰淇淋紅茶中杯": 40,
        "旺來紅中杯": 40,
        "*鮮柚綠中杯": 50,

        "茉莉綠茶大杯": 30,
        "阿薩姆紅茶大杯": 30,
        "四季春茶大杯": 30,
        "黃金烏龍大杯": 30,
        "檸檬綠大杯": 50,
        "梅果綠大杯": 50,
        "*蜂蜜綠大杯": 50,
        "桔子綠大杯": 50,
        "8冰綠大杯": 50,
        "*養樂多綠大杯": 50,
        "*冰淇淋紅茶大杯": 50,
        "旺來紅大杯": 50,
        "*鮮柚綠大杯": 60,

        //找奶茶系列中杯
        "奶茶中杯": 40,
        "奶綠中杯": 40,
        "紅茶瑪其朵中杯": 40,
        "烏龍瑪其朵中杯": 40,
        "黃金烏龍奶茶中杯": 40,
        "四季奶青中杯": 40,
        "阿華田中杯": 40,
        "可可芭蕾中杯": 45,
        //奶茶大杯
        "奶茶大杯": 50,
        "奶綠大杯": 50,
        "紅茶瑪其朵大杯": 50,
        "烏龍瑪其朵大杯": 50,
        "黃金烏龍奶茶大杯": 50,
        "四季奶青大杯": 50,
        "阿華田大杯": 55,
        "可可芭蕾大杯": 60,
        
        //找口感系列中杯
        "波霸紅茶中杯": 30,
        "波霸綠茶中杯": 30,
        "波霸奶茶中杯": 40,
        "波霸奶綠中杯": 40,
        "波霸烏龍奶茶中杯": 40,
        "珍珠紅茶中杯": 30,
        "珍珠綠茶中杯": 30,
        "珍珠奶茶中杯": 40,
        "珍珠奶綠中杯": 40,
        "椰果奶茶中杯": 40,
        "布丁奶茶中杯": 50,
        //找口感大杯
        "波霸紅茶大杯": 40,
        "波霸綠茶大杯": 40,
        "波霸奶茶大杯": 50,
        "波霸奶綠大杯": 50,
        "波霸烏龍奶茶大杯": 50,
        "珍珠紅茶大杯": 40,
        "珍珠綠茶大杯": 40,
        "珍珠奶茶大杯": 50,
        "珍珠奶綠大杯": 50,
        "椰果奶茶大杯": 50,
        "布丁奶茶大杯": 60,

        //找新鮮中杯
        "檸檬汁中杯": 45,
        "金桔檸檬中杯": 45,
        "檸檬梅汁中杯": 50,
        "*檸檬養樂多中杯": 55,
        "8冰茶中杯": 40,
        "*鮮柚汁中杯": 50,
        "*葡萄柚多多中杯": 55,
        //找新鮮大杯
        "檸檬汁大杯": 55,
        "金桔檸檬大杯": 55,
        "檸檬梅汁大杯": 60,
        "*檸檬養樂多大杯": 70,
        "8冰茶大杯": 50,
        "*鮮柚汁大杯": 60,
        "*葡萄柚多多大杯": 70,

        //紅茶拿鐵區中杯
        "紅茶拿鐵中杯": 50,
        "綠茶拿鐵中杯": 50,
        "黃金烏龍拿鐵中杯": 50,
        "阿華田拿鐵中杯": 55,
        "可可芭蕾拿鐵中杯": 60,
        //紅茶拿鐵大杯
        "紅茶拿鐵大杯": 60,
        "綠茶拿鐵大杯": 60,
        "黃金烏龍拿鐵大杯": 60,
        "阿華田拿鐵大杯": 70,
        "可可芭蕾拿鐵大杯": 75
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        drinkPickerView.tag = 0
        numbersDrinkPickerView.tag = 1
        sizeDrinkPickerView.tag = 2
        tempPickerView.tag = 3
        sugarPickerView.tag = 4
 */
        drinkPickerView.dataSource = self
        drinkPickerView.delegate = self
        sizeOfDrinkPickView.dataSource = self
        sizeOfDrinkPickView.delegate = self
        numbersDrinkPickerView.dataSource = self
        numbersDrinkPickerView.delegate = self
        tempPickerView.dataSource = self
        tempPickerView.delegate = self
        sugarPickerView.dataSource = self
        sugarPickerView.delegate = self
        
    }
    
    //picker的component數量
    //透過switch檢查pickerView的tag來決定，只有飲料要顯示2個其他顯示1個
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case 0:
            return 2
        default:
            return 1
        }
    }
    
    //picker的row數透過透過switch檢查pickerView的tag來決定各自對應到各自Array的數量
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView.tag {
        case 0:
            if component == 0 {
                return drinkShowOnPickerArray.count
            }else{
                let selectIndex = drinkPickerView.selectedRow(inComponent: 0)
                return drinkShowOnPickerArray[selectIndex].name.count
            }
        case 1:
            return sizeArray.count          //大小
        case 2:
            return numbersOfArray.count     //數量
        case 3:
            return tempArray.count          //溫度
        case 4:
            return sugarArray.count         //甜度
        default:
            return 0
        }
    }
    
    //pickerView顯示的值透過透過switch檢查pickerView的tag來判斷
    //並顯示各自對應的Array內的名稱
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 0:
            if component == 0 {
                return drinkShowOnPickerArray[row].type
            }else{
                let selectType = drinkPickerView.selectedRow(inComponent: 0)
                return drinkShowOnPickerArray[selectType].name[row]
            }
        case 1:
            return sizeArray[row]
        case 2:
            return numbersOfArray[row]
        case 3:
            return tempArray[row]
        case 4:
            return sugarArray[row]
        default:
            return ""
        }
        
    }
    
    //picker的選到後的執行項目
    //將每個pickerView選到的值存入到自定義的變數內
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //透過switch檢查pickerView的tag
        switch  pickerView.tag {
        case 0:
            pickerView.reloadComponent(1)
            drinkTypeIndex = drinkPickerView.selectedRow(inComponent: 0)
            drinkNameIndex = drinkPickerView.selectedRow(inComponent: 1)
        case 1:
            sizeIndex = sizeOfDrinkPickView.selectedRow(inComponent: 0)
        case 2:
            numberIndex = numbersDrinkPickerView.selectedRow(inComponent: 0)
        case 3:
            tempIndex = tempPickerView.selectedRow(inComponent: 0)
        case 4:
            sugarIndex = sugarPickerView.selectedRow(inComponent: 0)
        default:
            print("")
        }
        //如果drinkTypeIndex為nil，如果直接選飲料將drinkTypeIndex判斷為1
        if drinkTypeIndex == nil {
            drinkTypeIndex = 1
        }


        //print(drinkTypeIndex, drinkNameIndex, sizeIndex, numberIndex, tempIndex, sugarIndex, checkOnlyIce)    //列印測試
        //print("大小杯\(sizeIndex)") //列印測試
        
        
    }
    
    //自定義Function給予不同的警告內容
    func showAlertIfSomethingNotSelect (event:String) {
        let alertController = UIAlertController(title: event, message: "再選一下吧", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "了解", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //判斷是否可以傳值到第1頁
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        //檢查飲料是否只能做冰的
        //將selectDrinkString存入飲料的名稱
        let selectDrinkString = drinkShowOnPickerArray[drinkTypeIndex ?? 0].name[drinkNameIndex ?? 0]
        //checkStringIndex存入selectDrinkString的index只抓第一個
        let checkStringIndex = selectDrinkString.index(selectDrinkString.startIndex, offsetBy: 1)
        //透過checkStringIndex抓到selectDrinkString的第一個字後存入checkMarkString
        let checkMarkString = String(selectDrinkString.prefix(upTo: checkStringIndex))
        
        //檢查飲料溫度參數tempIndex是否為nil
        //如果上面抓出來的checkMarkString自為星字號便表示只能做冷飲
        //如果溫度參數大於3表示選到不是冰的或是常溫
        //便將checkOnlyIce指派為1（後續檢查給警告）
        //如果選到的溫度是冰的checkOnlyIce還是0
        if tempIndex != nil {
            if checkMarkString == "*" {
                if tempIndex! > 3 {
                    checkOnlyIce = 1
                }else{
                    checkOnlyIce = 0
                }
            }
        }
        
        //檢查各個參數是否為nil 以及checkOnlyIce是否為0 ，如果都符合即可送出訂單到第1頁
        if drinkNameIndex != nil, sizeIndex != nil , numberIndex != nil, tempIndex != nil, sugarIndex != nil, checkOnlyIce == 0 {
            return true
        }else{
            
            //如果不是針對不同的參數判斷給不同的警告並回傳false
            if drinkNameIndex == nil {
                showAlertIfSomethingNotSelect(event: "沒選飲料啦")
            }else if sizeIndex == nil {
                showAlertIfSomethingNotSelect(event: "沒選容量呦")
            }else if numberIndex == nil {
                showAlertIfSomethingNotSelect(event: "杯數沒選喔")
            }else if tempIndex == nil {
                showAlertIfSomethingNotSelect(event: "冰塊沒選喔")
            }else if sugarIndex == nil {
                showAlertIfSomethingNotSelect(event: "請選擇甜度")
            }else if checkOnlyIce == 1 {
                showAlertIfSomethingNotSelect(event: "所選飲料只能冷飲")
            }
            return false
        }
    }
    
    //傳資料的內容透過prepare來協助傳送
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //透過剛剛存好的參數Index回去各自的Array抓到個字的值或字存入到pass系列
        let passName = drinkShowOnPickerArray[drinkTypeIndex!].name[drinkNameIndex!]
        let passSize = sizeArray[sizeIndex!]
        let passTemp = tempArray[tempIndex!]
        let passSugar = sugarArray[sugarIndex!]
        
        //透過建立好的字典透過飲料名稱與容量建立key進去字典找value後存入drinkPirce
        //drinkPirce為單杯的價錢
        //checkCount指派為選擇杯數轉Int類別
        //passPrice就為單杯價格乘杯數
        let drinkPirce = fiftyLanMenuComparePrice["\(passName)\(passSize)"]
        let checkCount = Int(numbersOfArray[numberIndex!])
        let passCount = Int(checkCount!)
        print(passName, passSize, checkCount, drinkPirce)
        if checkCount != nil {
            passPrice = drinkPirce! * Int(passCount)
        }
        //建立dateFormatter取的訂單送出的時間
        //時間格式指派為"YYYY-MM-dd'T'HH:mm:ss.SSS"
        //因為Airtable的時間格式為YYYY-MM-dd'T'HH:mm:ss.SSSZ
        //passDateString的字串為現在時間的字串後+上Z與Airtable時間格式一樣
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSS"
        let nowString = dateFormatter.string(from: Date())
        let passDateString = nowString+"Z"
        
        //將七個Airtable上傳需要的參數存入到orderPageInfoReayToPass並回傳
        orderPageInfoReayToPass = AirtableFields(fields: DrinkDetails(orderTime: passDateString, drinkName: passName, drinkSize: passSize, drinkCount: passCount, tempType: passTemp, sugarType: passSugar, totalPrice: passPrice  ))
    }
    
}
