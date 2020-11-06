//
//  ViewController.swift
//  JHMessenger
//
//  Created by 송정훈 on 2020/11/05.
//

import UIKit
class FriendsViewcontoller: UIViewController {
    @IBOutlet weak var collectionView:UICollectionView!
    var token:NSObjectProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        //Notification 추가
        token = NotificationCenter.default.addObserver(forName: AddFriendsViewController.addFinished, object: nil, queue: OperationQueue.main) { (noti) in
            self.collectionView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? UICollectionViewCell,let index = collectionView.indexPath(for: cell) else {return}
        if let vc = segue.destination as? FriendsCellForViewController{
            vc.friend = DatabaseManager.shared.dummyList[index.row]
        }
    }
}
extension FriendsViewcontoller:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DatabaseManager.shared.dummyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsCell", for: indexPath) as? FriendsCell else{
            return UICollectionViewCell()
        }
        //        cell.layer.borderWidth = 0.2
        //        cell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        cell.friendsName.text = DatabaseManager.shared.dummyList[indexPath.row].name
        cell.friendsComment.text = DatabaseManager.shared.dummyList[indexPath.row].comment
        
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
class FriendsCellForViewController:UIViewController{
    var friend:Friends!
    @IBOutlet weak var friendsName:UILabel!
    @IBOutlet weak var friendsComment:UILabel!
    @IBOutlet weak var friendsThumbnail:UIImageView!
    override func viewDidLoad() {
        friendsName.text = friend.name
        friendsComment.text = friend.comment
        super.viewDidLoad()
    }
}
class FriendsHeaderCell:UICollectionReusableView{
    @IBOutlet weak var myThumbnail:UIImageView!
    @IBOutlet weak var myName:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
struct Friends:Codable,Equatable{
    let name:String
    let comment:String
    let content:String
}

