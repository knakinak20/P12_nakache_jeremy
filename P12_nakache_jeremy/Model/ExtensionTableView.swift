//
//  extensionTableView.swift
//  P12_nakache_jeremy
//
//  Created by user on 01/02/2022.
//

import UIKit

extension UITableView {
    func scrollToBottom(animated: Bool) {
        let y = contentSize.height - frame.size.height
        if y < 0 { return }
        setContentOffset(CGPoint(x: 0, y: y), animated: animated)
    }
}
