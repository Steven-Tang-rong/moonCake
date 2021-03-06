//
//  FMTableViewController.swift
//  moonCake
//
//  Created by TANG,QI-RONG on 2020/9/5.
//  Copyright © 2020 Steven. All rights reserved.
//

import UIKit

class FMTableViewController: UITableViewController {

    var FmStationData = [FMStationData]()
    let FMStation = "https://sheetdb.io/api/v1/fim6gdre7wzmi"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: FMStation) {
            URLSession.shared.dataTask(with: url) {(data, response, erroe) in
                let decoder = JSONDecoder()
                if let data = data, let FMresult = try? decoder.decode([FMStationData].self ,from: data){
                            
                    self.FmStationData = FMresult
                       
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }.resume()
          
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return FmStationData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(FMdataCell.self)", for: indexPath) as! FMdataCell

        let FM = FmStationData[indexPath.row]
        cell.FMbrandLabel.text = FM.brand
        cell.FMitemLabel.text = FM.itemName
        cell.FMpriceLabel.text = "\(FM.price) 元"
        cell.FMimageCell.image = nil
        
        URLSession.shared.dataTask(with: FM.photo) {(data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    cell.FMimageCell.image = UIImage(data: data)
                }
            }
        }.resume()
        
        return cell
    }
    
 //MARK: - IBSegue to Shopping cart
    
    @IBSegueAction func FMDetailSegue(_ coder: NSCoder) -> shoppingcartViewController? {
       
        let destinationController = shoppingcartViewController(coder: coder)

        if let row = tableView.indexPathForSelectedRow?.row {
            
            destinationController?.shopFM = FmStationData[row]
            
            
        }
        return destinationController
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
