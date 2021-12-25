//
//  UIApplication.swift
//  SwiftSearch
//
//  Created by Godwin A on 5/9/21.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
