# 4강 화면전환

- iOS에서 화면 전환 방식 분류
    - 뷰 컨트롤러의 뷰 위에 다른 뷰를 가져와 바꿔치기하기
        - 잘 안씀.
    - 뷰 컨트롤러에서 다른 뷰 컨트롤러를 호출하여 화면 전환
    - 내비게이션 컨트롤러를 사용하여 화면 전환
    - 화면 전환용 객체 세그웨이Segueway를 사용해 화면 전환하기
    
1. 뷰 컨트롤러에서 다른 뷰 컨트롤러를 호출하여 화면 전환
    
    ```swift
    //기본 화면호출 구문 
    self.present(_ :animated:)
    //기본 화면복귀 구문
    self.presentingViewController?.dismiss(_:animated:)
    ```
    
    - 현재의 뷰 컨트롤러에서 이동할 대상 뷰 컨트롤러를 직접 호출해서 화면을 표시하는 방식
    - aka 프레젠테이션 방식
    - 모든 뷰 컨트롤러는 UIViewController 클래스를 상속받는데, 여기 정의된 present() 메소드를 사용해 화면을 전환한다.
    - presentingViewController? 이유: 화면을 걷어낼 때 주체가 자기 자신이 아니다. 
    자신을 띄우고 있는 ‘이전의 뷰 컨트롤러'에게 요청해야 하기 때문에 해당 속성에서 dismiss 메소드 호출.
    - self.present(_ : animated: completion:) 에서 completion :
        - 화면 호출이 완성됐을 때 처리할 구문 호출.
        - 해당 메소드를 사용하는 이유 : 별개의 코드로 실행구문을 작성하면 화면전환이 먼저 실행될지 이후 코드가 먼저 실행될지 정확히 보장할 수 없다. (화면 전환은 비동기 방식이기 때문)
    - 자세한 코드
        1. 새로 표시할 뷰 컨트롤러를 인스턴스화 한다. 
        2. 인스턴스화한 뷰 컨트롤러의 전환 효과를 지정한다.(옵션)
        3. present() 메소드를 통해 호출한다. 
        
        ```swift
        //화면호출
        @IBAction func 버튼이름(_ sender: Any) {
            guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "스토리보드 아이디") else { 
                return 
                }
            uvc.modalTRansitionStyle = UIModalTransitionStyle.coverVertical // 옵션
            self.present(uvc, animated: true)
        }
        
        //화면복귀
        @IBAction func 버튼이름(_ sender: Any){
            self.presentingViewController?.dismiss(uvc, animated: true)
        }
        ```
        
        - 특징
            - 인스턴스화가 중요 : 객체지향 언어에서 ‘메모리에 올려진다'는 ‘클래스의 인스턴스가 생성된다'는 의미.
            
2. 내비게이션 컨트롤러를 이용한 화면 전환
    
    ```swift
    //기본 최상위 추가 구문
    pushViewController(_:animated:)
    //기본 최상위 제거 구문
    popViewController(_:animated:)
    ```
    
    - 내비게이션 스택: 배열 형식.
        - 루트 뷰 컨트롤러 : 가장 첫번째, 가장 아래.
        - 현재 표시되는 컨트롤러 : 최상위.
    - 자세한 코드
        
        ```swift
        // 추가
        @IBAction func 버튼이름(_ sender:Any){
            guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: 스토리보드 이름) else {
                return 
            }
            self.navigationController?.pushViewController(uvc, animated: true)
        }
        
        // 제거
        @IBAction func 버튼이름(_ sender:Any){
            self.navigationController?.popViewController(uvc, animated: true)
        }
        ```
        
        - pushViewController / popViewController를 호출하는 대상은 navigationController 이다.
3. 세그웨이를 이용한 화면 전환
    - Segueway : 스토리보드에서 뷰 컨트롤러 사이의 연결 관계 및 화면 전환을 관리
        - 세그웨이는 목적지의 뷰 컨트롤러 인스턴스를 자동으로 생성한다.
    - 세그웨이 동작 방식 두 가지
        - Action Segue : 버튼, 테이블 셀의 이벤트 트리거에 자동으로 연결
        - Manual Segue : performSegue(withIdentifier:sender:)
    - 매뉴얼 세그웨이
        - 뷰 컨트롤러와 뷰 컨트롤러 사이에 연결되는 수동 실행 세그웨이.
        - 트리거 없이 수동으로 실행해야 하므라 소스코드에서 메소드를 호출해야 한다.
        - 세그웨이 라인으로 설정하는 예시 :
            - Dock bar의 View Controller 버튼을 이용해 연결
            - 세그웨이의 ID를 지정하고, 이동하려는 뷰 컨트롤러 클래스에 매뉴얼 세그웨이 구문을 넣어준다.
        
        ```swift
        self.performSegue(withIdentifier: 세그ID, sender: self)
        ```
        
        - 버튼을 통해 설정하는 예시 :
            - 이정표 메소드 만들기.
            - 뷰 컨트롤러 클래스에 UIStoryboardSegue 타입의 인자값 갖는 메소드 정의.
            
            ```swift
            class ViewController: UIViewController {
                @IBAction func 버튼이름(_ segue: UIStoryboardSegue) {
                }
            }
            ```
            
            - 버튼과 해당 메소드를 Dock bar의 exit을 통해 연결.
            - 이를 활용하면 원하는 페이지로 한 번에 돌아갈 수 있는 버튼을 만들 수 있음.
            ( 원하는 뷰 컨트롤러 클래스에 이정표 메소드를 정의하면 된다.)
    - 커스텀 세그웨이
        - UIStoryboardSeuge를 서브클래싱하여 새로운 기능을 갖춘 세그웨이 객체 정의
        - UIStoryboardSegue 클래스에서 세그웨이 실행을 처리하는 메소드는 perform().
        - 새로운 스위프트 파일을 생성해 perform()을 오버라이드하는 커스텀 세그웨이 코드 작성
            
            ```swift
            class NewSegue: UIStoryboardSegue{
                
                override func perform() {
                    let srcUVC = self.source
                    let destUVC = self.destination
                    UIView.transition(from: srcUVC.view,
                                      to: destUVC.view,
                                      duration: 2,
                                      options: .transitionCurlDown)
                }
            }
            ```
            
            - 출발지 : self.source / 목적지 : self.destination
            - UIView 객체의 전환 기능 사용 : UIView.transition(form:to:duration:options:)
                - transition은 타입클래스이기 때문에 UIVIew 인스턴스 생성 안하고 호출 가능.
                - from/to에 .view 가 붙는 이유: 뷰 컨트롤러 자체에는 뷰가 없기 때문에.
    - 전처리 메소드
        - 세그웨이를 이용하여 화면을 전환하는 과정에서 특별한 처리를 하고싶을 때.
        - 호출 주체는 시스템. 우리가 임의로 호출할 수 없다.
        - 이미 UIVIewController 클래스에 정의되어 있기 때문에 오버라이드 한다.
        - 두 개의 매개변수 : 메소드를 호출한 세그웨이 객체(UIStoryboardSegue), 세그웨이를 실행하는 트리거 정보.
