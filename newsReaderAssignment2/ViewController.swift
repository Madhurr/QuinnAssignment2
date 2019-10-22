//
//  ViewController.swift
//  newsReaderAssignment2
//
//  Created by Madhur on 22/10/19.
//  Copyright © 2019 Madhur. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
   
    
    
 
    @IBOutlet weak var tableView: UITableView!
    
    
    var articles: [Article]? = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchArticals()
    }
    
    // This function is responsible for fetching News Data as JSON and map it to Article.swift as model class
    func fetchArticals(){
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=0d7750a250ae493392c5f7c973c9f19d")!)
        
        // When task is executing it will call a closure it will capture data and response or if request fails it will also throw error
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            if error != nil {
                print(error)
                return
            }
            
            // Creating array of object of article
            self.articles = [Article]()
            // data Serilization of JSON
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                // casting json artical's array into array of dictonaries
                
                if let articelsFromJSon = json["articles"] as? [[String : AnyObject]] {
                    for articleFromJSon in articelsFromJSon{
                        let article = Article()
                        if let title = articleFromJSon["title"] as? String, let author = articleFromJSon["author"] as? String, let desc = articleFromJSon["description"] as? String, let url = articleFromJSon["url"] as? String , let urlToImage = articleFromJSon["urlToImage"] as? String {
                            article.author = author
                            article.headLine = title
                            article.desc  = desc
                            article.url = url
                            article.imageUrl = urlToImage
                        }
                        self.articles?.append(article)
                    }
                }
                DispatchQueue.main.async {
                  self.tableView.reloadData()
                }
            }catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "articleCell" , for: indexPath) as! ArticleCell
        cell.title.text = self.articles?[indexPath.item].headLine
        cell.desc.text = self.articles?[indexPath.item].desc
        cell.author.text = self.articles?[indexPath.item].author
        cell.imgView.downloadImage(from: (self.articles?[indexPath.item].imageUrl ?? "nil"))
        
        return cell
       }
    
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
          }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "web") as! WebviewViewController
        webVC.url = self.articles?[indexPath.item].url
        self.present(webVC, animated: true, completion: nil)
    }

}
extension UIImageView {
    func downloadImage(from url: String){
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) {(data,response,error) in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
    }
        task.resume()
}
}
