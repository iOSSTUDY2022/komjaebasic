# 6강 메세지 전달

- 메세지 전달 방법
    1. 메세지창(알림창)(앱 사용중에만)
    2. 로컬 알림
    3. 서버 알림(푸시 알림)
1. 메세지창(알림창)
    - UIAlertController
        - 알림창.alert 와 액션시트.actionSheet 두 가지 형태.
        - 순서
            1. UIAlertController를 통해 메세지창 컨트롤러 인스턴스를 생성해준다.
            2. UIAlertAction를 통해 컨트롤러에 들어갈 버튼 액션 객체를 생성한다.
            3.  1번에서 만든 인스턴스 객체에 .addAction을 통해 2번에서 만든 버튼 액션 객체를 추가한다.
            4. self.present( 1번에서만든객체, animated: false) 로 메세지창 컨트롤러를 표시한다.
        - 예시
            
            ```swift
            // 메세지창의 가장 기본 구문
            let alert = UIAlertController(title: "알림", 
            															message: "안뇽", 
            															preferredStyle: UIAlertController.style.alert)
            															// 근데 보통 앞에 생략하고 .alert로 사용
            let cancel = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel)
            															// 마찬가지. 그냥 .cancel로 사용
            alert.addAction(cancel)
            self.present(alert, animated: true)
            ```
            
        - viewDidlAppear
            - 화면이 뜨자마자 자동으로 메세지 창을 띄워주어야 할 때.
            - viewDidLoad는 뷰가 화면에 구현되기 전에 메세지창 작동을 시도하므로 오류남.
            - viewDidAppear는 로딩이 아닌 구현 후 작동.
        - 텍스트필드창 추가
            - addTextField : addAction(’작동변수’) 대신 바로 대입, 원하는 속성은 트레일링클로저로.
                
                ```swift
                alert.addTextField(){ (tf) in
                	tf.placeholder = "암호"
                	tf.isSecurityTextEntry = true 
                }
                ```
                
            - 텍스트필드에 입력한 값 읽어오기
                - 알람객체.textFields 사용
                - addTextField 로 생성한 텍스트필드는 배열 순서를 배정받는다. 해당 순서로 소환가능.
                - textFields는 옵셔널 타입.
                
                ```swift
                // ...중략...
                let ok UIAlertAction(title: "확인", style: .default { (_) in
                	if let tf = alert.textFields?[0] {
                		print("입력값은 \(tf.text!) 입니다."
                	} else {
                		print("입력값이 없습니다.")
                	}
                }
                // ...
                ```
                
