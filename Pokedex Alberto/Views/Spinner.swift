import UIKit

class Spinner: UIView {

    var spinner = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super .init(frame: frame)
        
        addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startSpinner() {
        spinner.startAnimating()
        spinner.isHidden = false
    }

    func stopSpinner() {
        spinner.stopAnimating()
        spinner.isHidden = true
    }
}
