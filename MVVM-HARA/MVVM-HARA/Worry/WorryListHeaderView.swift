//
//  WorryListHeaderView.swift
//  MVVM-HARA
//
//  Created by saint on 2023/03/31.
//

import UIKit
import SnapKit
import Then

// MARK: - ListHeaderView
class WorryListHeaderView: UICollectionReusableView {
    
    // MARK: - UI Components
    let numLabel = UILabel().then {
        $0.text = "총 4개"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 14.adjustedW, weight: .bold)
    }
    
    let sortBtn = UIButton().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = UIColor.white.cgColor
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        $0.setTitle("전체", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WorryListHeaderView{
    func setLayout(){
        self.backgroundColor = .clear
        self.addSubViews([numLabel, sortBtn])
        
        numLabel.snp.makeConstraints{
            $0.centerY.equalTo(sortBtn)
            $0.leading.equalToSuperview().offset(16.adjustedW)
        }
        
        sortBtn.snp.makeConstraints{
            $0.top.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-16.adjustedW)
            $0.width.equalTo(82.adjustedW)
            $0.height.equalTo(24.adjustedW)
        }
    }
}
