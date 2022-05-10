# 7강 델리게이트 패턴

1. 기본 개념
    - 위임 패턴
    - 패턴 : 반복해서 나타나는 사건이나 형태
    - 디자인 : 객체지향 프로그래밍에서 구조적 설계
    - 디자인 패턴
        - 설계에 관한 문제를 해결하기 위해 객체들의 관계를 구조화한 사례가 일반화된 것.
        - 델리게이트 패턴, 싱글톤 패턴, 옵저버 패턴 등 매우 많은 종류.
    - 델리게이트 패턴
        - 객체지향 프로그래밍에서 처리해야 할 일 중 일부를 다른 객체에게 넘기는 것.
        - 대부분 GUI 기반 프로그래밍에서 일반적으로 사용된다.
        - 특정 이벤트가 발생했을 때 알려주기 위해 델리게이트 메소드를 사용한다.
        - iOS에서 델리게이트 패턴을 사용하는 모든 객체는 델리게이트 메소드를 정의한 프로토콜을 가진다.
        - 델리게이트 메소드를 이용하려면 프로토콜을 구현하는 과정이 필요하다.
        - 델리게이트 프로토콜은 보통 객체 뒤에 Delegate를 붙여서 정의한다.
2. 텍스트 필드 예시
    - 텍스트필드 속성 변경
        - 어트리뷰터 인스펙터 탭에서  설정
        - 변수.borderStyle = UITextField.BorderStyle .none / .line / .bezel / .roundedRect
        - 등등 너무 많음...
    - 최초 응답자
        - UIWindow가 이벤트 발생 시 우선적으로 응답할 객체
        - 특정 객체를 최초 응답자로 만들고 싶을 땐 객체의 becomeFirstResponder() 호출
        - 최초 응답자를 해제하고 싶을 땐 resignFirstResponder() 호출
        - 예시
            
            ```swift
            let tf = UITextField()
            // 최초응답자 설정
            tf.becomeFirstResponder()
            // 최초응답자 해제
            tf.resignFirstResponder()
            ```
            
        - 주로 프로세스상에서 텍스트 필드를 직접 입력 준비 상태로 만들어주어야 할 때 사용
    - 텍스트필드에 델리게이트 패턴 적용하기
        1. 메인 뷰컨트롤러 클래스에 UITextFieldDelegate 프로토콜 추가
        2. override viewDidLoad에 self.tf(텍스트필드 객체).delegate = self 대입
            1. 즉 이곳의 텍스트필드 객체에 델리게이트를 설정하는데, 이걸 뷰 컨트롤러(self)에게 알려준다는 뜻
            2. “뷰 컨트롤러가 텍스트 필드의 델리게이트 객체로 지정되었다.”
            3. “뷰가 메모리에 올라온 상태에서야 텍스트필드가 초기화가 되고, 그 후에 델리게이트를 선언할 수 있는 것. 그래서 뷰디드로드 안에다가 설정하는 것”
        3. ViewController에 델리게이트 메소드들 추가
        4. 텍스트필드에 숫자차단 + 최대입력가능길이 제한 기능 설정 예시
            
            ```swift
            //
            //  ViewController.swift
            //  Delegate-TextField-1
            //
            //  Created by 이형주 on 2022/05/06.
            //
            
            import UIKit
            
            class ViewController: UIViewController, UITextFieldDelegate {
            
            // 갖은 속성설정들... viewDidLoad에...
                override func viewDidLoad() {
                    super.viewDidLoad()
                    self.tf.placeholder = "값을 입력하세요"
                    self.tf.keyboardType = UIKeyboardType.alphabet
                    self.tf.keyboardAppearance = UIKeyboardAppearance.dark
                    self.tf.returnKeyType = UIReturnKeyType.join
                    self.tf.enablesReturnKeyAutomatically = true
                    
                    self.tf.borderStyle = UITextField.BorderStyle.line
                    self.tf.backgroundColor = UIColor(white: 0.87, alpha: 1.0)
                    self.tf.contentVerticalAlignment = .center
                    self.tf.contentHorizontalAlignment = .center
                    self.tf.layer.borderColor = UIColor.darkGray.cgColor
                    self.tf.layer.borderWidth = 2.0
            
            // 어플 열자마자 최초응답자 되서 키보드 튀어나오게... 
                    self.tf.becomeFirstResponder()
            // 핵심. 뷰 컨트롤러를 델리게이트 객체로 지정. 
                    self.tf.delegate = self
                }
            
                @IBOutlet var tf: UITextField!
            
                func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                    print("The text field contents will change as \(string)")
                    if Int(string) == nil {
                        if (textField.text?.count)! + string.count > 10  {
                            return false
                        } else {
                            return true
                        }
                    } else {
                        return false
                    }
                }
                func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                    textField.resignFirstResponder()
                    print("The return key in the text field was clicked")
                    return true
                }
            }
            ```
            
