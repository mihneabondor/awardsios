//
//  ViewController.swift
//  Awards
//
//  Created by Mihnea on 6/27/22.

import UIKit
import SwiftUI
import WidgetKit
import BackgroundTasks

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    let model = ViewModel()
    
    var timeFrameButton = UIBarButtonItem()
    var awards = [Award]()
    var editMode = false
    var timer : Timer!
    @IBOutlet weak var collectionView : UICollectionView!
    
    func addObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name(rawValue: "mihnea.awards.reloadData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(noAwardsLabel), name: Notification.Name(rawValue: "mihnea.awards.noAwards"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchAwards), name: Notification.Name(rawValue: "mihnea.awards.loading"), object: nil)
    }
    
    
    @objc func reloadData() {
        do {
            let savedData = UserDefaults.init(suiteName: "group.mihnea.Awards")!.data(forKey: "mihnea.awards.saved")
            guard savedData != nil else { return}
            let decoder = JSONDecoder()
            awards = try decoder.decode([Award].self, from: savedData!)
            DispatchQueue.main.async { self.collectionView.reloadData() }
        } catch {
            print("lasa")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        if(editMode) {addDoneButton()}
        else{self.navigationItem.setLeftBarButton(nil, animated: true)}
        print("COUNT: \(awards.count)")
    }
    
    func modelInit() {
             model.getData() {completion in
                guard completion == true else {return}
                model.retrieveImg() { completion1 in
                    guard completion1 == true else {return}
                }
            }
    }
    
    @objc func fetchAwards() {
        if !dbMonthly.isEmpty && !dbCompetitions.isEmpty && !dbLimited.isEmpty && !dbClose.isEmpty{
            self.collectionView.isHidden = false
            if let loading = view.viewWithTag(3) {
                loading.removeFromSuperview()
            }
            timer.invalidate()
        }
    }
    
    func spinner() {
        if dbMonthly.isEmpty || dbCompetitions.isEmpty || dbLimited.isEmpty || dbClose.isEmpty || dbMonthly[0].image.count != 0 || dbCompetitions[0].image.count != 0 || dbLimited[0].image.count != 0 || dbClose[0].image.count != 0 {
            let loading = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            loading.center = view.center
            self.collectionView.isHidden = true
            
            loading.startAnimating()
            self.view.addSubview(loading)
            loading.tag = 3
        } else {
            fetchAwards()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.Mihnea.awards.bgNotifications", using: nil) { task in
             NotificationsSchedule().handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        
        if Reachability.isConnectedToNetwork(){
        
        modelInit()
        addObs()
        navBarButtons()
        spinner()
        
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { Timer in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mihnea.awards.loading"), object: nil)
        })
        
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound, .provisional]){_, _ in}
//        NotificationsSchedule().leSchedule()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Awards"
        
        splashScreen()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AwardsNibCell", bundle: nil), forCellWithReuseIdentifier: "AwardsCell")
        
        do {
            let savedData = UserDefaults.init(suiteName: "group.mihnea.Awards")!.data(forKey: "mihnea.awards.saved")
            guard savedData != nil else { return}
            let decoder = JSONDecoder()
            awards = try decoder.decode([Award].self, from: savedData!)
        } catch {
            print("lasa")
        }
        
        noAwardsLabel()
        } else {
            noInternetLabel()
        }
    }
    
    private func noInternetLabel() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 21))
        label.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2-21)
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.textAlignment = .center
        label.text = "Unable to fetch data"
        
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-15, height: 21))
        label2.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        label2.textAlignment = .center
        label2.text = "Check your internet connection and"
        
        let label3 = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-15, height: 21))
        label3.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2+21)
        label3.textAlignment = .center
        label3.text = "restart the app"
        
        
        
        self.view.addSubview(label)
        self.view.addSubview(label2)
        self.view.addSubview(label3)
    }
    
    private func createMenu(actionTitle: String? = nil) -> UIMenu {
        let menu = UIMenu(image: UIImage(systemName: "doc.plaintext"), children: [
            UIAction(title: "Default", image: UIImage(systemName: "doc.plaintext")) { [unowned self] action in
                self.timeFrameButton.menu = createMenu(actionTitle: action.title)
                reloadData()
                self.collectionView.reloadData()
            },
            UIAction(title: "Alphabetically", image: UIImage(systemName: "textformat.abc")) { [unowned self] action in
                self.timeFrameButton.menu = createMenu(actionTitle: action.title)
                awards.sort {
                    $0.name < $1.name
                }
                self.collectionView.reloadData()
            },
            UIAction(title: "By count", image: UIImage(systemName: "number")) { [unowned self] action in
                self.timeFrameButton.menu = createMenu(actionTitle: action.title)
                awards.sort {
                    $0.count > $1.count
                }
                self.collectionView.reloadData()
            }
        ])
        
        if let actionTitle = actionTitle {
            menu.children.forEach { action in
                guard let action = action as? UIAction else {
                    return
                }
                if action.title == actionTitle {
                    action.state = .on
                }
            }
        } else {
            let action = menu.children.first as? UIAction
            action?.state = .on
        }
        
        return menu
    }
    
    func splashScreen() {
        if UserDefaults.standard.bool(forKey: "mihnea.firstRun.v1.0.b12") == false {
            let view = WhatsNewView()
            let viewCtrl = UIHostingController(rootView: view)
            self.present(viewCtrl, animated: true, completion: nil)
            noAwardsLabel()
        }
    }
    
    @objc func noAwardsLabel() {
        print("call made")
        if awards.isEmpty{
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 21))
            label.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2-21)
            label.font = UIFont.boldSystemFont(ofSize: 17.0)
            label.textAlignment = .center
            label.text = "No awards"
            label.tag = 1
            
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "ellipsis.circle")!.withTintColor(.tintColor)
            let text = NSMutableAttributedString(string: "Let's add some from the ")
            text.append(NSAttributedString(attachment: imageAttachment))
            text.append(NSAttributedString(string: " menu"))
            
            let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 21))
            label2.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
            label2.textAlignment = .center
            label2.attributedText = text
            label2.tag = 2
            
            self.view.addSubview(label)
            self.view.addSubview(label2)
        } else {
            if let label1 = self.view.viewWithTag(1) {
                label1.removeFromSuperview()
            }
            if let label2 = self.view.viewWithTag(2) {
                label2.removeFromSuperview()
            }
        }
    }
    
    func navBarButtons() {
        var menuButton = UIBarButtonItem()
        let topActions = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "Add", image: UIImage(systemName: "plus")) { action in
                self.editMode = false
                
                self.collectionView.reloadData()
                self.navigationItem.setLeftBarButton(nil, animated: true)
                let view = addNewAwardsView()
                let viewCtrl = UIHostingController(rootView: view)
//                let storyboard = UIStoryboard(name: "AddNew", bundle: nil)
//                let sheetPresentationController = storyboard.instantiateViewController(withIdentifier: "AddNew")
                if let sheet = viewCtrl.sheetPresentationController {
                    sheet.detents = [.medium()]
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.prefersGrabberVisible = true
                }
                self.present(viewCtrl, animated: true, completion: nil)
            },
            UIAction(title: "Edit", image: UIImage(systemName: "pencil")) {action in
                self.editMode = true
                self.collectionView.reloadData()
                self.addDoneButton()
            }
        ])
        let middleActions = [
            UIAction(title: "Settings", image: UIImage(systemName: "gear")) {action in
                let view = SettingsView()
                let viewCtrl = UIHostingController(rootView: view)
                self.present(viewCtrl, animated: true, completion: nil)
            }]
        let middleMenu = UIMenu(title: "", options: .displayInline, children: middleActions)
        let menu = UIMenu(title: "", children: [topActions, middleMenu])
        
        timeFrameButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down"),
            menu: createMenu()
        )
        menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: menu)
        navigationItem.rightBarButtonItems = [menuButton, timeFrameButton]
    }
    
    func addDoneButton() {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTap))
        navigationItem.leftBarButtonItem = doneButton
    }
    
    @objc func doneButtonTap() {
        self.editMode = false
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.collectionView.reloadData()
    }
    
    func save() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(awards)
            UserDefaults.init(suiteName: "group.mihnea.Awards")!.set(data, forKey: "mihnea.awards.saved")
        } catch {
            print("\(LocalizedError.self)")
        }
    }
    
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AwardsCell", for: indexPath) as! AwardCell
        
        cell.layer.cornerRadius = 20
        cell.backgroundColor = .systemGray4
        
        cell.awardView.image = UIImage(data: awards[indexPath.row].image) ?? UIImage(systemName: "questionmark")
        
        cell.awardCount.text = "x" + String(awards[indexPath.row].count)
        cell.awardCount.backgroundColor = .systemGray2
        cell.awardCount.layer.masksToBounds = true
        cell.awardCount.layer.cornerRadius = 10
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 0.2
        longPress.delaysTouchesBegan = true
        longPress.delegate = self
        cell.addGestureRecognizer(longPress)
        
        cell.removeButton.isHidden = !self.editMode
        if(editMode) {cell.shake()}
        
        else {cell.stopShaking()}
        cell.buttonAction = { sender in
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            UIView.animate(withDuration: 0.4) {
                cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            } completion: { _ in
                self.awards.remove(at: indexPath.row)
                
                UIView.animate(withDuration: 0.3) {
                    self.collectionView.reloadData()
                }
                self.save()
                cell.transform = .identity
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mihnea.awards.noAwards"), object: nil)
            }
        }
        return cell
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if editMode == false {
            if gestureRecognizer.state != UILongPressGestureRecognizer.State.ended {
                let haptics = UIImpactFeedbackGenerator(style: .medium)
                haptics.prepare()
                let pressLocation = gestureRecognizer.location(in: self.collectionView)
                if let indexPath = self.collectionView.indexPathForItem(at: pressLocation) {
                    let cell = self.collectionView.cellForItem(at: indexPath)
                    UIView.animate(withDuration: 0.2) {
                        haptics.impactOccurred()
                        cell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    } completion: { _ in
                        UIView.animate(withDuration: 0.3) {
                            cell?.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
                        } completion: { _ in
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                                self.editMode = true
                                self.collectionView.reloadData()
                                self.addDoneButton()
                            }
                        }
                    }
                } else {print("couldn't find index path")}
            } else {
                let pressLocation = gestureRecognizer.location(in: self.collectionView)
                if let indexPath = self.collectionView.indexPathForItem(at: pressLocation) {
                    let cell = self.collectionView.cellForItem(at: indexPath)
                    UIView.animate(withDuration: 0.3) {
                        cell?.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }
                } else {print("couldn't find index path")}
            }
        }
        
        if editMode == true {
            switch gestureRecognizer.state {
            case .began:
                guard let indexPath = collectionView.indexPathForItem(at: gestureRecognizer.location(in: self.collectionView)) else {return}
                collectionView.beginInteractiveMovementForItem(at: indexPath)
            case .changed:
                collectionView.updateInteractiveMovementTargetPosition(gestureRecognizer.location(in: self.collectionView))
            case .ended:
                collectionView.endInteractiveMovement()
            default:
                collectionView.cancelInteractiveMovement()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return awards.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: -5, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = awards.remove(at: sourceIndexPath.row)
        awards.insert(item, at: destinationIndexPath.row)
        self.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
}

extension UIView {
    func shake() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 2
        shakeAnimation.autoreverses = true
        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle
        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.15
        shakeAnimation.repeatCount = 10000
        shakeAnimation.timeOffset = 290 * drand48()
        
        let layer: CALayer = self.layer
        layer.add(shakeAnimation, forKey:"shaking")
    }
    
    func stopShaking() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "shaking")
    }
}
