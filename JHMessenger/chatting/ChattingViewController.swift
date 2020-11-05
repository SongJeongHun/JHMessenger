//
//  ChattingViewController.swift
//  JHMessenger
//
//  Created by 송정훈 on 2020/11/05.
//

import UIKit

class ChattingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

 
    }

}
extension ChattingViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChattingCell", for: indexPath) as? ChattingCell else { return UICollectionViewCell()}
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
