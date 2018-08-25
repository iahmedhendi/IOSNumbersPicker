//
//  SelectNumerDelegate.swift
//  SafaSms
//
//  Created by Hendi on 8/3/18.
//  Copyright © 2018 Hendi. All rights reserved.
//

import Foundation
import Contacts
protocol SelectNumberDelegate {
    func onNumberSelected(contact: CNContact, phoneNumbers: [SelectablePhone])
}
