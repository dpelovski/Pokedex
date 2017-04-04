//
//  ViewController.swift
//  Pokedex
//
//  Created by Damian Pelovski on 3/20/17.
//  Copyright © 2017 Damian Pelovski. All rights reserved.
//

import UIKit
//import AVFoundation in order to use music player
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = .done
        
        parsePokemonCSV()
        
        
        //initAudio()
        
    }
    
    func initAudio() {
        
        //get the path of the audio file
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            //use do and try as AVAudioPlayer throws
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string:path)!)
            musicPlayer.prepareToPlay()
            //number of loops -1 means endless ciclying of the music file
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        
    }

    func parsePokemonCSV() {
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            //CSV class is a custom parser
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            //for every row that is parsed create a new Pokemon object and append it to our array
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeId)
                
                self.pokemon.append(poke)
                
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        
    }
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            
            let poke: Pokemon!
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
                
            } else {
                poke = pokemon[indexPath.row]
            }
            
            cell.configureCell(poke)
            
            return cell
            
            
        } else {
            return UICollectionViewCell()
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemon.count
        }
        
        return pokemon.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //we return 105 by 105, because we have these constrains in the storyboard
        return CGSize(width: 105, height: 105)
    }

    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        //make the button look grayed out when not playing
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            
            let lower = searchText.lowercased()
            
            filteredPokemon = pokemon.filter({ (poke) -> Bool in
                return poke.name.range(of: lower) != nil
            })
            
            collection.reloadData()
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
            
        }
    }

}

