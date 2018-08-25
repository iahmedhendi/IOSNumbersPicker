//
//  ContactSelectionCell.swift
//  SafaSms
//
//  Created by Hendi on 8/1/18.
//  Copyright © 2018 Hendi. All rights reserved.
//

import UIKit
import SnapKit
class ContactSelectionCell: TableBaseCell<SelectableContact> {

    let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "check_circle_outline").maskWithColor(color: UIColor(named: "primary")!)
        return imageView
    }()
    let nameLabel: UILabel = { return UILabel() }()

    override var item: SelectableContact! {
        didSet {
            nameLabel.text = item.contact.givenName
            let selected = item.phoneNumbers.filter { $0.selected }.count > 0
           checkImageView.image = selected ? #imageLiteral(resourceName: "check_circle_black").maskWithColor(color: UIColor(named: "primary")!): #imageLiteral(resourceName: "check_circle_outline").maskWithColor(color: UIColor(named: "primary")!)
        }
    }

    override func setupViews() {

        selectionStyle = .none
        addSubview(checkImageView)
        addSubview(nameLabel)
        checkImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self.snp.leading).offset(10)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(checkImageView.snp.trailing).offset(10)
            make.centerY.equalTo(checkImageView.snp.centerY)
        }
 
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code


    }



}
import Contacts
class ContactSelectionCellSmall: TableBaseCell<SelectablePhone> {

    let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "check_circle_outline").maskWithColor(color: UIColor(named: "primary")!)
        return imageView

    }()
    let nameLabel: UILabel = { return UILabel() }()


    override var item: SelectablePhone! {
        didSet {
            nameLabel.text = item.number
            let selected = item.selected
            checkImageView.image = selected ? #imageLiteral(resourceName: "check_circle_black").maskWithColor(color: UIColor(named: "primary")!): #imageLiteral(resourceName: "check_circle_outline").maskWithColor(color: UIColor(named: "primary")!)
            //  checkImageView.image = selected ? #imageLiteral(resourceName: "check_circle_black"): #imageLiteral(resourceName: "check_circle_outline")
        }
    }



    override func setupViews() {

        selectionStyle = .none
        addSubview(checkImageView)
        addSubview(nameLabel)
        checkImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self.snp.leading).offset(10)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(checkImageView.snp.trailing).offset(10)
            make.centerY.equalTo(checkImageView.snp.centerY)
        }


    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code


    }



}
