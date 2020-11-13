//
//  DatabaseManger.swift
//  JHMessenger
//
//  Created by 송정훈 on 2020/11/05.
//

import Foundation
import Firebase
class DatabaseManager{
    let myname = "송정훈"
    static let shared = DatabaseManager()
    private init(){
        
        
        //Singleton 싱글톤
    }
    //세마포어 -> 비동기 처리 네트워킹 작업을 동기화 처리
    //ex) semaphore가 semaphore.signal() 을 보낼때 까지 semaphore.wait() 라인에서 기다림
//    let semaphore = DispatchSemaphore(value: 0)
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    
    let db = Database.database().reference().child("송정훈")
    //친구 목록 관련
    var dummyList:[Friends] = []
    var friendsList:[String] = []
    
    //채팅 관련
    var myChatData:[Message] = []
    var currentChat:[Message] = []
    
    var receiveMessage:[Message] = []
    var sendMessage:[Message] = []
    
    var sortedDict:Array<(String,Message)> = []
    
    
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
            messages.sorted(by:{$0.timestamp < $1.timestamp})
            for i in messages {
                if i.sender == myname{
                    self.sendMessage.append(i)
                    self.sendMessage.sort(by: {$0.timestamp < $1.timestamp})
                    
                }else{
                    self.receiveMessage.append(i)
                    self.receiveMessage.sort(by: {$0.timestamp < $1.timestamp})
                }
            }
            self.mergeSender()
            if let v = view as? UICollectionView {
                v.reloadData()
                print("reload\(self.sortedDict.count)")
                
            }else if let v = view as? UITableView{
                v.reloadData()
                print("reload\(self.sortedDict.count)")
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
        var dict:[String:Message] = [:]
        for i in self.receiveMessage{
            let name = i.sender
            dict.updateValue(i, forKey: name)
        }
        for i in self.sendMessage{
            let name = i.receiver
            dict.updateValue(i, forKey: name)
        }
        sortedDict = dict.sorted(by: {$0.value.timestamp > $1.value.timestamp})
        
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
        array.sort(by:{$0.timestamp < $1.timestamp})
        return array
    }
    func sendMessage(sender:String,receiver:String,content:String){
        let initDate = formatter.string(for: Date())!
        var dict:[String:Any] = ["sender":sender,"receiver":receiver,"content":content,"initTime":initDate]
        db.child("messages").childByAutoId().setValue(dict)
    }
}

