//
//  ViewController.swift
//  HelloWorld
//
//  Created by hongli.yin on 4/28/16.
//  Copyright © 2016 hongli.yin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    @IBOutlet var appsTableView : UITableView!
    @IBOutlet weak var comment: UITextField!
    
    let kSimpleCellIdentifier: String = "SimpleCell"
    
    let api: APIController = APIController()
    
    var tableData = []
    var imageCache = [String:UIImage]()
    var curPost: Post = Post()
    
    func deletePressed(sender: UIButton!) {
        api.delete(curPost.postId, createUserId: myUserId)
    }
    
    func claimPressed(sender: UIButton!) {
        api.claim(curPost.postId, claimUserId: myUserId)
    }
    
    func unClaimPressed(sender: UIButton!) {
        api.unClaim(curPost.postId, claimUserId: myUserId)
    }
    
    @IBAction func createPressed(sender: AnyObject) {
        print(comment.text!)
        api.create(myUserId, comment: comment.text!, canClaim: true)
    }
    
    func didReceiveSimpleResults(results: Bool) {
        dispatch_async(dispatch_get_main_queue(), {
            self.appsTableView!.reloadData()
        })
    }
    
    func didReceiveListResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableData = results
            self.appsTableView!.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    // Load a row in the table. The style of the row is different.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kSimpleCellIdentifier)!
        let rowData: NSDictionary = self.tableData[indexPath.row] as! NSDictionary
        curPost = Post(rowData: rowData)
        
        cell.textLabel?.text = curPost.comment
        cell.detailTextLabel?.text = curPost.claimUserId
        
        // add the button
        let btn = UIButton()
        switch curPost.type {
        case Post.Type.Simple:
            btn.hidden = true
        case Post.Type.ToDelete:
            btn.backgroundColor = UIColor.redColor()
            btn.setTitle("Delete", forState: UIControlState.Normal)
            btn.addTarget(self, action: #selector(ViewController.deletePressed(_:)), forControlEvents: .TouchUpInside)
            break
        case Post.Type.ToClaim:
            btn.backgroundColor = UIColor.greenColor()
            btn.setTitle("Claim", forState: UIControlState.Normal)
            btn.addTarget(self, action: #selector(ViewController.claimPressed(_:)), forControlEvents: .TouchUpInside)
            break
        case Post.Type.ToUnClaim:
            btn.backgroundColor = UIColor.yellowColor()
            btn.setTitle("Unclaim", forState: UIControlState.Normal)
            btn.addTarget(self, action: #selector(ViewController.unClaimPressed(_:)), forControlEvents: .TouchUpInside)
            break
        case Post.Type.Claimed:
            btn.backgroundColor = UIColor.grayColor()
            btn.setTitle("Claimed", forState: UIControlState.Normal)
            btn.enabled = false
        default:
            fatalError()
        }
        btn.frame = CGRectMake(0, 5, 80, 40)
        btn.tag = indexPath.row
        cell.contentView.addSubview(btn)
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // TODO: first check if the server is online
        api.list()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

