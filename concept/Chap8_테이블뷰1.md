1. 테이블 뷰
    - 목록 형태의 콘텐츠를 화면에 표현
    - 테이블 뷰 컨트롤러와 네비게이션 뷰 컨트롤러는 계층적 성격의 콘텐츠를 표현하기 위해 상호 보완적이다.
    - 데이터 접근 구조를 고려해 목록을 설계해야 한다.
        - 가장 효율적인 정보 접근 방법은 콘텐츠를 성격에 따라 계층으로 구조화하는 것.
        - 선택도 : 데이터베이스의 설계 원리 중 더 적은 횟수의 선택 과정으로 원하는 정보를 찾을 수 있게 하기.
        
2. 테이블 뷰 컨트롤러
    - 화면 전체가 목록으로 이루어진 인터페이스를 구현할 때 사용
    - 구성단위
        - 테이블 뷰 컨트롤러 → 하나의 테이블 뷰 → 여러 개의 테이블 뷰 섹션 → 여러 개의 테이블 뷰 셀 -> 테이블 뷰 셀마다 하나씩의 콘텐츠 뷰
    - UITableViewController 클래스로 구성
    
3. 프로토타입 셀
    - 테이블 뷰의 셀을 원하는 대로 쉽게 디자인할 수 있도록 해주는 객체
    - 정적인 객체로 화면에 존재하는 것이 아니라, 설계와 초기 원형으로만 존재
    - 이를 통해 내부 구현된 객체들까지 모두 동적 객체가 된다.
    (스토리보드에서 프로토타입 셀을 아울렛 변수로 드래그로 설정할 순 없다)
    - Cell Content : 셀에 표현되는 콘텐츠 부분
    - Accessory View : 콘텐츠의 부가 정보 여부 암시
    - 프로토타입 셀을 이용해 테이블 뷰 만들기
        - 4가지 기본 스타일 제공: Basic, Right Detail, Left Detail, Subtite
        - 프로토타입 셀은 실제로 화면에 표시되는 컨트롤이 아니다.
        - 셀 자체에 콘텐츠를 올리는 것이 아니라, 틀을 바탕으로,
        셀을 목록의 개수만큼 생성해 각각에 데이터를 바인딩하여 구현
        - 아울렛 변수를 연결하지 않고 스토리보드에서 아이디를 부여한다.
        
