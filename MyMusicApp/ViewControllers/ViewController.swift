//
//  ViewController.swift
//  MyMusicApp
//
//  Created by eun-ji on 2023/03/12.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    
    var musicModel: MusicModel?
    var term = ""
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }

    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        if let hasURL = URL(string: urlString) {
            var request = URLRequest(url: hasURL)
            request.httpMethod = "GET"
            
            session.dataTask(with: request) { data, response, error in
                if let hasData = data {
                    completion(UIImage (data: hasData))
                    return
                }
            }.resume()
            session.finishTasksAndInvalidate()
        }
        completion(nil)
    }
    
    func requestAPI() {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        var baseUrl = URLComponents(string: "https://itunes.apple.com/search")
        let term = URLQueryItem(name: "term", value: term)
        let media = URLQueryItem(name: "media", value: "music")
        let entity = URLQueryItem(name: "entity", value: "musicVideo")
        
        baseUrl?.queryItems = [term, media, entity]
        guard let url = baseUrl?.url else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { data, response, error in
            print((response as! HTTPURLResponse).statusCode)
            if let hasData = data {
                do {
                    self.musicModel = try JSONDecoder().decode(MusicModel.self, from: hasData)
                    print(self.musicModel ?? "nodata")
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }catch {
                    print(error)
                }
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
   
    }
    
    func saveTerm(){
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "MySearch", in: context) else {return}
        guard let object = NSManagedObject(entity: entityDescription, insertInto: context) as? MySearch else {return}
        
        object.term = searchBar.text
        object.uuid = UUID()
        
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.saveContext()
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicModel?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicTVC") as! MusicTVC
        cell.trackName.text = self.musicModel?.results[indexPath.row].trackName
        cell.artistName.text = self.musicModel?.results[indexPath.row].artistName
        if let hasURL = self.musicModel?.results[indexPath.row].artworkUrl100{
            self.loadImage(urlString: hasURL) { image in
                DispatchQueue.main.async {
                    cell.musicImageView.image = image
                }
            }
        }
        
        if let dateString = self.musicModel?.results[indexPath.row].releaseDate{
            let formatter = ISO8601DateFormatter()
            if let isoDate = formatter.date(from: dateString) {
                let myFormatter = DateFormatter()
                myFormatter.dateFormat = "yyyy-MM-dd"
                let dateString = myFormatter.string(from: isoDate)
                cell.dateLabel.text = dateString
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.musicResult = self.musicModel?.results[indexPath.row]
        self.present(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let hasText = searchBar.text else {return}
        term = hasText
        saveTerm()
        requestAPI()
        self.view.endEditing(true)
    }
}
