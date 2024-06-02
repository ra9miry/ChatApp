
import UIKit
import SnapKit
import WebKit

final class MorePrivacyViewController: UIViewController, WKNavigationDelegate {

    var webChocoCharmView: WKWebView!
    let privacyChocoWebkaString = "https://www.app-privacy-policy.com/live.php?token=KHAnnUuVDhAIuPqhUlwO6Zaola9GfC2X"

    override func viewDidLoad() {
        super.viewDidLoad()
        chocoCharmWeb()
    }
    
    private func chocoCharmWeb() {
        guard let url = URL(string: privacyChocoWebkaString) else {
            print("Invalid URL")
            return
        }
        
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didComplete navigation: WKNavigation!) {
        if let title = webView.title {
            self.title = title
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Loading error: \(error)")
    }
}
