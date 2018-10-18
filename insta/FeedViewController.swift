//
//  FeedViewController.swift
//  insta
//
//  Created by Ellis Crawford on 10/1/18.
//  Copyright © 2018 Ellis Crawford. All rights reserved.
//

import UIKit
import Parse


class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [PFObject] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getPosts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50

        // Do any additional setup after loading the view.
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControl.Event.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        let caption = post["caption"] as! String
        cell.captionLabel.text = caption
        let picture = post["media"] as! PFFile
        picture.getDataInBackground { (imageData, error) in
            if error == nil {
                let image = UIImage(data: imageData!)
                cell.photoImageView.image = image
            } else {
                print(error?.localizedDescription ?? "Error instance was nil")
            }
        }
        return cell

    }
    
    @IBAction func onLogout(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)

    }

    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        getPosts()
        refreshControl.endRefreshing()
    }
    func getPosts() {
        // Construct query
        let query = Post.query()
        query?.order(byDescending: "createdAt")
        query?.includeKeys(["author", "createdAt"])
        query?.limit = 20
        
        // Fetch data asynchronously
        query?.findObjectsInBackground(block: { (posts, error) in
            if let posts = posts {
                self.posts = posts
                self.tableView.reloadData() // Reload data
            } else {
                print(error?.localizedDescription ?? "Error instance was nil")
            }
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
