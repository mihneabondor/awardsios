//
//  AddNew.swift
//  Awards
//
//  Created by Mihnea on 8/29/22.
//

import Foundation
import UIKit

class AddNew : UIViewController, UISheetPresentationControllerDelegate {
    @IBOutlet weak var previewBg : UILabel!
    @IBOutlet weak var countBg : UILabel!
    
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISetup()
        
    }
    
    private func UISetup() {
        sheetPresentationController.delegate = self
        sheetPresentationController.selectedDetentIdentifier = .large
        sheetPresentationController.detents = [.medium(), .large()]
        sheetPresentationController.prefersGrabberVisible = true
        
        previewBg.backgroundColor = .systemGray5
        previewBg.layer.cornerRadius = 20
        previewBg.layer.masksToBounds = true
        
        countBg.backgroundColor = .systemGray2
        countBg.layer.cornerRadius = 10
        countBg.layer.masksToBounds = true
        countBg.text = "x100"
    }
    
}
