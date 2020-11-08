//
//  ChatContentViewController.swift
//  JHMessenger
//
//  Created by 송정훈 on 2020/11/06.
//

import UIKit

class ChatContentViewController: UIViewController {
    var currentName:String!
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var tableView:UITableView!
    override func viewDidLoad() {
        DatabaseManager.shared.initializeMessages()
        DatabaseManager.shared.getMessage()
        name.text = currentName
        super.viewDidLoad()
    }
    
}
extension ChatContentViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        DatabaseManager.shared.sendMessage.count +
        return  DatabaseManager.shared.receiveMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chattingCell") as? chattingCell else {  return UITableViewCell()}
        cell.friendsName.text = self.currentName
        
//        //송신된 메세지
//        cell.chatContent.text = DatabaseManager.shared.sendMessage[indexPath.row].content
//
        //수신된 메세지
        cell.chatContent.text = DatabaseManager.shared.receiveMessage[indexPath.row].content
    
        return cell
    }

    
}
struct ChatContent{
    let name:String
    let messages:[Message]
}
struct Message {
    let sender:String
    let receiver:String
    let content:String
}
class chattingCell:UITableViewCell{
    @IBOutlet weak var friendsName:UILabel!
    @IBOutlet weak var chatContent:UILabel!
    @IBOutlet weak var thumbNail:UIImageView!
}
