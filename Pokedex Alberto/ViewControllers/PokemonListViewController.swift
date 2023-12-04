import UIKit

class PokemonListViewController: UIViewController {

    // MARK: - UI Components

    private let mainStackView = UIStackView()
    private let tableView = UITableView()
    private let textField = UITextField()

    //    MARK: - Properties
    private var pokemonManager = PokemonManager()
    private var pokemons: [Pokemon] = []
    private var pokemonSeleccionado: Pokemon?
    private var pokemonFiltrados: [Pokemon] = []

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pokemonManager.delegado = self
        setupUI()
        // Ejecutar el metodo para buscar la lista de pokemon en la API
        pokemonManager.showPokemon()
    }
}

// MARK: - UI Setup
extension PokemonListViewController {

    private func setupUI() {
        self.title = "Pokedex"
        configureMainStackView()
        configureTextField()
        configureTableView()
    }

    private func configureMainStackView() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(textField)
        mainStackView.addArrangedSubview(tableView)

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        mainStackView.axis = .vertical
        mainStackView.spacing = 5
    }

    private func configureTextField() {
        textField.delegate = self
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        textField.placeholder = "🔍 Busca aquí tu pokemon"
        textField.textAlignment = .center
        textField.font = UIFont.italicSystemFont(ofSize: 18)
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.backgroundColor = .systemGray6
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .search
    }

    private func configureTableView() {
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITextFieldDelegate

extension PokemonListViewController: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let texto = textField.text, !texto.isEmpty {
            filtrarPokemons(texto: texto)
        } else {
            pokemonFiltrados = pokemons
            tableView.reloadData()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }

    private func filtrarPokemons(texto: String) {
        pokemonFiltrados = pokemons.filter { $0.name.lowercased().contains(texto.lowercased()) }
        tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource

extension PokemonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonFiltrados.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }

        cell.nameLabel.text = pokemonFiltrados[indexPath.row].name
        cell.attackLabel.text = "Ataque: \(pokemonFiltrados[indexPath.row].attack)"
        cell.defenseLabel.text = "Defensa: \(pokemonFiltrados[indexPath.row].defense)"

        let urlString = pokemonFiltrados[indexPath.row].imageUrl
        if let url = URL(string: urlString) {
            cell.task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    if let currentCell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell {
                        currentCell.pokemonImage.image = UIImage(data: data)
                    }
                }
            }
            cell.task?.resume()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemonDetailVC = PokemonDetailViewController()
        pokemonDetailVC.showPokemon = pokemonFiltrados[indexPath.row]
        self.navigationController?.pushViewController(pokemonDetailVC, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension PokemonListViewController: UITableViewDelegate {
}

//MARK: - PokemonManagerDelegate

extension PokemonListViewController: PokemonManagerDelegado {
    func showPokemonList(list: [Pokemon]) {
        pokemons = list

        // Este metodo hace que la carga se realice en el hilo principal
        DispatchQueue.main.async {
            self.pokemonFiltrados = self.pokemons
            self.tableView.reloadData()
        }
    }
}

