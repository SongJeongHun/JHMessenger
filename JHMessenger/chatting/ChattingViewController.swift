//
//  ChattingViewController.swift
//  JHMessenger
//
//  Created by 송정훈 on 2020/11/05.
//

import UIKit

class ChattingViewController: UIViewController {
    @IBOutlet weak var chatcollectionView:UICollectionView!
    var token:NSObjectProtocol?
    deinit {
        if let token = token{
            NotificationCenter.default.removeObserver(token)
        }
    }
    override func viewDidLoad() {
        token = NotificationCenter.default.addObserver(forName: ChatContentViewController.sendFinised, object: nil, queue: OperationQueue.main, using: {noti in
            DatabaseManager.shared.getMessage(self.chatcollectionView)
            self.chatcollectionView.reloadData()
        })
        DatabaseManager.shared.initializeMessages()
//        DatabaseManager.shared.getMessage(self.chatcollectionView)
//        self.dict = DatabaseManager.shared.mergeSender()
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        DatabaseManager.shared.getMessage(self.chatcollectionView)
        print(DatabaseManager.shared.sortedDict)
        super.viewWillAppear(animated)
    }
    //채팅방 segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? UICollectionViewCell, let index = chatcollectionView.indexPath(for: cell) else { return }
        if let vc = segue.destination as? ChatContentViewController{
            let name = DatabaseManager.shared.sortedDict[index.row]
            vc.currentName = name.0
            DatabaseManager.shared.getMessage(vc.tableView)
            vc.currentChat = DatabaseManager.shared.mergeContentByName(name.0)
            }
        }
    }
    

extension ChattingViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //수정 필요
        //같은 사람 한테 여러번 오면 그만큼 생김 -> 하나로 묶기
        return DatabaseManager.shared.sortedDict.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChattingCell", for: indexPath) as? ChattingCell else { return UICollectionViewCell()}
//        let dictioncary = self.dict[(indexPath as NSIndexPath).row]

        cell.chatName.text = DatabaseManager.shared.sortedDict[indexPath.row].0
        cell.chatContent.text = DatabaseManager.shared.sortedDict[indexPath.row].1.content
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
