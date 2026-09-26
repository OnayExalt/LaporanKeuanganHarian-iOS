import UIKit
import WebKit
import CoreLocation

final class ContentViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let webView = WKWebView(frame: .zero, configuration: ContentViewController.makeConfiguration())
    private let locationManager = LocationManager()
    private var currentUsername = ""
    private var splashView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.02, green: 0.07, blue: 0.14, alpha: 1)
        configureWebView()
        NotificationCenter.default.addObserver(self, selector: #selector(handleBridgeNotification(_:)), name: .bridgeMessage, object: nil)
        showSplash()
        loadWebsite()
    }

    private static func makeConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        let controller = WKUserContentController()
        controller.add(BridgeProxy(), name: "iosLogin")
        controller.add(BridgeProxy(), name: "iosChrome")
        controller.add(BridgeProxy(), name: "iosLocation")
        configuration.userContentController = controller
        configuration.preferences.javaScriptEnabled = true
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        return configuration
    }

    private func configureWebView() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        // Compatibility layer: reproduce the Android JS bridge names used by the APK.
        let bridgeScript = """
        (function(){
          window.AndroidLogin={login:function(v){window.webkit.messageHandlers.iosLogin.postMessage(String(v||''));}};
          window.AndroidChrome={captureInvoice:function(x,y,w,h){window.webkit.messageHandlers.iosChrome.postMessage({x:x||0,y:y||0,w:w||0,h:h||0});}};
          window.AndroidLocation={acceptLocation:function(v){window.webkit.messageHandlers.iosLocation.postMessage(String(v||''));}};
        })();
        """
        webView.configuration.userContentController.addUserScript(WKUserScript(source: bridgeScript, injectionTime: .atDocumentStart, forMainFrameOnly: false))
        let loginWatcher = """
        (function(){if(window.__iosWatcherInstalled)return;window.__iosWatcherInstalled=true;
          function send(v){v=(v||'').trim();if(!v)return;if(window.__lastIOSLogin===v)return;window.__lastIOSLogin=v;try{window.webkit.messageHandlers.iosLogin.postMessage(v);}catch(e){}}
          function findUsername(){var xs=Array.prototype.slice.call(document.querySelectorAll('input'));var best=null,score=-1;xs.forEach(function(x){var type=(x.type||'text').toLowerCase();if(type==='password'||type==='hidden'||x.disabled)return;var v=(x.value||'').trim();if(!v)return;var n=((x.name||'')+' '+(x.id||'')+' '+(x.placeholder||'')+' '+(x.getAttribute('aria-label')||'')).toLowerCase();var sc=0;if(/username|user name|userid|user id|login|email|akun|pengguna/.test(n))sc+=100;if(type==='email')sc+=50;var form=x.form;if(form&&form.querySelector('input[type=password]'))sc+=40;if(type==='text')sc+=5;if(sc>score){score=sc;best=x;}});if(best)send(best.value);}
          function hook(){findUsername();Array.prototype.forEach.call(document.querySelectorAll('input'),function(x){if(x.__iosHook)return;x.__iosHook=true;['input','change','blur'].forEach(function(ev){x.addEventListener(ev,function(){findUsername();},true);});});Array.prototype.forEach.call(document.querySelectorAll('button,input[type=submit]'),function(b){if(b.__iosHook)return;b.__iosHook=true;b.addEventListener('click',function(){setTimeout(findUsername,100);setTimeout(findUsername,700);},true);});}
          hook();setInterval(hook,1000);try{new MutationObserver(function(){hook();}).observe(document.documentElement,{childList:true,subtree:true});}catch(e){}
        })();
        """
        webView.configuration.userContentController.addUserScript(WKUserScript(source: loginWatcher, injectionTime: .atDocumentEnd, forMainFrameOnly: false))
    }

    private func loadWebsite() {
        webView.load(URLRequest(url: AppConfig.websiteURL, cachePolicy: .useProtocolCachePolicy))
    }

    private func showSplash() {
        let splash = UIView(frame: view.bounds)
        splash.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        splash.backgroundColor = UIColor(red: 0.02, green: 0.07, blue: 0.14, alpha: 1)

        let imageView = UIImageView(image: UIImage(named: "logo_singa"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        splash.addSubview(imageView)

        let title = UILabel()
        title.text = "LAPORAN KEUANGAN HARIAN"
        title.textColor = .white
        title.font = .systemFont(ofSize: 22, weight: .bold)
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        splash.addSubview(title)

        let subtitle = UILabel()
        subtitle.text = "LIONGOLD  •  PREMIUM SYSTEM"
        subtitle.textColor = UIColor(red: 0.85, green: 0.67, blue: 0.25, alpha: 1)
        subtitle.font = .systemFont(ofSize: 13, weight: .semibold)
        subtitle.textAlignment = .center
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        splash.addSubview(subtitle)

        let quote = UILabel()
        quote.text = "Oneday this app will show you not just numbers, but proof of your discipline and progress."
        quote.textColor = UIColor.white.withAlphaComponent(0.85)
        quote.font = .italicSystemFont(ofSize: 14)
        quote.numberOfLines = 0
        quote.textAlignment = .center
        quote.translatesAutoresizingMaskIntoConstraints = false
        splash.addSubview(quote)

        view.addSubview(splash)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: splash.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: splash.centerYAnchor, constant: -105),
            imageView.widthAnchor.constraint(equalToConstant: 170), imageView.heightAnchor.constraint(equalToConstant: 170),
            title.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20), title.leadingAnchor.constraint(equalTo: splash.leadingAnchor, constant: 20), title.trailingAnchor.constraint(equalTo: splash.trailingAnchor, constant: -20),
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8), subtitle.leadingAnchor.constraint(equalTo: splash.leadingAnchor, constant: 20), subtitle.trailingAnchor.constraint(equalTo: splash.trailingAnchor, constant: -20),
            quote.leadingAnchor.constraint(equalTo: splash.leadingAnchor, constant: 32), quote.trailingAnchor.constraint(equalTo: splash.trailingAnchor, constant: -32), quote.bottomAnchor.constraint(equalTo: splash.safeAreaLayoutGuide.bottomAnchor, constant: -55)
        ])
        splashView = splash
        DispatchQueue.main.asyncAfter(deadline: .now() + AppConfig.splashDuration) { [weak self, weak splash] in
            UIView.animate(withDuration: 0.35, animations: { splash?.alpha = 0 }) { _ in splash?.removeFromSuperview(); self?.splashView = nil }
        }
    }

    @objc private func handleBridgeNotification(_ note: Notification) {
        guard let message = note.object as? WKScriptMessage else { return }
        switch message.name {
        case "iosLogin":
            if let value = message.body as? String { currentUsername = value; locationManager.start(username: value) }
        case "iosLocation":
            if let value = message.body as? String { locationManager.start(username: value) }
        case "iosChrome":
            captureInvoice()
        default: break
        }
    }

    private func captureInvoice() {
        let config = WKSnapshotConfiguration()
        config.afterScreenUpdates = true
        webView.takeSnapshot(with: config) { [weak self] image, error in
            guard let self, let image else { return }
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }

    @objc private func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer?) {
        let title = error == nil ? "Invoice berhasil disimpan sebagai gambar" : "Gagal menyimpan invoice: \(error!.localizedDescription)"
        let alert = UIAlertController(title: AppConfig.appName, message: title, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraDevice = .front
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { decisionHandler(.cancel); return }
        if url.scheme == "whatsapp" || url.host == "wa.me" { UIApplication.shared.open(url); decisionHandler(.cancel); return }
        decisionHandler(.allow)
    }
}

private final class BridgeProxy: NSObject, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        NotificationCenter.default.post(name: .bridgeMessage, object: message)
    }
}

private extension Notification.Name { static let bridgeMessage = Notification.Name("iOSBridgeMessage") }
