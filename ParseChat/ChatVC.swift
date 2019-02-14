//
//  ChatVC.swift
//  ParseChat
//
//  Created by Henry Guerra on 2/3/19.
//  Copyright © 2019 Henry Guerra. All rights reserved.
//

import UIKit
import Parse

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var messages: [PFObject] = []
    var timer: Timer?
    let cellSpacingHeight: CGFloat = 10
    
    // TableView methods (2)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCellTableViewCell
        
        let message = messages[indexPath.section]
        cell.chatMsg.text = message["text"] as? String
        
        if let user = message["user"] as? PFUser {
            // User found! update username label with username
            cell.userName.text = user.username
        } else {
            // No user found, set default username
            cell.userName.text = "💩"
        }
        return cell
    }
    
    

    // public outlets
    @IBOutlet weak var messageInput: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    
    
    // Public Actions
    @IBAction func sendChatButton(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = messageInput.text ?? ""
        chatMessage["user"] = PFUser.current()
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.messageInput.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
        // uppon successful chat send, clear text input
        messageInput.text = ""
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        PFUser.logOut()
        self.navigationController?.dismiss(animated: true, completion: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "Main")
            let window :UIWindow? = UIApplication.shared.keyWindow
            window?.rootViewController = loginViewController
            self.timer?.invalidate()
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //chatTableView.separatorStyle = .none
        chatTableView.dataSource = self
        chatTableView.delegate = self
        
        chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.estimatedRowHeight = 50
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getMessages), userInfo: nil, repeats: true)
        getMessages()

    }
    
    @objc func getMessages() {
        let query = PFQuery(className: "Message")
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        
        query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) in
            if let messages = messages {
                self.messages = messages
                print(self.messages)
                self.chatTableView.reloadData()
            } else {
                print("Error from chat view controller trying to get messages in fetchMessages() function with localized description \"\(error!.localizedDescription)\"")
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
