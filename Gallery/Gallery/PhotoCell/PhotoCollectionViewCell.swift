//
//  PhotoCollectionViewCell.swift
//  Gallery
//
//  Created by Pupko, Aleksey on 9.01.24.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
//    private var imageView: UIImageView
    var imageView: UIImageView

    static let reuseID = "PhotoCollectionViewCell"
    
    public override init(frame: CGRect) {
        self.imageView = UIImageView(frame: .zero)
        super.init(frame: frame)
        comfigureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func comfigureUI() {
        super.awakeFromNib()
        
         self.contentView.addSubview(imageView)

         imageView.layer.cornerRadius = 6
         imageView.layer.masksToBounds = true
         imageView.contentMode = .scaleAspectFill

         imageView.image = UIImage(named: "placeholder")
         imageView.snp.makeConstraints { make in
           make.edges.equalToSuperview()
         }
    }
}
