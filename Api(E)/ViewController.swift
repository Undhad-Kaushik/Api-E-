//
//  ViewController.swift
//  Api(E)
//
//  Created by undhad kaushik on 02/03/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var apiTabelView: UITableView!
    
    var arrMain: Main!
    var arr: [Datasery] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nibRegister()
        apiE()
    }
    
    private func nibRegister(){
        let nibFile: UINib = UINib(nibName: "TableViewCell", bundle: nil)
        apiTabelView.register(nibFile, forCellReuseIdentifier: "cell")
        apiTabelView.delegate = self
        apiTabelView.dataSource = self
        apiTabelView.separatorStyle = .none
        
    }
    
    private func apiE(){
        AF.request("https://www.7timer.info/bin/astro.php?lon=113.2&lat=23.1&ac=0&unit=metric&output=json&tzshift=0", method: .get).responseData{ [self] response in
            if response.response?.statusCode == 200{
                guard let apiData = response.data else { return }
                do{
                    let result = try JSONDecoder().decode(Main.self, from: apiData)
                    print(result)
                    arrMain = result
                    arr = arrMain.dataseries
                    apiTabelView.reloadData()
                }catch{
                    print(error.localizedDescription)
                }
                
            }else{
                print("Wrong")
            }
        }
        
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMain?.dataseries.count ?? 0
        return arr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.label1.text = "\(arrMain.dataseries[indexPath.row].timepoint)"
        cell.label2.text = "\(arrMain.dataseries[indexPath.row].cloudcover)"
        cell.label3.text = "\(arrMain.dataseries[indexPath.row].seeing)"
        cell.label4.text = "\(arrMain.dataseries[indexPath.row].transparency)"

        return cell
    }
}




struct Main: Decodable{
    var product: String
    var count: String
    var dataseries: [Datasery]


    enum CodingKeys: String, CodingKey{
        case count = "init"
        case product
        case dataseries
    }
}

struct Datasery: Decodable{
    var timepoint: Int
    var cloudcover: Int
    var seeing: Int
    var transparency: Int
    var lifted_index: Int
    var rh2m: Int
    var wind10m: Wind10m
    var temp2m: Int
    var precType: String
    enum CodingKeys: String, CodingKey {
        case precType = "prec_type"
        case timepoint , cloudcover , seeing , transparency , lifted_index , rh2m , wind10m , temp2m
    
    }
}

struct Wind10m: Decodable{
    var direction: String
    var speed: Int
    
    enum CodingKeys: String , CodingKey{
        case direction , speed
    }
}
