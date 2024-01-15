//
//  DetailsViewController.swift
//  Gallery
//
//  Created by Pupko, Aleksey on 10.01.24.
//

import UIKit
import SDWebImage

class DetailsViewController: UIViewController{
   
    private var photos: [Photo]
    private var currentIndex: Int
    private var image: UIImageView
    private let closeButton: UIButton
    private let likeButton: UIButton
    private let descriptionLabel: PaddingLabel
    private let loader: UIActivityIndicatorView
    private var presenter: PhotosPresenter

    public init(currentIndex: Int, presenter: PhotosPresenter) {
        self.image = UIImageView()
        self.closeButton = UIButton()
        self.likeButton = UIButton()
        self.descriptionLabel = PaddingLabel()
        self.currentIndex = currentIndex
        self.photos = []
        self.presenter = presenter
        self.loader = UIActivityIndicatorView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photos = presenter.getImages()
        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = .black
        configureImage()
        configureCloseButton()
        configureLikeButton()
        configureDescriptionLabel()
        configureSwipes()
    }
    
    private func configureImage() {
        view.addSubview(image)
        image.contentMode = .scaleAspectFill
        if let url = URL(string:self.photos[currentIndex].largeImageURL ?? "") {
            loader.startAnimating()
            image.sd_setImage(with: url) { [weak self] _,_,_,_  in
                self?.loader.stopAnimating()
                self?.loader.removeFromSuperview()
            }
        }
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.centerX.centerY.equalToSuperview()
        }
        configureLoader()
    }
    
    private func configureLoader() {
        loader.style = UIActivityIndicatorView.Style.large
        loader.color = .white
        image.addSubview(loader)
        loader.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func configureCloseButton() {
        view.addSubview(closeButton)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(onCLoseButtonAction), for: .touchUpInside)
        closeButton.backgroundColor = .black.withAlphaComponent(0.6)
        closeButton.layer.cornerRadius = 20
        closeButton.clipsToBounds = true
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40 , height: 40))
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(48)
        }
    }
    
    private func configureLikeButton() {
        view.addSubview(likeButton)
        photos[currentIndex].isLiked ? likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal) :  likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .white
        likeButton.backgroundColor = .black.withAlphaComponent(0.6)
        likeButton.addTarget(self, action: #selector(onLikeButtonAction), for: .touchUpInside)
        likeButton.layer.cornerRadius = 20
        likeButton.clipsToBounds = true
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40 , height: 40))
            make.centerY.equalTo(closeButton.snp.centerY)
            make.right.equalToSuperview().offset(-12)
        }
    }
    
    private func configureDescriptionLabel() {
        view.addSubview(descriptionLabel)
        descriptionLabel.isHidden = photos[currentIndex].description == nil ? true : false
        descriptionLabel.text = photos[currentIndex].description
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .white
        descriptionLabel.layer.cornerRadius = 8
        descriptionLabel.clipsToBounds = true
        descriptionLabel.backgroundColor = .black.withAlphaComponent(0.6)
        descriptionLabel.edgeInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.lessThanOrEqualToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-44)
        }
    }
    
    private func configureSwipes() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipe(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc
    private func onCLoseButtonAction() {
        self.presenter.view?.photosDidUpdate(photos: photos)
        self.dismiss(animated: true)
    }
    
    @objc
    private func onLikeButtonAction() {
        likeButton.transform = CGAffineTransform.init(scaleX: 1.4, y: 1.4)
        UIView.animate(withDuration: 0.3) {
            self.likeButton.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        }
        likeButtonTapped(id: photos[currentIndex].id)
    }
    
    private func likeButtonTapped(id: String) {
        presenter.changeLike(id: id, index: currentIndex)
        photos = presenter.getImages()
        configureUI()
    }

    @objc func swipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
            
        case .left: showNextImage()
        case .right: showPreviousImage()
        case .down: self.dismiss(animated: true)

        default:
            break
        }
    }
    
    private func showNextImage() {
        if currentIndex < photos.count - 1 {
            currentIndex += 1
            configureUI()
        }
    }
    
    private func showPreviousImage() {
        if currentIndex > 0 {
            currentIndex -= 1
            configureUI()
        }
    }
}

