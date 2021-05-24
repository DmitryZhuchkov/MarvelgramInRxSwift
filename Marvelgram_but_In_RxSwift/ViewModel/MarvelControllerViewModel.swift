//
//  MarvelControllerViewModel.swift
//  Marvelgram_but_In_RxSwift
//
//  Created by Дмитрий Жучков on 15.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

class MarvelControllerViewModel {
   
    private let marvelService: MarvelBase
     private let disposeBag = DisposeBag()
    init(marvelService: MarvelBase) {
         self.marvelService = marvelService

     }
     
     private let _heroes = BehaviorRelay<[MarvelJSON]>(value: [])
     private let _isFetching = BehaviorRelay<Bool>(value: false)
     private let _error = BehaviorRelay<String?>(value: nil)
   
     var isFetching: Driver<Bool> {
         return _isFetching.asDriver()
     }
     
     var heroes: Driver<[MarvelJSON]> {
         return _heroes.asDriver()
     }
     
     var error: Driver<String?> {
         return _error.asDriver()
     }
     
     var hasError: Bool {
         return _error.value != nil
     }
     
     var numberOfHeroes: Int {
         return _heroes.value.count
     }
     
     func viewModelForHero(at index: Int) -> MarvelViewViewModel? {
         guard index < _heroes.value.count else {
             return nil
         }
         return MarvelViewViewModel(marvel: _heroes.value[index])
     }
    
    // MARK: Post Navigation func
    func navigateToPost(view: UIViewController, urlImage: URL, heroDescription: String, heroName: String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        guard let vc = storyBoard.instantiateViewController(identifier: "MarvelDetail") as? DetailMarvelController else { return }
        
        //next post settings
        vc.imageURL = urlImage
        vc.descriptionHero = heroDescription
        vc.nameHero = heroName
        
        //back button settings
        let backItem = UIBarButtonItem()
        backItem.title = ""
        vc.navigationItem.backBarButtonItem = backItem
        view.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Fetch heroes from internet
     func fetchHeroes() {
         self._heroes.accept([])
         self._isFetching.accept(true)
         self._error.accept(nil)
         
        MarvelBase.base.fetchHeroes(params: nil, successHandler: { [weak self] (response) in
             self?._isFetching.accept(false)
            self?._heroes.accept(response)
             
         }) { [weak self] (error) in
             self?._isFetching.accept(false)
             self?._error.accept(error.localizedDescription)
         }
     }
     
}
