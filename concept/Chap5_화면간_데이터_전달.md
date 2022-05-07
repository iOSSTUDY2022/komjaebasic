# 5강 화면간 데이터 전달

- 화면 전환 방식에서의 값 전달 방식
    - 직접 전달 방식(동기 방식)
        - 뷰 컨트롤러에 직접 값 전달
        - 영속적으로 값을 저장할 필요가 없는 화면 전환에서 사용
        - 수신-발신 모두 값의 명세를 파악하고 대입할 변수를 미리 생성해두어야 한다.
    - 간접 전달 방식(비동기 방식)
        - 저장소를 이용하여 값 전달
        - 지속적으로 값을 저장할 필요가 있는 화면 전환에서 사용
        - 상대적으로 소스코드가 복잡해질 수 있다.
        - 수신-발신 모두 저장소의 위치를 사전에 공유해야 한다.
        - 값을 전달하는 것보다 값을 저장하는 것에 가깝다.
        
- 직접 전달 방식
    1. 뷰 컨트롤러에 직접 값 전달(다음 화면에 전달)
        1. 순서
            1. VC1에서 VC2에 전달할 값을 준비한다. 
            2. VC2에서는 값을 대입받을 프로퍼티를 준비한다.
            3. VC1에 VC2의 인스턴스를 생성한다.(또는 생성된 인스턴스의 참조를 읽어온다.)
            4. VC1에 2번에서 정의한 VC2 인스턴스 프로퍼티에 값을 대입한다.
            5. VC1에서 VC2로 화면을 전환한다.
        2. 프레젠테이션 화면전환 방식 예제
            
            ```swift
            //  ViewController.swift
            //  SubmitValue-1
            //
            //  Created by 이형주 on 2022/05/03.
            //
            
            import UIKit
            
            class ViewController: UIViewController {
            
                override func viewDidLoad() {
                    super.viewDidLoad()
                    // Do any additional setup after loading the view.
                }
            
                @IBOutlet weak var email: UITextField!
                @IBOutlet weak var isUpdate: UISwitch!
                @IBOutlet weak var interval: UIStepper!
                @IBOutlet weak var isUpdateText: UILabel!
                @IBOutlet weak var intervalText: UILabel!
                
            // 밑의 두 액션메소드는 VC1 화면에 입력값을 즉각적으로 표시하기 위한 레이블. 
                @IBAction func onSwitch(_ sender: UISwitch) {
                    if (sender.isOn == true) {
                        self.isUpdateText.text = "갱신함"
                    } else {
                        self.isUpdateText.text = "갱신 안함"
                    }
                }
                
                @IBAction func onStepper(_ sender: UIStepper) {
                    let value = Int(sender.value)
                    self.intervalText.text = "\(value)분 마다"
                }
                
            // VC2의 인스턴스를 생성하고, VC2에서 정의한 프로퍼티를 가져와 VC1 값에 대입한다.
            // VC2 화면을 호출한다. 
                @IBAction func onSubmit(_ sender: Any) {
                    guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "ResultVC") as? ResultViewController else {
                        return
                    }
                    
                    uvc.paramEmail = self.email.text!
                    uvc.paramUpdate = self.isUpdate.isOn
                    uvc.paramStepper = self.interval.value
                    
                    self.present(uvc, animated: true)    
                }
                
            }
            
            //
            //  ResultViewController.swift
            //  SubmitValue-1
            //
            //  Created by 이형주 on 2022/05/03.
            //
            
            import Foundation
            import UIKit
            
            class ResultViewController: UIViewController {
                
                @IBOutlet var resultEmail: UILabel!
                @IBOutlet var resultUpdate: UILabel!
                @IBOutlet var resultInterval: UILabel!
                
            // VC1의 값을 받을 변수를 미리 만든다. (아울렛 변수에 값을 직접 받지 못하니까.)
                var paramEmail: String = ""
                var paramUpdate: Bool = true
                var paramStepper: Double = 0
                
            // VC2 화면에 값을 전달받기 위해 viewDidLoad() 메소드를 사용한다.
            // 해당 메소드 안에 VC2의 아울렛과 VC2에서 만들고 VC1에서 값을 대입한 프로퍼티들을 연결한다.
                override func viewDidLoad() {
                    self.resultEmail.text = paramEmail
                    self.resultUpdate.text = (self.paramUpdate == true ? "자동갱신" : "자동갱신안함")
                    self.resultInterval.text = "\(Int(paramStepper))분 마다 갱신"
                }
               
            // VC1 화면으로 전환한다. 
                @IBAction func onBack(_ sender: Any) {
                    self.presentingViewController?.dismiss(animated: true)
                }
            }
            ```
            
            - 예제 체크포인트
                - VC1에서 switch/stepper 액션메소드를 가져올 때.
                    - type 속성을 각각의 객체에 맞게 지정해야 한다. → 스위치와 스테퍼 컨트롤 객체의 속성 (isOn, value)를 사용할 것이기 때문. (이들은 해당 메소드들의 매개변수 sender의 속성)
                - 아울렛 변수는 외부에서 값을 직접 대입할 수 없다.
                    - 따라서 값을 대입할 프로퍼티를 따로 정의해야 한다.
                - VC2의 인스턴스 생성 시 해당 클래스로 타입캐스팅 필요.
                    - 그냥 화면을 호출하기 위해 인스턴스를 생성할때와 달리, 전환 대상의 프로퍼티를 참조하고 값을 대입해야 하기 때문.
                    - 다운캐스팅이기 때문에 guard let으로 옵셔널 바인딩이 필요.
                    (이후 값을 받을 땐 옵셔널 바인딩 해주어야 한다.)
                - 전달받은 값은 viewDidLoad() 메소드로 화면에 호출한다.
                - 불리언 타입은 3항 연산자로 간단하게 값을 출력할 수 있다.
        3. 세그웨이 화면전환 방식 예제 
            
            ```swift
            //
            //  ViewController.swift
            //  SubmitValue-2
            //
            //  Created by 이형주 on 2022/05/04.
            //
            
            import UIKit
            
            class ViewController: UIViewController {
            
            //...아울렛 선언 등 중략...//
                
            // 메뉴얼 세그웨이 실행 구문 작성
                @IBAction func onPerformSegue(_ sender: Any) {
                    self.performSegue(withIdentifier: "ManualSubmit", sender: self)
                }
            // 값을 전달하기 위해 전처리 구문 생성.
            // prepare()메소드를 사용해 인스턴스화된 VC2를 프로퍼티화.
            // 해당 프로퍼티에 전달할 값 입력.
                override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                    let dest = segue.destination
                    
                    guard let rvc = dest as? RVC else {
                        return
                    }
                    rvc.paramEmail = self.email.text!
                    rvc.paramUpdate = self.isUpdate.isOn
                    rvc.paramInterval = self.interval.value
                }
            }
            
            //
            //  ResultViewController.swift
            //  SubmitValue-2
            //
            //  Created by 이형주 on 2022/05/04.
            //
            
            import Foundation
            import UIKit
            
            class RVC: UIViewController {
                
                @IBOutlet var resultEmail: UILabel!
                @IBOutlet var resultUpdate: UILabel!
                @IBOutlet var resultInterval: UILabel!
                
                var paramEmail: String = ""
                var paramUpdate: Bool = true
                var paramInterval: Double = 0
                
                override func viewDidLoad() {
                    self.resultEmail.text = paramEmail
                    self.resultUpdate.text = (self.paramUpdate == true ? "갱신함" : "갱신 안함")
                    self.resultInterval.text = "\(Int(paramInterval))분 마다"
                }
            }
            ```
            
            - 예제 체크포인트
                - 메뉴얼 세그웨이를 실행하는 구문을 사용한다.
                    
                    ```swift
                    performSegue(withIdentifier:sender:)
                    ```
                    
                - 값을 전달하는 코드는 위 메소드가 아니라, ‘세그웨이 실행을 위한 준비 메소드 부분'에 대입한다.
                    - 세그웨이 전처리 메소드를 활용한다.
                    
                    ```swift
                    prepare(for:sender:)
                    ```
                    
                - 세그웨이 방식은 다른 뷰 컨트롤러 인스턴스를 자동으로 생성한다.
                    - 따라서 instantiate 메소드 사용 대신, 위 prepare 메소드의 sender 매개변수를 사용한다. (segue.destination)
                    - 이렇게 생성된 인스턴스 역시 UIVIewController 타입으로 반환되므로, VC2 클래스 프로퍼티 사용을 위해선 다운캐스팅이 필요하다.
    2. 이전 화면에 값 전달
        - 새로운 화면에 전달과 차이
            1. 인스턴스를 생성하지 않고 현재 존재하는 뷰 컨트롤러 인스턴스 참조값을 얻어야 한다.
            (self.presentingViewController / self.navigationViewController?.viewControllers)
            2. 화면 전환 메소드 대신 화면 복귀 메소드를 사용
            3. 값을 받은 뷰 컨트롤러가 화면에 값을 표시하는 시점이 다르다. 
            (viewWillAppear(_:)
        - 예시
            
            ```swift
            //
            //  ViewController.swift
            //  SubmitValue-Back-1
            //
            //  Created by 이형주 on 2022/05/04.
            //
            
            import UIKit
            
            class ViewController: UIViewController {
            
                override func viewDidLoad() {
                    super.viewDidLoad()
                    // Do any additional setup after loading the view.
                }
            
                @IBOutlet var resultEmail: UILabel!
                @IBOutlet var resultUpdate: UILabel!
                @IBOutlet var resultInterval: UILabel!
               
            // 다음 화면의 값들이 지정될지 안될지 모르니 변수 선언때 모두 옵셔널.
                var paramEmail: String?
                var paramUpdate: Bool?
                var paramInterval: Double?
                
            // 화면이 되돌아올 때, VC1은 이미 로딩된 적 있기 때문에 viewDidLoad()로 값전달 불가.
            // 화면이 나타날때마다 전달할 수 있는건 viewWillAppeaer().
            // 위에 값을 전달받을 프로퍼티들을 다 옵셔널했으므로 바인딩해서 사용.
                override func viewWillAppear(_ animated: Bool) {
                    if let email = paramEmail {
                        resultEmail.text = email
                    }
                    if let upDate = paramUpdate{
                        resultUpdate.text = upDate==true ? "자동갱신" : "갱신안함"
                    }
                    if let interval = paramInterval{
                        resultInterval.text = "\(Int(interval))분 마다"
                    }
                }
            }
            
            //
            //  FVC.swift
            //  SubmitValue-Back-1
            //
            //  Created by 이형주 on 2022/05/04.
            //
            
            import Foundation
            import UIKit
            
            class FVC: UIViewController {
                
            // ...중략... //
            
            //submit 버튼을 누르면 VC1으로 값이 전달기 위한 액션메소드 생성
            // 우선 VC1의 뷰 컨트롤러 값을 가져오기 위해 인스턴스 '참조'
            // (여기서 해당 뷰 컨트롤러 이름도 ViewController)
            // 다운캐스팅 필요
                @IBAction func onSubmit(_ sender: Any) {
                    let preVC = self.presentingViewController
                    guard let vc = preVC as? ViewController else {
                        return
                    }
            
            // 참조한 VC1의 프로퍼티에 VC2에서 입력하는 값 대입. 
                    vc.paramEmail = self.email.text
                    vc.paramUpdate = self.isUpdate.isOn
                    vc.paramInterval = self.interval.value
            
            // 화면 전환
                    self.presentingViewController?.dismiss(animated: true)
                }
            }
            ```
            
            - 예시 특징
                - VC1에 미리 전달받을 값들의 변수를 생성할 때, 이전과 달리 값의 유무가 불확실해짐
                    - 변수 생성할 때 모두 옵셔널 설정 필요
                    - 이후 사용할 때 옵셔널 바인딩 필요
                - 전달해줄 대상 뷰 컨트롤러의 인스턴스를 생성이 아니라 ‘찾아오는' 것
                    - 이때도 타입캐스팅 필요. 뷰 컨트롤러는 인스턴스를 생성하든 찾아오든 보통 UIVIewController 타입이 되므로 우리가 원하는 내부의 프로퍼티를 사용하려면 항상 다운캐스팅 해줘야 한다. 다운캐스팅하면 옵셔널바인딩도 해야한다.
- 간접 전달 방식(저장소 사용)
    - AppDelegate 객체 이용
        - 특징
            - AppDelegate 객체는 가장 쉽게 값을 저장할 수 있는 객체
                - 앱 전체를 통틀어 단 하나만 존재해 여러 컨트롤러에서 모두 접근 가능
                - 앱 프로세스의 생성/소멸을 함께해 앱이 종료되지 않는 한 값이 계속 유지
                - (앱이 종료되면 저장된 값도 사라진다.)
            - 위에서 값을 전달받을 곳에 미리 만들어놓는 변수를 이번엔 AppDelegate.swift에 저장.
            - AppDelegate는 앱 전체를 통틀어 하나의 인스턴스만 존재 가능하다.
                - 따라서 새롭게 인스턴스화할 수 없고, 별도의 참조구문이 있다.
                    
                    ```swift
                    UIApplication.shared.delegate
                    ```
                    
                - 이렇게 읽어온 앱 델리게이트 객체는 UIApplicationDelegate 타입이기 때문에 AppDelegate 클래스 타입으로 다운캐스팅 해야한다.
        - 예제
            
            ```swift
            // AppDelegate.swift
            
            // ... 중략 ...
                var paramEmail: String?
                var paramUpdate: Bool?
                var paramInterval: Double?
            
            // FormViewController.swift (VC2)
            
            let ad = 
            ```
            
    - UserDefaults 객체 사용
        - 특징
            - 코코아 터치 프레임워크에서 제공하는 객체
            - 앱을 삭제하기 전까지 반영구적으로 유지된다.
            - 시스템적으로 자동으로 생성하는 단일 객체임으로 별도의 프로퍼티 호출 구문이 있다.
            - 해당 프로퍼티를 사용하는 메소드도 별도로 있다.
                
                ```swift
                // 프로퍼티 호출 구문 : 변수에 대입해 선언한다.
                UserDefaults.standard
                // 값을 저장할 때 변수에 맞게 대입하며 사용한다.
                set(_:forKey:)
                ```
                
        - 예제
