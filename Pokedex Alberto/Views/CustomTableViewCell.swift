import UIKit

class CustomTableViewCell: UITableViewCell {

    private let stackView1 = UIStackView()
    private let stackView2 = UIStackView()
    private let pokemonImage = UIImageView()
    private let nameLabel = UILabel()
    private let attackLabel = UILabel()
    private let defenseLabel = UILabel()
    private let spinner = Spinner()
    var task: URLSessionDataTask?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
        pokemonImage.image = nil
    }

    func configure(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name
        attackLabel.text = "Ataque: \(pokemon.attack)"
        defenseLabel.text = "Defensa: \(pokemon.defense)"
        let urlString = pokemon.imageUrl
        if let url = URL(string: urlString) {
//            spinner.startSpinner()
            task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.pokemonImage.image = UIImage(data: data)
//                    self?.spinner.stopSpinner()
                }
            }
            task?.resume()
        }
    }
}

//MARK: - Methods

extension CustomTableViewCell {

    private func setupViews() {
        configureStackView1()
        configureStackView2()
        configureAttackLabel()
        configureDefenseLabel()
        
    }

    private func configurePokemonImageView() {
        pokemonImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
        pokemonImage.contentMode = .scaleAspectFit
        pokemonImage.layer.cornerRadius = 15
    }

    private func configureNameLabel() {
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameLabel.font = .boldSystemFont(ofSize: 25)
        nameLabel.textAlignment = .center
    }

    private func configureStackView1() {
        configurePokemonImageView()
        configureNameLabel()

        self.addSubview(stackView1)
        stackView1.addArrangedSubview(pokemonImage)
        stackView1.addArrangedSubview(nameLabel)

        stackView1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            stackView1.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            stackView1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            stackView1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5)
        ])

        stackView1.axis = .vertical
        stackView1.distribution = .fill
        stackView1.spacing = 5
    }

    private func configureAttackLabel() {
        attackLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        attackLabel.textAlignment = .left
        attackLabel.textColor = .black
    }

    private func configureDefenseLabel() {
        defenseLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            defenseLabel.heightAnchor.constraint(equalToConstant: 40)
        ])

        defenseLabel.textAlignment = .right
        defenseLabel.textColor = .black
    }

    private func configureStackView2() {
        stackView1.addArrangedSubview(stackView2 )
        stackView2.addArrangedSubview(attackLabel)
        stackView2.addArrangedSubview(defenseLabel)

        stackView2.axis = .horizontal
        stackView2.spacing = 10
        stackView2.distribution = .fillEqually
    }
}
