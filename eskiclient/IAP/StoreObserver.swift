//
//  StoreObserver.swift
//  eskiclient
//
//  Created by Onur Geneş on 8.02.2020.
//  Copyright © 2020 Onur Geneş. All rights reserved.
//

import Foundation
import StoreKit

let iapObserver = StoreObserver()

protocol StoreObserverOutputDelegate: AnyObject {
    func didPurchase()
    func failedPurchase(error: Error)
}

final class StoreObserver: NSObject, SKPaymentTransactionObserver {
    
    weak var delegate: StoreObserverOutputDelegate?
    
    fileprivate var productRequest: SKProductsRequest!
    fileprivate var availableProducts = [SKProduct]()
    fileprivate var invalidProductIdentifiers = [String]()
    
    /// Keeps track of all purchases.
    var purchased = [SKPaymentTransaction]()

    /// Keeps track of all restored purchases.
    var restored = [SKPaymentTransaction]()
    
    var isAuthorizedForPayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    var products: [SKProduct] {
        get {
            return availableProducts
        }
    }
    
    override init() {
        super.init()
        //Other initialization here.
        fetchProducts(matchingIdentifiers: ["com.onurgenes.eskiclient.kucukbagis", "com.onurgenes.eskiclient.buyukbagis"])
    }
    
    //Observe transaction updates.
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            // Call the appropriate custom method for the transaction state.
            case .purchasing: break //showTransactionAsInProgress(transaction, deferred: false)
            case .deferred: break //showTransactionAsInProgress(transaction, deferred: true)
            case .failed: handleFailed(transaction)
            case .purchased: handlePurchased(transaction)
            case .restored: break //restoreTransaction(transaction)
            // For debugging purposes.
            @unknown default: print("Unexpected transaction state \(transaction.transactionState)")
                
            }
        }
    }
    
    func buy(_ product: SKProduct) {
        let payment = SKMutablePayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    fileprivate func handlePurchased(_ transaction: SKPaymentTransaction) {
        purchased.append(transaction)
        // Finish the successful transaction.
        SKPaymentQueue.default().finishTransaction(transaction)
        self.delegate?.didPurchase()
    }
    
    fileprivate func handleFailed(_ transaction: SKPaymentTransaction) {
        // Finish the failed transaction.
        SKPaymentQueue.default().finishTransaction(transaction)
        if let error = transaction.error {
            self.delegate?.failedPurchase(error: error)
        }
    }
    
    fileprivate func handleRestored(_ transaction: SKPaymentTransaction) {
        restored.append(transaction)

        // Finishes the restored transaction.
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    fileprivate func fetchProducts(matchingIdentifiers identifiers: [String]) {
        // Create a set for the product identifiers.
        let productIdentifiers = Set(identifiers)

        // Initialize the product request with the above identifiers.
        productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self

        // Send the request to the App Store.
        productRequest.start()
    }
    
    func restore() {
        if !restored.isEmpty {
            restored.removeAll()
        }
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension StoreObserver: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if !response.products.isEmpty {
            availableProducts = response.products
        }
        
        if !response.invalidProductIdentifiers.isEmpty {
            invalidProductIdentifiers = response.invalidProductIdentifiers
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print(error)
    }
}

extension SKProduct {
/// - returns: The cost of the product formatted in the local currency.
    var regularPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)
    }
}
