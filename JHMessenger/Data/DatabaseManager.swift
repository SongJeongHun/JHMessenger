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
    var dummyList:[Friends] = [Friends(name: "김경모", comment: "ㅎㅇ", content: "ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ"),Friends(name: "염종건", comment: "안녕하세요", content: "ㅇ")]
    var friendsList:[String] = ["김경모","염종건"]
    func addFriends(name:String) -> Bool{
        guard friendsList.contains(name) else {
            dummyList.append(Friends(name: name, comment: "안녕하세요", content: ""))
            friendsList.append(name)
            return true
        }
        return false
    }
}
