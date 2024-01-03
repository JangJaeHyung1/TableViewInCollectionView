//
//  ViewController.swift
//  SideTemplateCVInTV
//
//  Created by jh on 2023/12/29.
//

import UIKit
import SnapKit
import CHTCollectionViewWaterfallLayout

class ViewController: UIViewController {
    var tableView: UITableView!
    var selectedIndexPath: IndexPath? = nil
    let texts = [
        ["Short text\n1",
         "Medium length text that may span multiple lines. Line 2. Line 3.",
         "Very long text that spans multiple lines. \nLine 2.\nLine 3.\nLine 4.\nLine 5.\nLine 6. \nLine 7.","123"
        ],
        [
            "Shortex2\n34324324324 43243243",
            "Medium length text that may  432 432 \n\n\n\n432 432span multiple lines. Line 2. Line 3.",
            "Very long text that spans multiple lines. 2"
        ],[
            "a\na\na\na\na"
        ]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}


extension ViewController {
    private func setUp() {
        setTableView()
        configure()
        setNavi()
        addViews()
        setConstraints()
        bind()
        fetch()
    }
    private func configure() {
        view.backgroundColor = .white
    }
    
    private func setTableView(){
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.cellId)
        tableView.backgroundColor = .red
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func fetch() {
        
    }
    
    private func bind() {
        
    }
    
    private func setNavi() {
    }
    
    private func addViews() {
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.cellId, for: indexPath) as! TableViewCell
        cell.collectionView.tag = indexPath.row
        cell.collectionView.dataSource = self
        cell.configure(data: "tableview cell \(indexPath.row)", texts: texts[indexPath.row])
        cell.backgroundColor = .systemGray6
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if selectedIndexPath == indexPath {
            let sidePadding: CGFloat = 20
            let topInterval: CGFloat = 10
            let middleInterval: CGFloat = 10
            let bottomInterval: CGFloat = 10
            let textPadding: CGFloat = 32 // leading 16 + trailing 16
            let tableViewTitleHeight: CGFloat = 16 * 2 + 20
            var leftCellHeight:CGFloat = tableViewTitleHeight + topInterval
            var rightCellHeight:CGFloat = tableViewTitleHeight + topInterval
            
            let width: CGFloat = ( tableView.bounds.width - middleInterval * 1 - sidePadding) / 2
            let font = UIFont.systemFont(ofSize: 17)
            let size = CGSize(width: floor(width - textPadding), height: CGFloat.greatestFiniteMagnitude)
            let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
            for (idx,text) in texts[indexPath.row].enumerated() {
                let boundingRect = (text as NSString).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: font], context: nil)
                if idx % 2 == 0 {
                    // 텍스트의 실제 크기를 가져오기
                    leftCellHeight += 33 + ceil(boundingRect.height) + bottomInterval
                } else {
                    rightCellHeight += 33 + ceil(boundingRect.height) + bottomInterval
                }
            }
            return max(leftCellHeight,rightCellHeight)
        } else {
            return 52
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath == selectedIndexPath ? nil : indexPath
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return texts[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellId, for: indexPath) as! CollectionViewCell
        cell.configure(with: texts[collectionView.tag][indexPath.row])
        cell.btn.rx.tap
            .subscribe(onNext:{ [weak self] res in
                guard let self else { return }
                print("tap collectionView cell indexPath: \(collectionView.tag), \(indexPath.row)")
            })
            .disposed(by: cell.disposeBag)
        return cell
    }
    
}
