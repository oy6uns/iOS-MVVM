//
//  ModalVC.swift
//  MVVM-HARA
//
//  Created by saint on 2023/04/01.
//

import UIKit
import SnapKit
import Then
import Combine

protocol RefreshListDelegate: AnyObject {
    func refreshList(list: [WorryListModel])
}


class ModalVC: UIViewController {
    
    // MARK: - Properties
    var worryVM: WorryVM = WorryVM()
    
    var templateList: [TemplateListModel] = []
    /// 데이터를 전달하기 위한 클로저 선언
    var completionHandler: (([WorryListModel]) -> [WorryListModel])?
    
    /// category에 맞는 컬렉션뷰를 화면에 보여주기 위한 배열
    var templateWithCategory: [WorryListModel] = []
    var disposalbleBag = Set<AnyCancellable>()
    
    weak var refreshListDelegate: RefreshListDelegate?
    
    private var templateIndex: Int = 0
    
    private let flowLayout = UICollectionViewFlowLayout().then{
        $0.scrollDirection = .vertical
    }
    
    private lazy var templateListCV: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        return view
    }()
        
    // MARK: - Constants
    final let templateListInset: UIEdgeInsets = UIEdgeInsets(top: 30, left: 16.adjustedW, bottom: 20, right: 16.adjustedW)
    final let lineSpacing: CGFloat = 8
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBindings()
        self.registerCV()
        self.setLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("DismissModalView"), object: nil, userInfo: nil)
    }
    
    // MARK: - Functions
    private func registerCV() {
        templateListCV.register(TemplateCVC.self,
                                forCellWithReuseIdentifier: TemplateCVC.classIdentifier)
    }
}

// MARK: - Layout
extension ModalVC{
    
    private func setLayout(){
        view.backgroundColor = .white
        view.addSubview(templateListCV)
        
        templateListCV.snp.makeConstraints{
            $0.top.equalToSuperview().offset(5)
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}


// MARK: - 뷰모델 관련
extension ModalVC{
    
    /// 뷰모델의 데이터를 뷰컨의 리스트 데이터와 연동
    fileprivate func setBindings(){
        print("ViewController - setBindings()")
        self.worryVM.$templateList.sink{ (updatedList : [TemplateListModel]) in
            print("ViewController - updatedList.count: \(updatedList.count)")
            self.templateList = updatedList
        }.store(in: &disposalbleBag)
    }
}

// MARK: - UICollectionDelegate

extension ModalVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 345.adjustedW, height: 70.adjustedW)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return templateListInset
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("click index=\(indexPath.row)")
        
        templateWithCategory = []
        templateIndex = indexPath.row
        
        /// worryList의 templateId와 같은 고민을 화면에 띄어줍니다.
        for i in 0...worryVM.worryList.count-1{
            if templateIndex == worryVM.worryList[i].templateId{
                templateWithCategory.append(worryVM.worryList[i])
            }
        }
        /// 0. 전체 템플릿 보기를 클릭 시에는 모든 고민을 화면에 띄어줍니다.
        if templateIndex == 0 {
            templateWithCategory = worryVM.worryList
        }
        print("templateIndex=\(templateIndex)")
        
        self.dismiss(animated: true, completion: nil)
        
        /// category에 해당하는 고민들을 담은 리스트를 worryCV로 보내주어, WorryVM의 List를 변경할 수 있게 해줍니다.
        refreshListDelegate?.refreshList(list: templateWithCategory)
        print("send the array=\(templateWithCategory)")
    }
}

// MARK: - UICollectionViewDataSource

extension ModalVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return templateList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TemplateCVC.classIdentifier, for: indexPath)
                as? TemplateCVC else { return UICollectionViewCell() }
        cell.dataBind(model: templateList[indexPath.item])
        return cell
    }
}
