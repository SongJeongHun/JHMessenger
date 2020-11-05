//
//  ViewController.swift
//  JHMessenger
//
//  Created by 송정훈 on 2020/11/05.
//

import UIKit

class FriendsViewcontoller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}
extension FriendsViewcontoller:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsCell", for: indexPath) as? FriendsCell else{
            return UICollectionViewCell()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FriendsHeaderCell", for: indexPath) as? FriendsHeaderCell else {
                return UICollectionReusableView()
                
            }
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
}
extension FriendsViewcontoller:UICollectionViewDelegate{
    
}
extension FriendsViewcontoller:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width
        let height: CGFloat = 40
        
        return CGSize(width: width, height: height)
    }
    
}
class FriendsCell:UICollectionViewCell{
    @IBOutlet weak var friendsName:UILabel!
    @IBOutlet weak var friendsComment:UILabel!
    @IBOutlet weak var friendsThumbnail:UIImageView!
}
class FriendsHeaderCell:UICollectionReusableView{
    @IBOutlet weak var myThumbnail:UIImageView!
    @IBOutlet weak var myName:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
struct Friends:Codable{
    let name:String
    let comment:String
    
    
    
}
