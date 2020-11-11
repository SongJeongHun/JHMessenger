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
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    var dict:[String:Message] = [:]
    let db = Database.database().reference().child("송정훈")
    //친구 목록 관련
    var dummyList:[Friends] = []
    var friendsList:[String] = []
    
    //채팅 관련
    var myChatData:[Message] = []
    var currentChat:[Message] = []
    
    
    var receiveMessage:[Message] = []
    var sendMessage:[Message] = []
    func getFriendsList(_ view:UICollectionView){
        self.db.child("friends").observeSingleEvent(of: .value){DataSnapshot in
            guard let friendsData = DataSnapshot.value as? [String:Any] else { return }
            let data = try! JSONSerialization.data(withJSONObject: Array(friendsData.values), options: [])
            let decoder = JSONDecoder()
            let friendsList = try! decoder.decode([Friends].self, from: data)
            self.dummyList = friendsList
            self.dummyList.sort(by: { $0.name < $1.name })
            view.reloadData()
        }
        
    }
    func addFriends(name:String) -> Bool{
        guard friendsList.contains(name) else {
            db.child("friends").child(name).setValue(["name":name,"comment":"안녕하세요."])
            for i in self.dummyList{
                self.friendsList.append(i.name)
            }
            return true
        }
        return false
    }
    func getMessage(_ view:Any){
        self.db.child("messages").observeSingleEvent(of: .value){ [self]DataSnapshot in
            guard let friendsData = DataSnapshot.value as? [String:Any] else { return }
            self.initializeMessages()
            let data = try! JSONSerialization.data(withJSONObject: Array(friendsData.values), options: [])
            let decoder = JSONDecoder()
            let chatList = try! decoder.decode([Message].self, from: data)
            self.myChatData = chatList
            guard let messages:[Message] = myChatData else { return }
            for i in messages {
                if i.sender == "송정훈"{
                    self.sendMessage.append(i)
                }else{
                    self.receiveMessage.append(i)
                }
            }
            self.mergeSender()
           
            if let v = view as? UICollectionView {
                v.reloadData()
                print("reload\(self.dict.count)")
                
            }else if let v = view as? UITableView{
                v.reloadData()
                print("reload\(self.dict.count)")
            }
        }
        
    }
    func initializeMessages(){
        self.myChatData = []
        self.receiveMessage = []
        self.sendMessage = []
        self.currentChat = []
    }
    func mergeSender(){
        for i in self.receiveMessage{
            let name = i.sender
            self.dict.updateValue(i, forKey: name)
        }
        for i in self.sendMessage{
            let name = i.receiver
            self.dict.updateValue(i, forKey: name)
        }
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
        let initDate = formatter.string(for: Date())!
        var dict:[String:Any] = ["sender":sender,"receiver":receiver,"content":content,"initDate":initDate]
        db.child("messages").childByAutoId().setValue(dict)
    }
}