2. 로컬 알림
    - iOS 스케줄러에 의해 발송.
    - 앱 내부에서 미리 메세지를 구성한 후 발송된 시각을 iOS 스케줄러에 등록해 두면 해당 시각에 맞추어 자동으로 발송된다.
    - 주로 앱을 종료하거나 백그라운드로 갈 때 앱에 대한 주의 환기를 목적으로 사용한다.
    - 스케줄링을 위해서도 사용. ex) 아이폰의 미리알림.
    - UserNotification 프레임워크 사용
        - import UserNotifications
        - 해당 프레임워크의 대표적인 4개 객체
            1. UNMutableNotificationContent
                - 알림 콘텐츠
                - title, subtitle, badge, sound 등 설정
            2. UNTimeIntervalNotificationTrigger
                - 알림 발송 조건
                - 발생 시각과 반복 여부 설정.
                - 초 단위 기준 입력.
                    - 하루의 특정 시간에 맞추고 싶다면 UNCalendarNotifiactionTrigger 사용.
            3. UNNotificationRequest
                - 알림 요청 객체 생성
            4. UNUserNotificationCenter
                - 실제 방송을 담당하는 센터
                - 싱글턴 방식이라 새로운 객체 생성 안됨. .current() 메소드로 참조 정보만 가져온다.
    - AppDelegate 파일의 application(didFinishLauchingWithOption)에 코드 추가
        - 앱이 실행되자마자 알람을 받을건지 설정을 물어보는 내부 알람을 만들어야함.
        
        ```swift
        //
        //  AppDelegate.swift
        //  Msg-Notification-1
        //
        //  Created by 이형주 on 2022/05/05.
        //
        import UIKit
        import UserNotifications
        
        @main
        class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
        
        // AppDelegate 파일의 application(didFinishLauchingWithOption)
            func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // iOS 버전 10.0 이상부터만 UserNotification 파운데이션 사용가능. 따라서 구분 필요.
        // 센터 인스턴스 참조해주고, 설정들 해주기.  
                if #available(iOS 10.0, *) {
                    let noticenter = UNUserNotificationCenter.current()
                    noticenter.requestAuthorization(options: [.alert, .badge, .sound]) { (didAllow, e) in }
                    noticenter.delegate = self
                } else {
                    
                }
                return true
            }
        ```
        
    - SenceDelegate 파일의 SceneWillResignActive(_:)에 코드 추가
        - 앱이 비활성화됐을 때 로컬알림 실행.
        - 이전 AppDelegate 파일의 applicationWillResignActive(_:)는 없어짐.
        
        ```swift
        //
        //  SceneDelegate.swift
        //  Msg-Notification-1
        //
        //  Created by 이형주 on 2022/05/05.
        //
        func sceneWillResignActive(_ scene: UIScene) {
        
                if #available(iOS 10.0, *){
        	// didFinishLauchingWithOption에서 requestAuthorization을 통해 물어봤던
        	// 사용자 동의 여부 확인
                    UNUserNotificationCenter.current().getNotificationSettings { settings in
                        if settings.authorizationStatus == UNAuthorizationStatus.authorized {
        	// 앱 종료 후 나타날 알림 콘텐츠 설정
                            let nContent = UNMutableNotificationContent()
                            nContent.badge = 1
                            nContent.sound = .default
                            nContent.title = "Local Alarm mesaage"
                            nContent.subtitle = "Where have you gone?"
                            nContent.body = "Please come back"
                            nContent.userInfo = ["name":"LEE"]
        	// 시간 정하고        
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        	// 위의 설정들 사용해서 알림 요청하고
                            let request = UNNotificationRequest(identifier: "wakeup", content: nContent, trigger: trigger)
        	// 소환해서 .add 메소드로 뾰로롱                 
                            UNUserNotificationCenter.current().add(request)
                        } else {
                            print("Not allowed")
                        }
                    }
                } else {
                    // iOS 10.0 버전 이하를 위한 UILocalNotification 구문
                }
            }
        ```
        
    - 받은 알림 처리하기
        - UserNotification 프레임워크의 델리게이트 패턴 사용
            - 알림메세지 클릭 이벤트를 앱 델리게이트 클래스가 감지할 수 있게 하기
                - AppDelegate 클래스에 UNUserNotificationCenterDelegate 프로토콜 추가
                - application(_:didFinishLauchingWithOption) 마지막줄에 
                notiCenter.delegate = self 추가
                - 아래 두 개의 메소드는 이 프로토콜의 메소드들
        - userNotificationCenter(_:willPresent:withCompletionHandler:)
            - 앱이 실행되는 도중에 알림 메세지가 도착할 경우 실행
            - 앱 실행중에도 알림 배너를 표시하고 싶을 때.
            - 예시
                
                ```swift
                //  자동생성 중에서 willPresent 으로 고르면 된다. 
                func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
                
                // 위에서 저장했던 알림의 id 사용(여기선 wakeup)
                // 복잡해보이는 주소도 다 위에서 사용한 메소드와 프로퍼티 소환하는 것.
                // 여기서 notification은 방금 willPresent에서 사용한 인자
                        if notification.request.identifier == "wakeup" {
                            let userInfo = notification.request.content.userInfo
                // 위에서 userInfo에 저장했던 배열의 키 값 사용
                            print(userInfo["name"]!)
                        }
                // 알림 배너 띄워주기. 생략하면 작동 안함.
                        completionHandler([.alert, .badge, .sound])
                    }
                ```
                
        - userNotificationCenter(_:didReceive:withCompletionHandler:)
            - 알림 메세지를 실제로 클릭하면 실행
            - 앱 실행여부와 상관 없음
            - 예시
                
                ```swift
                //  자동생성 중에서 didReceive 로 고르면 된다. 
                func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
                        if response.notification.request.identifier == "wakeup"{
                            let userInfo = response.notification.request.content.userInfo
                            print(userInfo["name"]!)
                        }
                        completionHandler()
                    }
                ```
                
    - 미리알림 기능 구현
        - DispachQueue.main.async
            - 백그라운드에서 실행되는 로직을 메인 쓰레드에서 실행되도록 처리해주는 역할.
        - timeIntervalSinceNow
            - datepicker.date 의 속성.
            - 발송시각을 ‘지금으로부터 *초 형식'으로 변환.
        - addingTimeInterval
            - datapicker는 세계표준시 기준. 우리나라 시간으로 맞추려면 해당 메소드를 사용해 9시간 더해줘야 한다.
            - 입력값의 단위는 초이므로 9 * 60 * 60
