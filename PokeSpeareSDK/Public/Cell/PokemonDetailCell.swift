//
//  PokemonDetailCell.swift
//  PokeSpeareSDK
//
//  Created by Vinod Shabadi on 17/01/21.
//  Copyright © 2021 True Layer. All rights reserved.
//

import UIKit

class PokemonDetailCell: UITableViewCell {
    @IBOutlet weak var spriteView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configureCell(_ name: String?,
                       _ description: String?,
                       _ spriteImage: UIImage?) {
        nameLabel.text = name
        descriptionLabel.text = description
        spriteView.image = spriteImage
    }
}
