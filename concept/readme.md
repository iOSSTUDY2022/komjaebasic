# Part4 흐름 제어 구문

- 구문
    - 단순구문 / 흐름제어구문
    - 흐름제어구문 : 반복문, 조건문, 제어전달문
- 반복문
    1. for in / while
    2. for in / while의 가장 큰 차이? 
        - for in :  횟수에 의한 반복(미리 정해둔 횟수만큼 실행)
        - while : 조건에 의한 반복(조건이 false가 나올 때 까지 실행)
        - while을 사용하는 경우:
            - 실행 횟수가 명확하지 않을 때
            - 직접 실행해보기 전에는 실행 횟수를 알 수 없을 때
            - 실행 횟수를 기반으로 할 수 없는 조건일 때
        - for의 루프 상수 생략 :
            - 순회 대상에 영향을 주기보다, 
            순회 대상의 크기만큼 반복하는 것이 목적인 경우.
            
            ```swift
            let size = 5
            let padChar = "0"  // 문자임 주의
            var keyword = "3"
            
            for _ in 1...size {
            	keyword = padChar + keyword
            }
            print("\(keyword)")
            ```
            
- 조건문
    1. if / guard / switch
        1. if: 조건식이 참일때
        2. guard: 조건식이 틀릴 때 return, 종료시킨다. if와는 달리 참일때 실행할 구문 x. 주로 펑션이나 메서드 안에서 쓰임.
        3. switch: 참/거짓의 조건식이 아니라 여러개의 패턴에 대응할 때. 패턴(경우)가 많을수록 if보다 switch가 적합. 
    2. #available
        - “API가 버전을 탈 때.”, 즉 각 OS의 버전별로 사용할 수 없는 API가 있을 때.
        
        ```swift
        if #available(플랫폼버전, 플랫폼버전2..., *){ // '*' 기호로 배열 종료 알림. 
        	//실행구문
        } else {
        	//대안구문
        }
        
        //예시
        if #available(iOS 9, OSX 10.10, watchOS 1, *){
        	//blabla
        } else {
        	//blabla
        }
        ```
        
    3. switch의 다양한 활용
        - 튜플 비교, 범위연산자 비교, 튜플의 원소별 범위연산자 비교 모두 가능
            
            ```swift
            var value2 = (2, 3)
            
            switch value2{
            case (0..<2, 3):
                print("A")
            case (2..<5, 0..<3):
                print("B")
            case(2..<5, 3...5):
                print("C")
            default:
                print("D")
            ```
            
        - where 구문 추가 : 패턴 확장.
            
            ```swift
            var point = (3, -3)
            
            switch point {
            case let (x, y) where x == y:
                print("\(x)와 \(y)은 x==y 선 상에 있습니다.")
            case let (x, y) where x == -y:
                print("\(x)와 \(y)은 x==-y 선 상에 있습니다.")
            case let (x, y): // 왜 default 대신?
                print("\(x)와 \(y)은 일반 좌표상에 있습니다.")
            }
            ```
            
- 제어 전달문
    - 반복문, 조건문, 함수 등에서 사용되는 네 가지 제어 전달문
        - fallthrough : switch에서 앞 case의 실행을 뒷 case로 넘길 때 사용.
        - return : 함수와 메소드에서 값을 반환하면서 실행 종료.
        - break
        - continue
    - break :
        - switch 또는 반복문에서 종료 명령.
        - switch에서는 다른 언어와 다르게 기본 적용 되므로 보통 생략함.
        - 조건에 맞으면 즉각 종료
        - 반복문에서 활용 가능.
            
            ```swift
            for row in 0...5{
            	if row > 2{
            		break
            	}
            	print("\(row) was executed!")
            }
            
            /*
            0 was executed
            1 was executed
            2 was executed
            */
            ```
            
    - continue :
        - 조건에 맞지 않으면 뒤 아래 실행을 무시하고 위 구문을 반복 실행
        - continue 구문 아래에 있는 나머지 구문들을 실행하지 않을 뿐, 전체 반복은 계속 유지되는 것이 break 문과의 결정적 차이
            
            ```swift
            for row in 0...5{
                if row < 2{
                    continue
                }
                print("\(row) was executed")
            }
            
            /*
            2 was executed
            3 was executed
            4 was executed
            5 was executed
            */
            //만약 여기 break를 넣으면? row가 2보다 작아서 그냥 break.전체 식 종료. 아무것도 print 안됨.
            ```
            
        - 특정 문자만 필터링된 문자열 만들기
            
            ```swift
            var text = "This is a swift book for fucking Apple's programming language"
            var result = ""
            
            for char in text.characters {
                if char == " "{
                    result.append(Character("_"))
                    continue
                } else if char == "f" {
                    result.append(Character("X"))
                    continue
                }
                result.append(char)
            }
            print(result)
            
            // 작동 안됨 ^^;
            ```
            
    - 구문 레이블
        - 반복문이나 조건문을 중첩하여 사용할 때, break나 continue 등을 입력하면 작동하는 범위에 혼동이 올 수 있음. 이를 방지하기 위해 각 구문에 레이블을 달아주자.
            
            ```swift
            레이블이름 : while 조건식 {
            	실행할 구문
            }
            
            break 레이블이름
            continue 레이블이름
            ```
            
            ```swift
            outer : for i in 1...5{
                inner : for j in 1...9{
                    if (j == 3){
                        break outer
                    }
                    print("\(i) X \(j) = \(i * j)")
                }
            }
            
            /*
            1 X 1 = 1
            1 X 2 = 2
            */
            ```
            
            - 밍구형 꿀팀 : 왠먼하면 쓰지말자 ^^ while하고 같이쓰면 성능 엄청 느려진다!
