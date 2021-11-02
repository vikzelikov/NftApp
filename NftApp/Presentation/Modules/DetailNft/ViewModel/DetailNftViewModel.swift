//
//  DetailNftViewModel.swift
//  NftApp
//
//  Created by Yegor on 22.09.2021.
//

import Foundation

protocol DetailNftViewModel : BaseViewModel {
    
    var typeDetailNFT: TypeDetailNFT { set get }
    var nftViewModel: Observable<NftViewModel?> { get }
    var expirationTime: Observable<Int> { get }
    
    func viewDidLoad()
    
    func buyNftDidTap(completion: @escaping (Bool) -> Void)
    
}

enum TypeDetailNFT {
    case detail
    case dropShop
    case market
}

class DetailNftViewModelImpl: DetailNftViewModel {
    
    private let dropShopUseCase: DropShopUseCase
    private let marketUserCase: MarketUseCase
    
    var typeDetailNFT: TypeDetailNFT = TypeDetailNFT.detail
    var nftViewModel: Observable<NftViewModel?> = Observable(nil)
    var expirationTime: Observable<Int> = Observable(0)
    var isLoading: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    private var timer: Timer?
    private var expiryTimeInterval: Int? {
        didSet {
            startTimer()
        }
    }
    
    init() {
        dropShopUseCase = DropShopUseCaseImpl()
        marketUserCase = MarketUseCaseImpl()
    }
    
    func viewDidLoad() {
        if let dateExpiration = TimeInterval(nftViewModel.value?.edition.dateExpiration ?? "0") {
            let timeInterval = NSDate().timeIntervalSince1970
            let exp = dateExpiration / 1000
            
            let del = Int((exp - timeInterval))
            expiryTimeInterval = del
            expirationTime.value = del
        }
    }
    
    func buyNftDidTap(completion: @escaping (Bool) -> Void) {
        self.isLoading.value = true
        
        guard let editionId = nftViewModel.value?.edition.id else { return }
        
        self.dropShopUseCase.buyNft(editionId: editionId) { result in
            switch result {
            case .success:
                completion(true)
                
            case .failure(let error):
                let (_, errorStr) = ErrorHelper.validateError(error: error)
                self.errorMessage.value = errorStr
                completion(false)
            }
            
            self.isLoading.value = false
            
        }
    }
    
    private func startTimer() {
        if let interval = expiryTimeInterval {
            expirationTime.value = interval
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onComplete), userInfo: nil, repeats: true)
            
            guard let t = timer else { return }
            RunLoop.current.add(t, forMode: RunLoop.Mode.common)
        }
    }

    @objc func onComplete() {
        guard expirationTime.value >= 1 else {
            timer?.invalidate()
            timer = nil
            return
        }
        
        expirationTime.value -= 1
    }

    
}
    
