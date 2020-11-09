//
//  ChatContentViewController.swift
//  JHMessenger
//
//  Created by 송정훈 on 2020/11/06.
//


import UIKit

class ChatContentViewController: UIViewController {
    var currentName:String = ""
    var currentChat:[Message] = []
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var message:UITextField!
    @IBAction func sendMessage(_ sender:Any){
        guard let message = message.text ?? "" else { return }
        DatabaseManager.shared.sendMessage(sender: "송정훈", receiver: self.currentName, content:message )
        DatabaseManager.shared.initializeMessages()
        DatabaseManager.shared.getMessage()
        self.currentChat = DatabaseManager.shared.mergeContentByName(currentName)
        tableView.reloadData()
    }
    override func viewDidLoad() {
        DatabaseManager.shared.initializeMessages()
        DatabaseManager.shared.getMessage()
        name.text = currentName
        super.viewDidLoad()
    }
}
extension ChatContentViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  currentChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentChat[indexPath.row].sender == "송정훈" {
            //송신 메세지
            let mycell = tableView.dequeueReusableCell(withIdentifier: "mycell") as! mycell
            mycell.chatContent.text = currentChat[indexPath.row].content
            return mycell
            
        }else{
            //수신 메세지
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "chattingCell") as? chattingCell else {  return UITableViewCell() }
            cell.chatContent.text = currentChat[indexPath.row].content
            cell.friendsName.text = self.currentName
            return cell
        }
    }
}
struct ChatContent{
    let name:String
    var messages:[Message]
}
struct Message {
    let sender:String
    let receiver:String
    let content:String
//    let initTime:Date
//    let read:Bool
}
class chattingCell:UITableViewCell{
    @IBOutlet weak var friendsName:UILabel!
    @IBOutlet weak var chatContent:UILabel!
    @IBOutlet weak var thumbNail:UIImageView!
}
class mycell:UITableViewCell{
    @IBOutlet weak var chatContent:UILabel!
}
