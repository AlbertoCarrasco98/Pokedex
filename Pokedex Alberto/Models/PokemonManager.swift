import UIKit

// Protocolo para delegar la presentación de los datos de Pokemon

protocol PokemonManagerDelegado {
    func showPokemonList(list: [Pokemon])
}

// Manejador de red para obtener datos de Pokemon de la API

struct PokemonManager {

    var delegado: PokemonManagerDelegado?

    func showPokemon() {
        let urlString = "https://pokedex-bb36f.firebaseio.com/pokemon.json"

        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: url) { datos, respuesta, error in
                if error != nil {
                    print("Error al obtener datos de la API: ", error?.localizedDescription as Any)
                }

                if let secureData = datos?.parseData(quitarString: "null,") {
                    if let pokemonList = self.parseJSON(pokemonData: secureData){
                        print("Lista pokemon: ", pokemonList)

                        DispatchQueue.main.async {
                            self.delegado?.showPokemonList(list: pokemonList)
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
            print("Error al decodificar los datos: ", error.localizedDescription)
            return nil
        }
    }
}

extension Data {
    func parseData(quitarString string: String) -> Data {
        let dataAsString = String(decoding: self, as: UTF8.self)
        let cleanedString = dataAsString.replacingOccurrences(of: string, with: "")
        guard let cleanedData = cleanedString.data(using: .utf8) else { return self }
        return cleanedData
    }
}
