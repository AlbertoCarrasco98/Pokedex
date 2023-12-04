import Foundation

protocol PokemonAPIServiceDelegate: AnyObject {
    func showPokemonList(list: [Pokemon])
}

class PokemonAPIService {

    weak var delegate: PokemonAPIServiceDelegate?

    func showPokemon() {
        let urlString = "https://pokedex-bb36f.firebaseio.com/pokemon.json"

        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: url) { data, _, error in
                if error != nil {
                    print("Error getting data from API: ", error?.localizedDescription as Any)
                }

                if let secureData = data?.parseData(removeString: "null,") {
                    if let pokemonList = self.parseJSON(pokemonData: secureData){
                        print("Pokemon list: ", pokemonList)

                        DispatchQueue.main.async {
                            self.delegate?.showPokemonList(list: pokemonList)
                        }
                    }
                }
            }
            task.resume()
        }
    }

    private func parseJSON(pokemonData: Data) -> [Pokemon]? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode([Pokemon].self, from: pokemonData)
            return decodedData
        } catch {
            print("Error decodig data: ", error.localizedDescription)
            return nil
        }
    }
}
