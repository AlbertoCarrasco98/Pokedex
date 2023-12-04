import UIKit

class PokemonListViewController: UIViewController {

    // MARK: - UI Components

    private let mainStackView = UIStackView()
    private let tableView = UITableView()
    private let textField = UITextField()

    //    MARK: - Properties
    private let pokemonManager = PokemonAPIService()
    private var pokemonList: [Pokemon] = []
    private var filteredPokemonList: [Pokemon] = []

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonManager.delegate = self
        setupUI()
        pokemonManager.showPokemon()
    }
}

// MARK: - UI Setup
extension PokemonListViewController {

    private func setupUI() {
        title = "Pokedex"
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

    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UITextFieldDelegate

extension PokemonListViewController: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let texto = textField.text, !texto.isEmpty {
            filterPokemons(text: texto)
        } else {
            filteredPokemonList = pokemonList
            reloadTable()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }

    private func filterPokemons(text: String) {
        filteredPokemonList = pokemonList.filter { $0.name.lowercased().contains(text.lowercased()) }
        reloadTable()
    }
}

//MARK: - UITableViewDataSource

extension PokemonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPokemonList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        let pokemon = filteredPokemonList[indexPath.row]
        cell.configure(with: pokemon)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemonDetailVC = PokemonDetailViewController()
        pokemonDetailVC.showPokemon = filteredPokemonList[indexPath.row]
        self.navigationController?.pushViewController(pokemonDetailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

//MARK: - PokemonManagerDelegate

extension PokemonListViewController: PokemonAPIServiceDelegate{
    func showPokemonList(list: [Pokemon]) {
        pokemonList = list
        filteredPokemonList = list
        reloadTable()
    }
}
