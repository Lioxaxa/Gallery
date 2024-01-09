//
//  ViewController.swift
//  Gallery
//
//  Created by Pupko, Aleksey on 8.01.24.
//

import UIKit
import SDWebImage
import SnapKit

class GalleryViewController: UIViewController{
//
//    var label: UILabel
//    var collectionView: UICollectionView
    var label: UILabel
    var collectionView: UICollectionView
    
    private var photos: [PhotoResult]

    public init() {
        self.photos = []
        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        self.label = UILabel()
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemYellow
        
        label.text = "LABEL"
//
        setupCollection()
        fetchPhotos()
    }
    
    private func setupCollection() {
        
//        var nib = UINib(nibName: "PhotoCollectionViewCell", bundle:nil)
//        collectionView.register(nib, forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseID)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        view.addSubview(label)
        view.addSubview(collectionView)
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func fetchPhotos() {
        NetworkManager().loadRandomPhotos { [self] result in
            self.photos = result
            DispatchQueue.main.async {
                self.label.text = "\(self.photos.count)"
                print(photos.first?.id)
                self.collectionView.reloadData()
            }
        }
    }
    
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseID, for: indexPath) as? PhotoCollectionViewCell else {return UICollectionViewCell()}
        let photo = photos[indexPath.item]
        
        if let url = URL(string: photo.urls.full ?? "") {
            cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named:  "placeholder"))
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let a = UIScreen.main.bounds.width * 0.4

        return CGSize(width: a, height: a)
    }
    
    
}
