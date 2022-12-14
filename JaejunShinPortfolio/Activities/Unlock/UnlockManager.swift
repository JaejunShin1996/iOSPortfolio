//
//  UnlockManager.swift
//  JaejunShinPortfolio
//
//  Created by Jaejun Shin on 12/9/2022.
//

import Combine
import StoreKit

class UnlockManager: NSObject, ObservableObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    enum RequestState {
        case loading
        case loaded(SKProduct)
        case failed(Error?)
        case purchased
        case deferred
    }

    private enum StoreError: Error {
        case invalidIdentifier, missingProduct
    }

    @Published var requestState = RequestState.loading

    var canMakePayments: Bool {
        SKPaymentQueue.canMakePayments()
    }

    private let dataController: DataController
    private let request: SKProductsRequest
    private var loadedProducts = [SKProduct]()

    init(dataController: DataController) {
        self.dataController = dataController

        let productIDs = Set(["com.jaejunshin.JaejunShinPortfolio.unlock"])
        request = SKProductsRequest(productIdentifiers: productIDs)

        super.init()

        SKPaymentQueue.default().add(self)

        guard dataController.fullVersionUnlocked == false else { return }
        request.delegate = self
        request.start()
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }

    // MARK: - SKPaymentTransactionObserver

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        DispatchQueue.main.async { [self] in
            for transaction in transactions {
                switch transaction.transactionState {
                case .purchased, .restored:
                    self.dataController.fullVersionUnlocked = true
                    self.requestState = .purchased
                    queue.finishTransaction(transaction)

                case .failed:
                    if let product = loadedProducts.first {
                        self.requestState = .loaded(product)
                    } else {
                        self.requestState = .failed(transaction.error)
                    }

                    queue.finishTransaction(transaction)

                case .deferred:
                    self.requestState = .deferred

                default:
                    break
                }
            }
        }
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.loadedProducts = response.products

            guard let unlock = self.loadedProducts.first else {
                self.requestState = RequestState.failed(StoreError.missingProduct)
                return
            }

            if response.invalidProductIdentifiers.isEmpty == false {
                print("Invalid product identifers \(response.invalidProductIdentifiers)")
                self.requestState = RequestState.failed(StoreError.invalidIdentifier)
                return
            }

            self.requestState = .loaded(unlock)
        }
    }

    func buy(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
