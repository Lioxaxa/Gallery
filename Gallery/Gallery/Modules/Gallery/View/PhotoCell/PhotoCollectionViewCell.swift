//
//  PhotoCollectionViewCell.swift
//  Gallery
//
//  Created by Pupko, Aleksey on 9.01.24.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "PhotoCollectionViewCell"
    private var imageView: UIImageView
    private let like: UIImageView
    
    public override init(frame: CGRect) {
        self.imageView = UIImageView(frame: .zero)
        self.like = UIImageView(frame: .zero)
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(photo: Photo) {
        if let url = URL(string: photo.thumbImageURL ) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
        configureLike(isLiked: photo.isLiked)
    }
    
    private func configureUI() {
        contentView.addSubview(imageView)
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "placeholder")
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureLike(isLiked: Bool) {
        contentView.addSubview(like)
        like.image = isLiked ? UIImage(systemName: "heart.fill") : UIImage()
        like.tintColor = .white
        like.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20 , height: 20))
            make.left.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
        }
    }
}
