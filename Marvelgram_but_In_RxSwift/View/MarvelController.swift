//
//  ViewController.swift
//  Marvelgram_but_In_RxSwift
//
//  Created by Дмитрий Жучков on 15.05.2021.
//

import UIKit
import RxCocoa
import RxSwift

class MarvelController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    var marvelControllerViewModel: MarvelControllerViewModel!
    @IBOutlet weak var marvelPhotosCollectionView: UICollectionView!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: RxSwift init
        marvelControllerViewModel = MarvelControllerViewModel(marvelService: MarvelBase.base)
        DispatchQueue.global(qos: .background).async {
            self.marvelControllerViewModel.fetchHeroes()
               }
        marvelControllerViewModel.heroes.drive(onNext: {[unowned self] (_) in
                   self.marvelPhotosCollectionView.reloadData()
               }).disposed(by: bag)
        marvelControllerViewModel.isFetching.drive()
                   .disposed(by: bag)
               
        marvelControllerViewModel.error.drive(onNext: { (error) in
            print("Error = ",error as Any)
               }).disposed(by: bag)
        
        // MARK: setupView
        setupView()
            
        
        // MARK: Back button settings
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        // MARK: RefreshControl settings
        marvelPhotosCollectionView.refreshControl = UIRefreshControl()
        marvelPhotosCollectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    
    // MARK: RefreshControl func
    @objc func pullToRefresh() {
        DispatchQueue.global(qos: .background).async {
            self.marvelControllerViewModel.fetchHeroes()
            DispatchQueue.main.async {
            self.marvelPhotosCollectionView.refreshControl?.endRefreshing()
            }
        }
    }
   
   func setupView() {
    
    // MARK: CollectionView init
    marvelPhotosCollectionView.register(HeroesCell.self, forCellWithReuseIdentifier: "HeroesCell")
    marvelPhotosCollectionView.dataSource = self
    marvelPhotosCollectionView.delegate = self
    
    // MARK: CollectionView layout
    marvelPhotosCollectionView.collectionViewLayout = HeroesCell.shared.instagramCloneLayout()
    }
    
    // MARK: CollectionView protocols func
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return marvelControllerViewModel.numberOfHeroes
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroesCell", for: indexPath) as! HeroesCell
        if let viewModel = marvelControllerViewModel.viewModelForHero(at: indexPath.row) {
            cell.configure(viewModel: viewModel)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewModel = marvelControllerViewModel.viewModelForHero(at: indexPath.row) {
            marvelControllerViewModel.navigateToPost(view: self, urlImage: viewModel.posterURL, heroDescription: viewModel.title, heroName: viewModel.name)
        }
    }
    
}

