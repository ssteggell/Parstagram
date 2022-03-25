//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Spencer Steggell on 3/22/22.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    

    @IBOutlet weak var tableView: UITableView!
    var posts = [PFObject]()
    let myRefreshControl = UIRefreshControl()
    var postArray = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myRefreshControl.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        tableView.refreshControl?.tintColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadPosts()
    }
    
    @objc func loadPosts() {
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
               // self.posts.removeAll()
                self.posts = posts!
                self.tableView.reloadData()
                self.myRefreshControl.endRefreshing()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostCellTableViewCell
        
        
        let post = posts[indexPath.row]
        let user = post["author"] as! PFUser
        cell.userNameLabel.text = ("\(user.username ?? "User"):")
        cell.commentLabel.text = (post["caption"] as! String)
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.photoView.af.setImage(withURL: url)
        
        return cell
    }
    


}
