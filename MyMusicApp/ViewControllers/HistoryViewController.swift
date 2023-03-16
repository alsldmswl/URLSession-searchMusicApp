//
//  HistoryViewController.swift
//  MyMusicApp
//
//  Created by eun-ji on 2023/03/13.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var searchList = [MySearch]()
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var searchTerm: MySearch?
    @IBOutlet weak var historyTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        historyTableView.reloadData()
    }
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<MySearch> = MySearch.fetchRequest()
        
        let context = appdelegate.persistentContainer.viewContext
        do {
            self.searchList = try context.fetch(fetchRequest)
        }catch {
            print(error)
        }
    }
    
    //    @IBAction func deleteButton(_ sender: UIButton) {
    //        guard let hasData = searchTerm else {return}
    //        guard let hasUUID = hasData.uuid else {return}
    //        let fetchRequest: NSFetchRequest<MySearch> = MySearch.fetchRequest()
    //        fetchRequest.predicate = NSPredicate(format: "uuid = %@", hasUUID as CVarArg)
    //
    //        do{
    //            let loadedData = try context.fetch(fetchRequest)
    //            print("loadedData")
    //            if let loadFirstData = loadedData.first {
    //                print(loadFirstData)
    //                context.delete(loadFirstData)
    //                let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    //                appDelegate.saveContext()
    //            }
    //        }catch {
    //            print(error)
    //        }
    //
    //
    //        fetchData()
    //        historyTableView.reloadData()
    //
    //    }
    
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        cell.termLabel.text = searchList[indexPath.row].term
        
        cell.configure(with: indexPath.row)
        cell.delegate = self
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension HistoryViewController: MyTableViewCellDelegate {
    func didTapButton(with idx: Int) {
        context.delete(searchList[idx])
        
        do {
            try context.save()
        } catch {
            
        }
        fetchData()
        historyTableView.reloadData()
    }
}
