import UIKit
import VisionKit

final class ViewController: UIViewController {

    private let dataScannerViewController = DataScannerViewController(recognizedDataTypes: [.text()],
                                                                      qualityLevel: .balanced,
                                                                      recognizesMultipleItems: false,
                                                                      isHighFrameRateTrackingEnabled: true,
                                                                      isPinchToZoomEnabled: true,
                                                                      isGuidanceEnabled: true,
                                                                      isHighlightingEnabled: true)
    
    private var scannerAvailable: Bool { DataScannerViewController.isSupported && DataScannerViewController.isAvailable }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataScannerViewController.delegate = self
        
        if scannerAvailable {
            present(dataScannerViewController, animated: true)
            try? dataScannerViewController.startScanning()
        }
    }
}

extension ViewController: DataScannerViewControllerDelegate {
    func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
        // handle here the sudden camera scanner unavaliability. Ex: camera permission revoked.
        print("The scanner became unavailable. Sorry.")
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        for item in addedItems {
            switch item {
            case .text(let text):
                print("Text Observation - \(text.observation)")
                print("Text transcript - \(text.transcript)")
                process(data: text.transcript)
            case .barcode:
                break
            @unknown default:
                print("Should not happen")
            }
        }
    }
    
    private func process(data: String) {
        guard let mathObject = MathObject(inputData: data) else {
            print("Could not parse into MathObject")
            return
        }
        
        dismiss(animated: true)
        
        let alertViewController = UIAlertController(title: "Math Solver", message: "The result of your calculus is: \(mathObject.result)", preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "Holy Swift!", style: .cancel))
        present(alertViewController, animated: true)
    }
}
