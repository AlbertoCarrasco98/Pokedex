import UIKit

class PokemonDetailViewController: UIViewController {

// MARK: - Properties

    var showPokemon: Pokemon?

// MARK: - Views

    private let mainStackView = UIStackView()
    private let imagePokemon = UIImageView()
    private let textPokemon = UITextView()
    private let typeLabel = UILabel()
    private let labelStackView = UIStackView()
    private let attackLabel = UILabel()
    private let defenseLabel = UILabel()

    let spinner = Spinner()

// MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .white
        setupSpinner()
    }
}

// MARK: - UI Configuration

private extension PokemonDetailViewController {

    private func setupUI() {
        configureMainStackView()
        configurePokemonImageView()
        configureTextPokemon()
        configureTypeLabel()
        configureLabelStackView()
        configureLabelAttack()
        configureLabelDefense()
        setupSpinner()
    }

    private func configureMainStackView() {
        view.addSubview(mainStackView)
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        mainStackView.spacing = 10
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }

// MARK: - Private Methods

    private func configurePokemonImageView() {
        mainStackView.addArrangedSubview(imagePokemon)
        imagePokemon.heightAnchor.constraint(equalToConstant: 300).isActive = true
        spinner.isHidden = false
        spinner.startSpinner()
        imagePokemon.contentMode = .scaleAspectFill

        imagePokemon.loadFrom(URLAddres: showPokemon?.imageUrl ?? "", completion: {
            self.spinner.stopSpinner()
            self.spinner.isHidden = true
        })
    }

    private func configureTextPokemon() {
        mainStackView.addArrangedSubview(textPokemon)
        textPokemon.heightAnchor.constraint(equalToConstant: 130).isActive = true
        textPokemon.text = showPokemon?.description ?? ""
        textPokemon.font = .italicSystemFont(ofSize: 12)
        textPokemon.isEditable = false
        textPokemon.isSelectable = false
    }

    private func configureTypeLabel() {
        mainStackView.addArrangedSubview(typeLabel)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            typeLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        typeLabel.text = "Tipo: \(showPokemon?.type ?? "")"
        typeLabel.font = .boldSystemFont(ofSize: 25)
        typeLabel.textAlignment = .center
    }

    private func configureLabelStackView() {
        mainStackView.addArrangedSubview(labelStackView)
        labelStackView.axis = .horizontal
        labelStackView.distribution = .fillEqually
        labelStackView.spacing = 10
    }

    private func configureLabelAttack() {
        labelStackView.addArrangedSubview(attackLabel)
        attackLabel.textAlignment = .center
        attackLabel.textColor = .red
        attackLabel.font = .boldSystemFont(ofSize: 20)
        attackLabel.text = "Ataque: \(showPokemon?.attack ?? 0)"
    }

    private func configureLabelDefense() {
        labelStackView.addArrangedSubview(defenseLabel)
        defenseLabel.textAlignment = .center
        defenseLabel.textColor = .systemYellow
        defenseLabel.font = .boldSystemFont(ofSize: 20)
        defenseLabel.text = "Defensa: \(showPokemon?.defense ?? 0)"
    }

    private func setupSpinner() {
        view.addSubview(spinner)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: imagePokemon.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: imagePokemon.centerYAnchor),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100)
        ])
        spinner.backgroundColor = UIColor(white: 0, alpha: 0.7)
        spinner.isHidden = true
    }
}
