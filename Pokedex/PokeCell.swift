//
//  PokeCell.swift
//  Pokedex
//
//  Created by Damian Pelovski on 3/20/17.
//  Copyright © 2017 Damian Pelovski. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    //function used in our view controller
    func configureCell(_ pokemon: Pokemon) {
        
        self.pokemon = pokemon
        
        nameLbl.text = self.pokemon.name.capitalized
        thumbImg.image = UIImage(named: String(self.pokemon.pokedexId))
        
    }
    
    
    
}
