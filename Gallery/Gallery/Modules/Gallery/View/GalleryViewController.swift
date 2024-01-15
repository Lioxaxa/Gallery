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

    private var label: UILabel
    private var collectionView: UICollectionView
    private var isLoading: Bool
    private var pageNumber: Int
    private var photos: [Photo]
    private var presenter: PhotosPresenter

    public init() {
        self.isLoading = false
        self.pageNumber = 1
        self.photos = []
        self.label = UILabel()
        self.presenter = PhotosPresenter()

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachToView(view: self)
        presenter.fetchImages()
        configureUI()
        setupCollection()
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setupCollection() {
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseID)
        collectionView.backgroundColor = .white.withAlphaComponent(0.15)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - CollectionView

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseID, for: indexPath) as? PhotoCollectionViewCell else {return UICollectionViewCell()}
        let photo = photos[indexPath.item]
        cell.bind(photo: photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailsViewController(currentIndex: indexPath.item, presenter: presenter)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let a = UIScreen.main.bounds.width * 0.25
        return CGSize(width: a, height: a)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        if offsetY > contentHeight - screenHeight {
            if !presenter.isLoading {
                presenter.fetchImages()
            }
        }
    }
}

// MARK: - PhotosPresenterProtocol

extension GalleryViewController: PhotosPresenterProtocol {
    func photosDidUpdate(photos: [Photo]) {
        self.photos = photos
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}
