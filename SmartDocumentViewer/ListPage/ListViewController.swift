//
//  ListViewController.swift
//  SmartDocumentViewer
//
//  Created by Aiysha on 15/04/25.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var _tableView: UITableView!
    
    var listVM : ListpageViewModal {
        let listVM = ListpageViewModal()
        listVM.readAPIListtoVMObj()
        return listVM
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application\nyou will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ListViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listVM.listVM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.textColor = .darkGray
        cell.textLabel?.numberOfLines = 0
        
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        cell.detailTextLabel?.textColor = .darkGray
        cell.detailTextLabel?.numberOfLines = 0
        
        
        let object = self.listVM.listVM[indexPath.row]
        
        cell.textLabel?.text = object.name
        cell.detailTextLabel?.text = "----"
        if let subData = self.listVM.dataClassVM.filter({$0.foreignID == object.id}).first {
            cell.detailTextLabel?.text =  self.listVM.concatenateFeatures(data: subData)
        }
        
        return cell
    }
    
    
    
}