4. 데이터 소스
    - 정적인 방법 : 테이블 뷰 셀 각각을 스토리보드에서 직접 구성한 것
    - 동적인 방법 :
        - 고정되지 않고 매번 갱신되는 내용을 표현하기 위해 프로그래밍적으로 구성
        - 테이블 뷰의 각 행마다 대응할 수 있는 배열 형태의 데이터 소스 필요
        - 데이터 소스를 테이블 뷰 각 행에 연결하는 과정 → 데이터 바인딩
    - VO 패턴
        - Value Object Pattern
        - 변수를 담은 클래스가 있는 일종의 식판.
        - 값을 주고받을 때 VO 클래스 인스턴스 자체를 전달한다.
        - 각 변수에 저장된 값들의 관련성이 유지되고 여러개의 변수가 필요하지 않다.
        - 예시
            
            ```swift
            //
            //  MovieVO.swift 새로운 파일을 만들어 패턴 작성
            //  MyMovieChart-1
            //
            //  Created by 이형주 on 2022/05/12.
            //
            
            import Foundation
            
            class MovieVO {
                var thumbnail: String?
                var title: String?
                var description: String?
                var moreInfo: String?
                var releaseDate: String?
                var rating: Double?
            }
            ```
            
        - 활용1
            
            ```swift
            // 본 파일
            
            class ListViewController: UITableViewController {
            
            // MovieVO 타입의 배열을 선언하고 초기화한다. 
            // 앞으로 데이터를 넣을 리스트.
            	var list = [MovieVO]()
            
            // 뷰가 로딩되었을 때 데이터 삽입 실행
            override func viewDidLoad() {
            
            // MovieVO의 변수들을 사용하기 위해 초기화
            // 식판에 변수들 할당
            	var mvo = MovieVO()
            	mvo.title = "다크나이트"
            	mvo.description = "어쩌고저쩌고"
            	...
            // 이렇게 만든 새로운 VO 인스턴스를 list 배열에 넣기
            	self.list.append(mvo)
            
            // 두 번째부턴 var 없이 초기화
            // 위에서 넣은 값을 대체하면 안되기 때문에(클래스는 참조 타입이라 값 대체됨)
            // 참조 주소를 다르게 만들기 위해 다시 초기화.
            	mvo = Movie()
            	mvo.title = "다른 영화"
            	mvo.description = "어쩌고저쩌고2"
            	...
            	self.list.append(mvo)
            	
            	...
            }
            
            ```
            
        - 활용2 : 리팩토링
            - 데이터 세트를 구성할 때에는 가급적 프로그래밍 로직이 포함되지 않는 것이 좋다.
            - 데이터를 단순 나열하고 묶을 때에는 튜플이 가장 편리.
            
            ```swift
            class ListViewController: UITableViewController {
            
            var dataSet = [
                ("다크나이트", "어쩌고저쩌고", "2008-09-10", 8.95, "darknight.jpg"),
                ("howoo", "어쩌고저쩌고2", "2008-10-10", 7.33, "rain.jpg"),
                ("The Secret", "어쩌고저쩌고3", "2010-10-10", 5.95, "secret.jpg")
                ]
            
            // MovieVO 타입의 배열 타입의 list 객체 생성?
            // lazy 키워드 : 두 가지 이유
            // 1. 미리 생성하지 않아 메모리 낭비 방지(변수가 참조되는 시점에 초기화)
            // 2. 프로퍼티 밖의 다른 프로퍼티 참조 가능(여기선 dataSet)
            lazy var list: [MovieVO] = {
            
            // VO 인스턴스를 담을 객체 생성?
                    var dataList = [MovieVO]()
            
            // 순회구문을 통해 데이터 값넣기
            // 인자레이블 만들고, 이를 dataSet 에 할당되게 한다. 
                    for (title, desc, releaseDate, rating, thumbnail) in self.dataSet {
            // 객체를 새로 또 만들어주고...
                        let mvo = MovieVO()
                        mvo.title = title
                        mvo.description = desc
                        mvo.releaseDate = releaseDate
                        mvo.rating = rating
                        mvo.thumbnail = thumbnail
            // dataList에 각 데이터를 할당한 VO 객체를 대입. 
                        dataList.append(mvo)
                    }
            // 이렇게 만든 dataList를 순환구문의 결과값으로 반환...
                    return dataList
                }()
            ```
            
    - 테이블 뷰와 데이터 소스 연동
        - 두 가지 필요 요소
            1. 테이블이 몇 개의 행으로 구성되는가? → tableView(_:numberOfRowsInSection:)
            2. 각 행의 내용은 어떻게 구성되는가? → tableView(_:cellForRowAt:)
            - 동작/이벤트는 아니지만 델리게이트 패턴과 동일한 방식→ 필요에 의해 호출한다.
            - 이미 UITableView 클래스에 구현되어 있으므로 override 한다.
        - tableView(_:numberOfRowsInSection:)
            - 테이블 뷰를 구성하기 위해 가장 먼저 호출
            - 테이블 뷰가 생성해야 할 행(row)의 개수를 반환
            - 두 개의 인자값
                1. tableView(테이블 뷰 객체 정보) : 테이블 뷰가 여러개일 때에도 같은 메소드를 호출하기 때문에 구분 필요.
                2. section(섹션 정보) : 섹션별로 행의 개수를 다르게 할 수 있기 때문.
            - 테이블 뷰를 구성하는 행의 개수는 데이터 소스의 크기와 일치해야 한다.
            - 일일이 입력하는 하드 코딩 말고, 데이터 소스의 크기가 바뀔 때마다 반환값이 함께 바뀌는 처리가 필요
            - .count : 배열 타입 객체의 길이를 가져온다. → 데이터 소스 전체의 크기를 파악한다.
        - tableView(_:cellForRowAt:)
            - 각 행이 화면에 표현해야 할 내용을 구성하는데 필요
            - 전체 테이블 뷰 목록이 아니라 개별적인 테이블 셀 객체를 반환하기 때문에 목록의 수만큼 반복 호출된다.
            - 메소드 내에서 셀 객체를 구성한 다음 반환하면, 시스템은 이 객체를 목록 각 행에 채워 넣는 방식
            - 두 개의 인자값
                1. tableView(테이블 뷰 객체 정보) : 테이블 뷰를 특정한다. 
                2. indexPath(구성할 행 참조 정보) : 매개변수인 indexPath를 통해 몇 번째 행을 구성하기 위한 호출인지 구분한다. 
                    - indexPath 타입
                        - 선택된 행에 대한 관련 속성들을 모두 제공한다.
                        - .row 속성을 사용해 행의 번호를 알려준다. 
                        → 0 부터 시작하는 행의 번호는 데이터소스 배열의 아이템 인덱스와 대부분 일치한다.
        - tableView(_:didSelectRowAt:)
            - 사용자 액션 처리
            - 사용자가 목록 중에서 특정 행을 선택했을때 내용에 맞는 액션을 처리한다.
            - 두 개의 인자값
                1. tableView: 사용자가 터치한 테이블 뷰 참조값
                2. indexPath: 터치된 행에 대한 정보
        - dequeueReusableCell(withIdentifier:)
            - 객체의 직접생성 대신 간접 생성
            - 인자값으로 받은 아이디로 스토리보드에서 정의된 프로토타입 셀을 찾아 인스턴스를 만든다.
            - 재사용 큐(Reusable Queue)
                - 메모리의 부담을 줄이기 위해 현재의 화면에 표시되어야 하는 만큼만 셀을 생성하는데, 이를 위해 셀 객체를 임시로 저장하는 공간.
                - 여기선 한 차례 사용된 테이블 셀 인스턴스가 폐기되지 않고 재사용을 위해 대기하는 공간
            - 해당 아이디의 프로토타입 셀이 존재하지 않을 수 있기에 결과는 옵셔널 타입 반환.
        - 재사용 큐(Reusable Queue) :
        - 예시
            
            ```swift
            override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                    return self.list.count
                }
                
                override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            // 몇 번째 행을 구성해야 하는지 indexPath.row로 파악
                    let row = self.list[indexPath.row]
            
            // id가 ListCell인 프로토타입 셀 인스턴스 간접 생성
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell")!
            
            // 셀에서 제목을 표시하기 위해 UITableViewCell 속성인 .textLable 사용. 
            // 커스텀타입이라면 textLable 속성 적용 안돼서 옵셔널. 
                    cell.textLable?.text = row.title
            // 테이블 뷰 셀 스타일이 Subtitle 등 일 경우 .detailTextLable 사용
                    cell.detailTextLable?.text = row.description
                    
                    return cell
                }
                
                override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                    NSLog("선택된 행은 \(indexPath.row)번째 행 입니다.")
                }
            ```
            
    
