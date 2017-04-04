//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Damian Pelovski on 3/27/17.
//  Copyright © 2017 Damian Pelovski. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var mainImg: UIImageView!
    
    @IBOutlet weak var descriptionLbl: UILabel!

    @IBOutlet weak var typeLbl: UILabel!
    
    @IBOutlet weak var defenseLbl: UILabel!
    
    @IBOutlet weak var hightLbl: UILabel!
    
    @IBOutlet weak var pokedexLbl: UILabel!
    
    @IBOutlet weak var weightLbl: UILabel!
    
    @IBOutlet weak var attackLbl: UILabel!
    
    @IBOutlet weak var currentEvoImg: UIImageView!
    
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    @IBOutlet weak var evoLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameLbl.text = pokemon.name.capitalized
        
        let image = UIImage(named: "\(pokemon.pokedexId)")
        
        mainImg.image = image
        currentEvoImg.image = image
        pokedexLbl.text = String(pokemon.pokedexId)
        
        
        // async operation
        self.pokemon.downloadPokemonDetails {
            
            self.updateUI()
            
        }
        
    }
    
    func updateUI() {
        
        self.attackLbl.text = pokemon.attack
        self.defenseLbl.text = pokemon.defense
        self.hightLbl.text = pokemon.height
        self.weightLbl.text = pokemon.weight
        self.typeLbl.text = pokemon.type
        self.descriptionLbl.text = pokemon.description
        
        if pokemon.nextEvolutionId == "" {
            evoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
        } else {
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            let str = "Next evolution \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLevel)"
            evoLbl.text = str
        }
        
        
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
