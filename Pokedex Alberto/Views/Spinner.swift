import UIKit

class Spinner: UIView {

    var spinner = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super .init(frame: frame)
        addSubview(spinner)
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
