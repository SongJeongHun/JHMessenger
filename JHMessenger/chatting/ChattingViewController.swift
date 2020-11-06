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
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? UICollectionViewCell, let index = chatcollectionView.indexPath(for: cell) else { return }
        if let vc = segue.destination as? ChatContentViewController{
            vc.currentName = DatabaseManager.shared.dummyList[index.row].name
        }
    }
}
extension ChattingViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DatabaseManager.shared.dummyList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChattingCell", for: indexPath) as? ChattingCell else { return UICollectionViewCell()}
        cell.chatName.text = DatabaseManager.shared.dummyList[indexPath.row].name
        
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
