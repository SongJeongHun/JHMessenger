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
        name.text = currentName
        super.viewDidLoad()
    }
    
}
extension ChatContentViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chattingCell") as? chattingCell else {  return UITableViewCell()}

        cell.friendsName.text = self.currentName
    
        return cell
    }
//    func myCell() -> UITableViewCell{
//        guard let cell = UITableViewCell() as? chattingCell else { return UITableViewCell()}
//        return cell
//        
//    }
    
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
