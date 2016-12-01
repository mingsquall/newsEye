//
//  ViewController.swift
//  newsEye
//
//  Created by Patientman on 2016/12/1.
//  Copyright © 2016年 mingSquall. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var articles:[Article]? = []
    var source = "cnn"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fetchArticles(fromSource: source)
        
    }

    func fetchArticles(fromSource provider: String) {
        // 1 Create a URL Request and unwrap
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v1/articles?source=\(provider)&sortBy=top&apiKey=8fefc4d3bfbf4e2bb651379d98422d86")!)
        // 2 Create a tasks URLSession& download things from the http - data is the JSON ,
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            // check error
            if error != nil {
                print(error!)
                return
            }
            
            // Init articles array so that It can create the object
            self.articles = [Article]()
            
            // JSON - try catch - transfer to an Dictionary like [author : "balbalbal"]
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                // 如果可能的话 把json中的articles数组取出来 as Dictionary of Array
                if let articlesArrayFromJson = json["articles"] as? [[String : AnyObject]] {
                    // for every article in All
                    
                    // MARK: For in Loop to get the JSON Data
                    for articleArrayFromJson in articlesArrayFromJson {
                        // 设置article对象
                        let article = Article()
                        if let title = articleArrayFromJson["title"] as? String,
                           let author = articleArrayFromJson["author"] as? String,
                           let desc = articleArrayFromJson["description"] as? String,
                           let url = articleArrayFromJson["url"] as? String,
                           let urlToImage = articleArrayFromJson["urlToImage"] as? String {
                                article.author = author
                                article.desc = desc
                                article.title = title
                                article.url = url
                                article.imageUrl = urlToImage
                        } else {
                            article.author = "Null"
                            article.desc = "Null"
                            article.title = "Null"
                            article.url = "Null"
                            article.imageUrl = "Null"
                        }
                        
                        self.articles?.append(article)
                    }
                    // 放在主线程中 这样可以立马看到 否则在background中会很慢
                    // Reload Data of the TableView - Go to the Main Thread
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }

                    
                }
            } catch let error{
                print(error)
            }
        }
        // 启动URLSession
        task.resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: 设置Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        cell.title.text = self.articles?[indexPath.item].title
        cell.desc.text = self.articles?[indexPath.item].desc
        cell.author.text = self.articles?[indexPath.item].author
        cell.imgView.downLoadImage(from: (self.articles?[indexPath.item].imageUrl)!)
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // here 如果json有错误的话 articles.count == nil 这时候用 0
        return self.articles?.count ?? 0
    }
    
    // 得到被选中的某一行的 URL 然后 传递到 webDetailVC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "web") as! WebDetailViewController
        webVC.url = self.articles?[indexPath.item].url
        self.present(webVC, animated: true, completion: nil)
        
    }
    
    // MARK: 点击Menu
    let menuManager = MenuManager()
    @IBAction func menuClicked(_ sender: UIBarButtonItem) {
        menuManager.openMenu()
        menuManager.mainVC = self
    }
    


}

// Set the Image Based on the URl
extension UIImageView {
    func downLoadImage(from url: String) {
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response,error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        
        }
        task.resume()
    }
}















