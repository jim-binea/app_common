//
//  UIViewController+Alert.swift
//  AnYou
//
//  Created by binea on 2017/3/6.
//  Copyright © 2017年 binea. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func showAlertView(title: String?, message: String? = nil, actions: [UIAlertAction] = [UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil)] ) {
        self.hiddenLoadingIndicator()
        let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        for action in actions {
            alertView.addAction(action)
        }
        self.present(alertView, animated: true, completion: nil)
    }
}
