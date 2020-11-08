//
//  DatabaseManger.swift
//  JHMessenger
//
//  Created by 송정훈 on 2020/11/05.
//

import Foundation
import Firebase
class DatabaseManager{
    static let shared = DatabaseManager()
    private init(){
        //Singleton 싱글톤
    }
    let db = Database.database().reference().child("friends")
    //친구 목록 관련
    var dummyList:[Friends] = [Friends(name: "김경모", comment: "ㅎㅇ"),Friends(name: "염종건", comment: "안녕하세요")]
    var friendsList:[String] = ["김경모","염종건"]
    
    //채팅 관련
    var myChatData:ChatContent = ChatContent(name: "송정훈", messages: [Message(sender: "염종건", receiver: "송정훈", content: "ㅇㅇ"),Message(sender: "염종건", receiver: "송정훈", content: "ㅋㅋㅋ"),Message(sender: "염종건", receiver: "송정훈", content: "ㅇㅎ"),Message(sender: "김경모", receiver: "송정훈", content: "ㅋㅋㅋㅋㅋㅋ"),Message(sender: "송정훈", receiver: "염종건", content: "ㅋㅋ")])
    
    var receiveMessage:[Message] = []
    var sendMessage:[Message] = []
    
    func addFriends(name:String) -> Bool{
        guard friendsList.contains(name) else {
            dummyList.append(Friends(name: name, comment: "안녕하세요"))
            friendsList.append(name)
            return true
        }
        return false
    }
    func getMessage(){
        guard let messages:[Message] = myChatData.messages else { return }
        for i in messages {
            if i.sender == "송정훈"{
                self.sendMessage.append(i)
            }else{
                self.receiveMessage.append(i)
            }
        }
    }
    func initializeMessages(){
        self.receiveMessage = []
        self.sendMessage = []
    }
    func mergeSender() -> [String:Message]{
        let array = self.receiveMessage
        var dict:[String:Message] = [:]
        for i in array{
            let name = i.sender
            dict.updateValue(i, forKey: name)
        }
        return dict
    }
}
