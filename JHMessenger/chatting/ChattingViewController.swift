//
//  ChattingViewController.swift
//  JHMessenger
//
//  Created by 송정훈 on 2020/11/05.
//

import UIKit

class ChattingViewController: UIViewController {
    @IBOutlet weak var chatcollectionView:UICollectionView!
    override func viewDidLoad() {
        DatabaseManager.shared.initializeMessages()
        DatabaseManager.shared.getMessage()
        super.viewDidLoad()
    }
    //채팅방 segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? UICollectionViewCell, let index = chatcollectionView.indexPath(for: cell) else { return }
        if let vc = segue.destination as? ChatContentViewController{
            vc.currentName = DatabaseManager.shared.receiveMessage[index.row].sender
        }
    }
}
extension ChattingViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //수정 필요
        //같은 사람 한테 여러번 오면 그만큼 생김 -> 하나로 묶기
        return DatabaseManager.shared.receiveMessage.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChattingCell", for: indexPath) as? ChattingCell else { return UICollectionViewCell()}
        
        //수정 필요
        //같은 사람 한테 여러번 오면 그만큼 생김 -> 하나로 묶기
        cell.chatName.text = DatabaseManager.shared.receiveMessage[indexPath.row].sender
        cell.chatContent.text = DatabaseManager.shared.receiveMessage[indexPath.row].content
     
        
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
