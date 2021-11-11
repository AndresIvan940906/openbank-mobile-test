//
//  UIViewController+Extensions.swift
//  Openbank - Mobile Test
//
//  Created by Andrres Marin on 11/11/21.
//

import Foundation
import UIKit
import RxSwift
extension UIViewController {
    
    func presentError(title: String = "Error", okTitle: String = "OK", errorDescription: String, completion: (() -> Void)? = nil) {
          let alertController = UIAlertController(title: title,
                                                  message: errorDescription,
                                                  preferredStyle: .alert)
          alertController.addAction(.init(title: okTitle, style: .default, handler: { (action) in
                    completion?()
                }))
          self.present(alertController, animated: true)
      }
}
