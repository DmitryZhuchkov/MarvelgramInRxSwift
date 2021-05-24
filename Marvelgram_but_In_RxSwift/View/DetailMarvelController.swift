//
//  DetailMarvelController.swift
//  Marvelgram_but_In_RxSwift
//
//  Created by Дмитрий Жучков on 15.05.2021.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift
class DetailMarvelController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var randData: [Int] = []
    var anotherCollectionView: UICollectionView!
    var marvelControllerViewModel: MarvelControllerViewModel!
    let bag = DisposeBag()
    var imageURL: URL?
    var descriptionHero: String?
    var nameHero:String?
    
    
    // MARK: Outlets init
    var imgView: UIImageView = {
           let image = UIImageView()
            image.translatesAutoresizingMaskIntoConstraints = false
            return image
        }()
    
    var heroDescrp: UILabel = {
           let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        text.numberOfLines = 40
        text.textColor = .white
            return text
        }()
    
    var exploreMore: UILabel = {
        let text = UILabel()
        text.numberOfLines = 1
        text.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = .white
            return text
        }()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    override func viewDidLoad() {
        // MARK: CollectionView layout init
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
         layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        
        // MARK: CollectionView init
        anotherCollectionView = UICollectionView(frame: contentView.frame, collectionViewLayout: layout)
        anotherCollectionView.showsHorizontalScrollIndicator = false
        anotherCollectionView.dataSource = self
        anotherCollectionView.delegate = self
        anotherCollectionView.register(HeroesCell.self, forCellWithReuseIdentifier: "HeroesCell")
        
        // MARK: RxSwift net layer init
        marvelControllerViewModel = MarvelControllerViewModel(marvelService: MarvelBase.base)
        DispatchQueue.global(qos: .background).async {
            self.marvelControllerViewModel.fetchHeroes()
               }
        marvelControllerViewModel.heroes.drive(onNext: {[unowned self] (_) in
            anotherCollectionView.reloadData()
               }).disposed(by: bag)
        marvelControllerViewModel.isFetching.drive()
                   .disposed(by: bag)

        marvelControllerViewModel.error.drive(onNext: { (error) in
            print("Error = ",error as Any)
               }).disposed(by: bag)
        
    // MARK: UINavigation bar title
        self.title = nameHero
        
    setupScrollView()
    setupView()
    }
    // MARK: Outlets constraints
    func setupView(){
        anotherCollectionView.backgroundColor = .none
        view.addSubview(anotherCollectionView)
        anotherCollectionView.translatesAutoresizingMaskIntoConstraints = false
        anotherCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        anotherCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        anotherCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        anotherCollectionView.heightAnchor.constraint(equalTo: anotherCollectionView.widthAnchor, multiplier: 1/2).isActive = true
        
        view.addSubview(exploreMore)
        exploreMore.bottomAnchor.constraint(equalTo: anotherCollectionView.topAnchor,constant: 8).isActive = true
        exploreMore.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 8).isActive = true
        exploreMore.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        exploreMore.text = "Explore more"
        
        view.addSubview(heroDescrp)
        heroDescrp.bottomAnchor.constraint(equalTo: exploreMore.topAnchor).isActive = true
        heroDescrp.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 8).isActive = true
        heroDescrp.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -8).isActive = true
        heroDescrp.text = descriptionHero
        
        view.addSubview(imgView)
        imgView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imgView.bottomAnchor.constraint(equalTo: heroDescrp.topAnchor,constant: -8).isActive = true
        imgView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imgView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        imgView.heightAnchor.constraint(equalTo: (imgView.widthAnchor), multiplier: 1).isActive = true
        imgView.kf.setImage(with: imageURL)
        
    }
    
    // MARK: ScrollView constraints
    func setupScrollView(){
           scrollView.translatesAutoresizingMaskIntoConstraints = false
           contentView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(scrollView)
           scrollView.addSubview(contentView)
           
           scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
           scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
           scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
           
           contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
           contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
           contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
           contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
       }
    
    // MARK: Collection view protocol func
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (marvelControllerViewModel.numberOfHeroes / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroesCell", for: indexPath) as! HeroesCell
        if randData == [] {
            for _ in (0...(marvelControllerViewModel.numberOfHeroes / 5)) {
              let k = randomSequenceGenerator(min: 0, max: marvelControllerViewModel.numberOfHeroes)
                randData.append(k())
            }
        }
        if let viewModel = marvelControllerViewModel.viewModelForHero(at: randData[indexPath.row]) {
            cell.configure(viewModel: viewModel)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewModel = marvelControllerViewModel.viewModelForHero(at: randData[indexPath.row]) {
            marvelControllerViewModel.navigateToPost(view: self, urlImage: viewModel.posterURL, heroDescription: viewModel.title, heroName: viewModel.name)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/3, height: view.frame.width/3)
    }
    
    // MARK: Random numbers generator
    func randomSequenceGenerator(min: Int, max: Int) -> () -> Int {
        var numbers: [Int] = []
        return {
            if numbers.isEmpty {
                numbers = Array(min ... max)
            }

            let index = Int(arc4random_uniform(UInt32(numbers.count)))
            return numbers.remove(at: index)
        }
    }
}
