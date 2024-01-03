//
//  TableViewCell.swift
//  SideTemplateCVInTV
//
//  Created by jh on 2023/12/29.
//


import UIKit
import SnapKit
import CHTCollectionViewWaterfallLayout
import RxSwift
import RxCocoa

class TableViewCell: UITableViewCell {
    static let cellId = "TableViewCell"
    var texts: [String] = []
    
    private let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let title: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.isUserInteractionEnabled = true
        return lbl
    }()
    
    private let btn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.adjustsImageWhenHighlighted = false
        btn.backgroundColor = .brown
        btn.layer.opacity = 0.5
        btn.isHidden = true
        return btn
    }()
    
    var collectionView: UICollectionView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setCollectionView()
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setCollectionView(){
        let flowLayout = CHTCollectionViewWaterfallLayout()
        flowLayout.minimumColumnSpacing = 10.0
        flowLayout.minimumInteritemSpacing = 10.0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.cellId)
        collectionView.backgroundColor = .blue
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    private func setupView() {
        contentView.addSubview(cellView)
        cellView.addSubview(title)
        cellView.addSubview(btn)
        cellView.addSubview(collectionView)
        setConstraints()
    }
    
    private func setConstraints() {
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(20)
        }
        btn.snp.makeConstraints { make in
            make.leading.equalTo(title).offset(-16)
            make.trailing.equalTo(title).offset(16)
            make.top.equalTo(title).offset(-16)
            make.bottom.equalTo(title).offset(16)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(title.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(data: String, texts: [String]) {
        title.text = "Title \(data)"
        self.texts = texts
        self.collectionView.reloadData()
    }
}



extension TableViewCell: UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 콜렉션 뷰 셀의 크기를 동적으로 계산
        
        let interval: CGFloat = 10
        let sidePadding: CGFloat = 20 // left 10 + right 10
        let textPadding: CGFloat = 32 // leading 16 + right 16
        
        let width: CGFloat = ( self.bounds.width - interval * 1  - sidePadding) / 2
        let text = texts[indexPath.row]
        let font = UIFont.systemFont(ofSize: 17)
        
        let size = CGSize(width: floor(width - textPadding), height: CGFloat.greatestFiniteMagnitude)

        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        
        // 텍스트의 실제 크기를 가져오기
        let boundingRect = (text as NSString).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: font], context: nil)
        return CGSize(width: width, height: 32 + 1 + ceil(boundingRect.height))
    }
    
}
