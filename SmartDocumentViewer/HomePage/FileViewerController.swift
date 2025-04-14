//
//  FileViewerController.swift
//  SmartDocumentViewer
//
//  Created by Aiysha on 14/04/25.
//

import UIKit
import PDFKit

class FileViewerController: UIViewController {
    @IBOutlet var pdfviewer: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Balance Sheet"
        
        
        actionLoadPDF()
        
    }
    
    
    func actionLoadPDF() {
        
        if let url = URL(string: "https://fssservices.bookxpert.co/GeneratedPDF/Companies/nadc/2024-2025/BalanceSheet.pdf")  {
            if let pdfDocument = PDFDocument(url: url) {
                DispatchQueue.main.async {
                    
                    self.pdfviewer.displayMode = .singlePageContinuous
                    self.pdfviewer.autoScales = true
                    self.pdfviewer.displayDirection = .vertical
                    self.pdfviewer.document = pdfDocument
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
