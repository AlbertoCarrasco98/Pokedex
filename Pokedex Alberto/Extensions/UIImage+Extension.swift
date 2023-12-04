import UIKit

extension UIImageView {
    
    func loadFrom(URLAddres : String, completion: @escaping () -> Void) {
        guard let url = URL(string: URLAddres) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard
                let data = data,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    completion()
                }
                return
            }

            DispatchQueue.main.async { [weak self] in
                self?.image = image
                completion()
            }
        }
        .resume()
    }
}
