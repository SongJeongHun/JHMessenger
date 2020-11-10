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
    let db = Database.database().reference().child("송정훈")
    //친구 목록 관련
    var dummyList:[Friends] = [Friends(name: "염종건", comment: "ㅇ")]
    var friendsList:[String] = []
    
    //채팅 관련
    var myChatData:ChatContent = ChatContent(name: "송정훈", messages: [Message(sender: "염종건", receiver: "송정훈", content: "ㅇㅇ"),Message(sender: "염종건", receiver: "송정훈", content: "ㅋㅋㅋ"),Message(sender: "염종건", receiver: "송정훈", content: "ㅇㅎ"),Message(sender: "김경모", receiver: "송정훈", content: "ㅋㅋㅋㅋㅋㅋ"),Message(sender: "송정훈", receiver: "염종건", content: "ㅋㅋ"),Message(sender: "송정훈", receiver: "염종건", content: "ㅋㅋ"),Message(sender: "송정훈", receiver: "김경모", content: "ㅋㅋ"),Message(sender: "송정훈", receiver: "염종건", content: "ㅋㅋ")])
    
    var receiveMessage:[Message] = []
    var sendMessage:[Message] = []
    
    func test(){
        self.dummyList.append(Friends(name: "김경모", comment: "ㅋ"))
    }
    
    func getFriendsList(){
        self.db.child("friends").observeSingleEvent(of: .value){DataSnapshot in
            guard let friendsData = DataSnapshot.value as? [String:Any] else { return }
            let data = try! JSONSerialization.data(withJSONObject: Array(friendsData.values), options: [])
            let decoder = JSONDecoder()
            let friendsList = try! decoder.decode([Friends].self, from: data)
            self.dummyList = friendsList
            print("get Finisehd")
    
        }
        
        print("function Finished")
    }
    func addFriends(name:String) -> Bool{
        guard friendsList.contains(name) else {
            db.child("friends").child(name).setValue(["name":name,"comment":"안녕하세요."])
            getFriendsList()
            for i in self.dummyList{
                self.friendsList.append(i.name)
            }
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
        var dict:[String:Message] = [:]
        for i in self.receiveMessage{
            let name = i.sender
            dict.updateValue(i, forKey: name)
        }
        for i in self.sendMessage{
            let name = i.receiver
            dict.updateValue(i, forKey: name)
        }
        return dict
    }
    func mergeContentByName(_ name:String) -> [Message]{
        var array:[Message] = []
        for i in self.receiveMessage{
            if i.sender == name{
                array.append(i)
            }
        }
        for i in self.sendMessage{
            if i.receiver == name{
                array.append(i)
            }
        }
        return array
    }
    func sendMessage(sender:String,receiver:String,content:String){
        self.myChatData.messages.append(Message(sender: sender, receiver: receiver, content: content))
    }
}
