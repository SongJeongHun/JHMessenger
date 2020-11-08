//
//  ChattingViewController.swift
//  JHMessenger
//
//  Created by 송정훈 on 2020/11/05.
//

import UIKit

class ChattingViewController: UIViewController {
    @IBOutlet weak var chatcollectionView:UICollectionView!
    var dict:[String:Message]!
    override func viewDidLoad() {
        DatabaseManager.shared.initializeMessages()
        DatabaseManager.shared.getMessage()
        self.dict = DatabaseManager.shared.mergeSender()
        super.viewDidLoad()
    }
    //채팅방 segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? UICollectionViewCell, let index = chatcollectionView.indexPath(for: cell) else { return }
        if let vc = segue.destination as? ChatContentViewController{
            let name = Array(self.dict.keys)[index.row]
            vc.currentName = name
            vc.currentChat = DatabaseManager.shared.mergeContentByName(name)
        }
    }
}
extension ChattingViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //수정 필요
        //같은 사람 한테 여러번 오면 그만큼 생김 -> 하나로 묶기
        return self.dict.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChattingCell", for: indexPath) as? ChattingCell else { return UICollectionViewCell()}
//        let dictioncary = self.dict[(indexPath as NSIndexPath).row]
        cell.chatName.text = Array(self.dict.keys)[indexPath.row]
        cell.chatContent.text = Array(self.dict.values)[indexPath.row].content
        return cell
    }
}
extension ChattingViewController:UICollectionViewDelegate{
    
}
extension ChattingViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width:CGFloat = collectionView.bounds.width
        let height:CGFloat = 40
        return CGSize(width: width, height: height)
    }
}
class ChattingCell:UICollectionViewCell{
    @IBOutlet weak var chatThumbnail:UIImageView!
    @IBOutlet weak var chatName:UILabel!
    @IBOutlet weak var chatContent:UILabel!
}
