//
//  AddFriendsViewController.swift
//  JHMessenger
//
//  Created by 송정훈 on 2020/11/06.
//

import UIKit
class AddFriendsViewController:UIViewController{
    var dict:[String:Message] = [:]
    @IBOutlet weak var friendsName:UITextField!
    @IBOutlet weak var friendsID:UITextField!
    @IBAction func cancel(_ sender:Any){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addFriends(_ sender:Any){
        guard !(friendsName.text == "") else {
            let alert = UIAlertController(title:"알림",message: "이름을 입력해 주세요!", preferredStyle: .alert)
            let okAction = UIAlertAction(title:"확인",style:.default)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        let name = friendsName.text!
        guard DatabaseManager.shared.addFriends(name:name) else {
            let alert = UIAlertController(title:"알림",message: "이미 친구 입니다!", preferredStyle: .alert)
            let okAction = UIAlertAction(title:"확인",style:.default)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        let alert = UIAlertController(title:"알림",message: "추가 완료!", preferredStyle: .alert)
        let okAction = UIAlertAction(title:"확인",style:.default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        NotificationCenter.default.post(name: AddFriendsViewController.addFinished, object: nil)
    }
    override func viewDidLoad() {
        DatabaseManager.shared.initializeMessages()
        DatabaseManager.shared.getMessage()
        self.dict = DatabaseManager.shared.mergeSender()
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue 이어주기
//        guard let cell = sender as? UICollectionViewCell, let index = chatcollectionView.indexPath(for: cell) else { return }
//        if let vc = segue.destination as? ChatContentViewController{
//            let name = Array(self.dict.keys)[index.row]
//            vc.currentName = name
//            vc.currentChat = DatabaseManager.shared.mergeContentByName(name)
//        }
    }
    
}
extension AddFriendsViewController{
    
    //Notification 정의
    static let addFinished = Notification.Name(rawValue: "addFinished")
}