- 커스텀 프로토타입 셀
    - 위의 방법은 Table View Cell을 Basic 또는 Subtitle 스타일로 설정해놓은 것. 애플에서 제공하는 프로토타입을 따라 만드는 것.
    - 우리가 원하는대로 lable 등의 위치를 구현하기 위해선 Custom 스타일 설정.
    - 커스텀타입 프로토타입 셀 소스코드 참조 방법 두 가지
        1. 태그 속성갑 이용
            
            1.  스토리보드에서 테이블뷰셀 안의 각 객체에 태그값 부여
            
            1. viewWithTag(_:) 메소드를 이용해 객체 소환
            2. 반환된 객체를 적절한 객체(UILable)로 캐스팅.
            반환값이 옵셔널임에 주의.
            - 예시
                
                ```swift
                    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
                        let row = self.list[indexPath.row]
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell")!
                
                // 스토리보드에서 미리 지정해놓은 태그 번호(101 등)을 사용해 표시될 레이블을 변수로 받음
                // viewWithTag는 레이블, 버튼 등 모두 사용 가능하게 UIView 타입을 반환함. 
                // 따라서 우리가 text를 입력하는 등의 속성을 사용하려면 UILable로 케스팅 필요.
                let title = cell.viewWithTag(101) as? UILable
                let desc = cell.viewWithTag(102) as? UILable
                let releaseDate = cell.viewWithTag(103) as? UILable
                let rating = cell.viewWithTag(104) as? UILable
                
                title?.text = row.title
                desc?.text = row.description
                releaseDate?.text = row.releaseDate
                rating?.text = "\(row.rating!)"
                
                        return cell
                    }
                ```
                
        2. 아울렛 변수 참조(커스텀 클래스로 프로토타입 셀의 객체 제어)
            - 뷰 컨트롤러 커스텀 클래스가 아닌, 프로토타입 셀 커스텀 클래스 생성 → 아울렛 변수 추가
            - 아울렛 변수를 뷰 컨트롤러에 직접 정의하면 셀 내부 객체들이 정적인 객체가 되므로 사용하는데 문제가 생기지만, 프로토타입 셀을 연결한 커스텀 클래스에 아울렛 변수를 정의하면 동적으로 사용할 수 있는 객체가 되기 때문에 아울렛 변수를 통해 객체를 관리할 수 있다.
            1. 원하는 객체를 프로토타입 셀에 추가한다.(Lable 등)
            2. 새로만든 UItableViewCell 타입 클래스에 아울렛 변수를 등록한다. 
            3. 본래 메인 클래스에서 아울렛 변수를 제어한다.
            - 예시
                
                ```swift
                override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                        let row = self.list[indexPath.row]
                
                // 이전엔 재사용 큐로부터 셀 객체를 가져올 때 옵셔널만 해제해서 가져왔는데(기본 UITableViewCell 타입)
                // 여기선 커스텀 셀의 클래스를 새로만든 UItableViewCell 타입 클래스(MovieCell)에 연결했음
                // 해당 클래스에 정의된 속성(아울렛 변수들)을 사용하려면 타입캐스팅 필요
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell
                        
                        cell.title?.text = row.title
                        cell.desc?.text = row.description
                        cell.releaseDate?.text = row.releaseDate
                        cell.rating?.text = "\(row.rating!)"
                
                        return cell
                    }
                ```
                
    - 썸네일 추가하기
        - Resources 그룹을 만들고 이미지 파일들 추가
        - 스토리보드의 커스텀셀에 Image View 추가
            - UIImageView는 이미지를 입력받고 화면에 표시하는 객체
            - UIImage는 이미지 데이터를 저장하는 객체
            - 이미지를 표시하는 작동 순서
                1. 이미지를 담아 UIImage 객체를 만든다. 
                var img = UIImage(named: 경로)
                2. 담은 객체를 UIImageView 객체의 .image 속성에 대입한다.
                cell.thumbnail.image = UIImage(named: row.thumbnail!)
        - UIImage(named:) vs UIImage(contentsOfFile:)
            - UIImage(named:)
                - 한번 읽어온 이미지를 메모리에 저장해둔 다음, 두 번째 호출부터는 메모리에 저장된 이미지를 가져온다. (캐싱)
                - 저장된 메모리는 이미지객체 사용 후에도 잘 해제되지 않는다.
                - 메모리 점유 위험 있음.
            - UIImage(contentsOfFile:) :
                - 생성자를 사용해서 이미지 객체를 생성한다.
                - 캐싱되지 않는다.
                - 데이터를 매번 다시 읽어와야 함으로 성능이 저하될 수 있다.
        - 예시
            
            ```swift
            lazy var list: [MovieVO] = {
                    var dataList = [MovieVO]()
                    for (title, desc, releaseDate, rating, thumbnail) in self.dataSet {
                        let mvo = MovieVO()
            
            				// ... 중략 ...
                        mvo.thumbnail = thumbnail
            
                        dataList.append(mvo)
                    }
                    return dataList
                }()
            
            override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                    let row = self.list[indexPath.row]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell
                    
            				// ... 중략 ...
            
                    cell.thumbnail.image = UIImage(named: row.thumbnail!)
            
                    return cell
                }
            ```
            