3. 이미지 피커 컨트롤러
    - 이미지 피커 컨트롤러가 호출하는 델리게이트 메소드
        - imagePickerController(_:didFinishPickingMediaWithInfo:)
            - 이미지 피커 컨트롤러에서 이미지를 선택하거나 카메라 촬영을 완료했을 때 호출되는 메소드.
            - 첫번째 인자값은 이미지피커컨트롤러 객체, 두 번째 인자값은 원하는 이미지에 대한 데이터(종합 정보) → 딕셔너리 형태로 전달.
        - imagePickerControllerDidCancel(_:)
            - 이미지 피커 컨트롤러 실행 후 이미지 선택 없이 취소했을 때 호출
    - 예시
        
        ```swift
        //
        //  ViewController.swift
        //  Delegate-ImagePicker-1
        //
        //  Created by 이형주 on 2022/05/06.
        //
        
        import UIKit
        
        class ViewController: UIViewController {
        
            override func viewDidLoad() {
                super.viewDidLoad()
                // Do any additional setup after loading the view.
            }
            @IBOutlet var imgView: UIImageView!
        
        // 버튼을 누르면 이미지 선택 실행되도록. 우선 컨트롤러 할당. 
            @IBAction func pick(_ sender: Any) {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.allowsEditing = true
        // 필수. 
                picker.delegate = self
        // 이미지피커 실행
                self.present(picker, animated: true)
            }
            
        
        }
        
        // 원래 메인 ViewController에 추가하던 프로토콜을 익스텐션으로 뺐음. 보기좋게.^^
        extension ViewController: UIImagePickerControllerDelegate {
        
        // 이미지피커 컨트롤러가 실행되고 종료됐을 때 알람뜨게. 
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 이미지피커가 종료되는 시점과 알람이뜨는 시점이 겹칠 수 있으므로, 
        // 이미지피커 종료의 두번째 인자값 complete을 트레일링클로저로 받아 그 안에 알람실행구문 삽입.
                picker.dismiss(animated: true){ () in
                    let alert = UIAlertController(title: "", message: "이미지 선택이 취소되었습니다.", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "cancel", style: .cancel)
                    alert.addAction(cancel)
                    self.present(alert, animated: true)
                }
            }
        
        // 이미지피커에서 이미지를 선택했을 때    
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 역시 우선 이미지피커창 종료해야함. 그리고 트레일링클로저로 다음작업구문 삽입.
                picker.dismiss(animated: true) {() in
        // 그다음, 선택한 이미지값을 받는 방법 -> 지금 사용하는 메소드의 두번째 인자값의 딕셔너리 키 값을 이용하는 것.
        // 근데 얘네가 또 any값으로 반환됨. 따라서 UIImage로 타입캐스팅 필요.
                    let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        // 그렇게 불러온 이미지를 우리가 만들어놓은 이미지뷰 아울렛에 넣으면 끝.
                    self.imgView.image = img
                }
            }
        }
        
        // 왠지 모르겠는데 이거 없으면 위에 picker.delegate = self, 즉 델리게이트 할당부터가 안됨.
        // -> 화면 전환을 위해 필요.
        // weak open var delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?
        extension ViewController: UINavigationControllerDelegate {
            
        }
        ```
        
        - PHPicker는  UINavigationControllerDelegate 상속 안받음.
