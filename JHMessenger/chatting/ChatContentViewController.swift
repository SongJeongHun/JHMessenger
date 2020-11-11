//
//  ChatContentViewController.swift
//  JHMessenger
//
//  Created by 송정훈 on 2020/11/06.
//


import UIKit
import Firebase

class ChatContentViewController: UIViewController, UITableViewDelegate {
    let db = Database.database().reference().child("송정훈")
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    var currentName:String = ""
    var currentChat:[Message] = []
    var chatData:[Message] = []
    var sendMessage:[Message] = []
    var receiveMessage:[Message] = []
    var keyboardShowToken:NSObjectProtocol?
    var keyboardHideToken:NSObjectProtocol?
    deinit {
        if let token = keyboardShowToken{
            NotificationCenter.default.removeObserver(token)
        }
        if let token = keyboardHideToken{
            NotificationCenter.default.removeObserver(token)
        }
    }
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var message:UITextField!
    @IBOutlet weak var plusButton:UIButton!
    @IBOutlet weak var sendButton:UIButton!
    @IBAction func sendMessage(_ sender:Any){
        guard let message = message.text ?? "" else { return }
//            DatabaseManager.shared.sendMessage(sender: "송정훈", receiver: self.currentName, content:message )
//            DatabaseManager.shared.getMessage(tableView)
//            currentChat = DatabaseManager.shared.mergeContentByName(currentName)
        
        let initDate = formatter.string(for: Date())!
        let timestamp:Double = Date().timeIntervalSince1970.rounded()
    
        var dict:[String:Any] = ["sender":"송정훈","receiver":self.currentName,"content":message,"initTime":initDate,"timestamp":timestamp]
        db.child("messages").childByAutoId().setValue(dict)
        //데이터 저장
        self.db.child("messages").observeSingleEvent(of: .value){ [self]DataSnapshot in
            guard let friendsData = DataSnapshot.value as? [String:Any] else { return }
            currentChat = []
            chatData = []
            sendMessage = []
            receiveMessage = []
            let data = try! JSONSerialization.data(withJSONObject: Array(friendsData.values), options: [])
            let decoder = JSONDecoder()
            let chatList = try! decoder.decode([Message].self, from: data)
            chatData = chatList
            guard let messages:[Message] = chatData else { return }
            for i in messages {
                if i.sender == "송정훈"{
                   sendMessage.append(i)
                }else{
                    receiveMessage.append(i)
                }
            }
            for i in receiveMessage{
                if i.sender == currentName{
                    currentChat.append(i)
                }
            }
            for i in sendMessage{
                if i.receiver == currentName{
                    currentChat.append(i)
                }
            }
            currentChat.sort(by:{$0.timestamp < $1.timestamp})
            tableView.reloadData()
        }
        self.message.text = ""
        //notification 추가 하기 채팅방 목록 reloadData
        NotificationCenter.default.post(name: ChatContentViewController.sendFinised, object: nil)
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DatabaseManager.shared.getMessage(tableView)
        name.text = currentName
        keyboardShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main,using: {(noti) in
            if let keyboardFrame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
                //키보드 높이를 저장
                let height = keyboardFrame.cgRectValue.height
                for constraint in self.view.constraints{
                    if constraint.identifier == "chatConstraint"{
                        constraint.constant =  height + self.message.bounds.height
                    }
                }
            }
        })
        keyboardHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: {noti in
            for constraint in self.view.constraints{
                if constraint.identifier == "chatConstraint"{
                    constraint.constant = 117
                }
            }
        })
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
            mycell.date.text = currentChat[indexPath.row].initTime
            return mycell
            
        }else{
            //수신 메세지
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "chattingCell") as? chattingCell else {  return UITableViewCell() }
            cell.chatContent.text = currentChat[indexPath.row].content
            cell.date.text = currentChat[indexPath.row].initTime
            cell.friendsName.text = self.currentName
            return cell
        }
    }
}

struct Message:Codable{
    let sender:String
    let receiver:String
    let content:String
    let initTime:String
    let timestamp:Date
//    let read:Bool
}
class chattingCell:UITableViewCell{
    @IBOutlet weak var friendsName:UILabel!
    @IBOutlet weak var chatContent:UILabel!
    @IBOutlet weak var thumbNail:UIImageView!
    @IBOutlet weak var date:UILabel!
}
class mycell:UITableViewCell{
    @IBOutlet weak var chatContent:UILabel!
    @IBOutlet weak var date:UILabel!
}
extension ChatContentViewController{
    static let sendFinised = Notification.Name("sendFinised")
}