1. 테이블 뷰 행 높이 조정하기
    - 행 높이 조절 방식
        1. 모두 동일한 높이를 갖는 방식
            - UITableView의 .rowHeight 속성
                - self.tableView.rowHeight
                - 모든 행 높이를 일괄로 제어
        2. 각 셀마다 다른 높이를 갖는 방식
            - tableView(_:estimatedHeightForRowAt:)
                - 해당 메소드가 구현되면 속성값 변경구문은 무효됨
                - 각각의 행 높이를 다르게 제어 가능
                - 두 번째 인자값으로 IndexPath 타입의 행 정보를 받아 알맞은 높이값을 반환한다.
            - tableView(_:heightForRowAt:)
                - 가로 행에 대한 정보를 인자값으로 받고, 그 행의 높이를 계산식을 입력해 반환한다.
                - 예시
                    
                    ```swift
                    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                            let row = self.list[indexPath.row]
                            
                    // CGFloat 는 메소드의 반환 타입을 정수로 일치시킨다.
                            let height = CGFloat(60 + (row.count / 30) * 20)
                            return height
                        }
                    
                    // 늘어나는 행 높이에 맞게 내부 레이블객체의 행이 늘어나지 않는다. 
                    // numbersOfLine 속성 사용
                    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
                            cell.textLabel?.text = list[indexPath.row]
                            cell.textLabel?.numberOfLines = 0
                            return cell
                        }
                    ```
                    
        3. 동적으로 Self-Sizing Cell 구현하기
            - 콘텐츠에 따라 자동으로 높이 조절
            - 두 가지 사용 요소
                - estimatedRowHeight 프로퍼티
                    - 셀 전체의 높이를 결정하기 전에 임시로 사용할 셀의 높이
                - UITableView.autoaticDimension 객체
                    - row 속성에 대입되어 높이값이 동적으로 설정될 것을 테이블 뷰에 알려준다.
            - 예시
                
                ```swift
                // 앞의 tableView(:heightForRowAt) 대체
                
                override func viewWillAppear(_ animated: Bool) {
                        self.tableView.estimatedRowHeight = 50
                        self.tableView.rowHeight = UITableView.automaticDimension
                    }
                ```
                
    - 
2. A ?? B
    - A가 nil이 아닐 경우 옵셔널 해제, nil일 경우 B 값 사용
    - B는 일반 값이며 A의 옵셔널을 해제한 타입과 일치해야 한다.
