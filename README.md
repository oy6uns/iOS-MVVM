# iOS-MVVM
HARA 릴리즈 전 MVVM 연습

---
## ver 04.02_ 
1. WorryCV에서 Combine을 통해 고민리스트를 ViewModel로부터 전달받고, 컬렉션뷰에 띄어준다. 
2. 템플릿별 categoryId를 설정해두고, [전체]버튼을 누르면 컬렉션뷰에 어떤 템플릿에 대한 고민을 뛰울지를 정할 수 있는 템플릿 선택창이 modal방식으로 올라온다.
-> 아직 버튼의 형태를 변하는 것을 구현하지 않음(값만 전달해주면 되서 쉬울 것이라 생각함)
3. 템플릿을 선택하면 컬렉션뷰가 reload되는 동시에 그에 맞는 고민들이 컬렉션뷰에 띄어진다. 

### 실행화면
![Simulator Screen Recording - iPhone 14 Pro - 2023-04-02 at 19 13 41](https://user-images.githubusercontent.com/45239582/229346761-ff328211-fdeb-447e-ac2b-6a7f4edc151e.gif)



