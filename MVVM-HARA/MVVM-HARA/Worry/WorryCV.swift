//
//  ViewController.swift
//  MVVM-HARA
//
//  Created by saint on 2023/03/31.
//

import UIKit
import SnapKit
import Then
import Combine

class WorryCV: UIViewController, RefreshListDelegate{
    
    // MARK: - Properties
    var worryVM: WorryVM = WorryVM()
    var modalVC = ModalVC()
    
    var worryList: [WorryListModel] = []
    var disposalbleBag = Set<AnyCancellable>()
    
    private let titleLabel = UILabel().then{
        $0.text = "과거의 고민"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 26, weight: .bold)
    }
    
    private let templateBtn = UIButton().then{
        $0.setBackgroundImage(UIImage(named: "templateBtn"), for: .normal)
        $0.contentMode = .scaleToFill
    }
    
    private let sortHeaderView = WorryListHeaderView()
    
    private let flowLayout = UICollectionViewFlowLayout().then{
        $0.scrollDirection = .vertical
    }
    
    lazy var worryListCV: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    // MARK: - Constants
    final let worryListInset: UIEdgeInsets = UIEdgeInsets(top: 25, left: 16.adjustedW, bottom: 100, right: 16.adjustedW)
    final let interItemSpacing: CGFloat = 15.adjustedW
    final let lineSpacing: CGFloat = 15.adjustedW
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        self.setBindings()
        self.registerCV()
        self.pressBtn()
        
        /// modalVC가 dismiss되는 것을 notificationCenter를 통해 worryVC가 알 수 있게 해줍니다.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didDismissDetailNotification(_:)),
            name: NSNotification.Name("DismissModalView"),
            object: nil
        )
    }
    
    // MARK: - Functions
    @objc func didDismissDetailNotification(_ notification: Notification) {
        DispatchQueue.main.async { [self] in
            
            /// modalVC가 dismiss될때 컬렉션뷰를 리로드해줍니다.
            print(worryVM.worryList)
            worryListCV.reloadData()
            print("reload 성공!")
        }
    }
    
    func refreshList(list: [WorryListModel]) {
        worryVM.worryList = list
        print("delegate")
    }
    
    private func registerCV() {
        worryListCV.register(WorryCVC.self,
                             forCellWithReuseIdentifier: WorryCVC.classIdentifier)
        worryListCV.register(WorryListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WorryListHeaderView.classIdentifier)
    }
    
    func pressBtn(){
        sortHeaderView.sortBtn.press {
            let modalVC = ModalVC()
            modalVC.modalPresentationStyle = .pageSheet
            
            /// 클릭될때마다 delegate를 새로 받아올 수 있게 하여 권한을 계속 새롭게 부여해줍니다.
            modalVC.refreshListDelegate = self
            
            if let sheet = modalVC.sheetPresentationController {
                
                /// 지원할 크기 지정
                /// 크기 늘리고 싶으면 뒤에 ", .large()" 추가
                sheet.detents = [.medium()]
                
                /// 시트 상단에 그래버 표시 (기본 값은 false)
                sheet.prefersGrabberVisible = true
                
                /// 뒤 배경 흐리게 제거 (기본 값은 모든 크기에서 배경 흐리게 됨)
                /// 배경 흐리게 할 시에는 sheet가 올라왔을 때 배경 클릭해도 sheet 안 사라짐
                //                sheet.largestUndimmedDetentIdentifier = .medium
            }
            self.present(modalVC, animated: true)
        }
    }
}
// MARK: - 뷰모델 관련
extension WorryCV{
    /// 뷰모델의 데이터를 뷰컨의 리스트 데이터와 연동
    fileprivate func setBindings(){
        print("ViewController - setBindings()")
        self.worryVM.$worryList.sink{ [weak self] (updatedList : [WorryListModel]) in
            print("ViewController - updatedList.count: \(updatedList.count)")
            self?.worryList = updatedList
            self?.sortHeaderView.numLabel.text = "총 \(self!.worryList.count)개"
        }.store(in: &disposalbleBag)
    }
}

// MARK: - Layout
extension WorryCV{
    private func setLayout(){
        view.backgroundColor = .black
        view.addSubviews([titleLabel, templateBtn, sortHeaderView, worryListCV])
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(40.adjustedH)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide).offset(16.adjustedW)
        }
        
        templateBtn.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(40.adjustedH)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-16.adjustedW)
        }
        
        sortHeaderView.snp.makeConstraints{
            $0.top.equalTo(templateBtn.snp.bottom)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(40)
        }
        
        worryListCV.snp.makeConstraints{
            $0.top.equalTo(sortHeaderView.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - UICollectionDelegate
extension WorryCV: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 164.adjustedW, height: 164.adjustedW)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return worryListInset
    }
}

// MARK: - UICollectionViewDataSource

extension WorryCV: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return worryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WorryCVC.classIdentifier, for: indexPath)
                as? WorryCVC else { return UICollectionViewCell() }
        cell.dataBind(model: worryList[indexPath.item])
        return cell
    }
}
