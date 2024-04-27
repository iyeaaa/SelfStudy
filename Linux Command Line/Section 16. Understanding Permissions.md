![[15_Reading_Permissions_1.jpg]]



![[15_Reading_Permissions_2.jpg]]
유닉스 계열 시스템은 여러 사용자가 함께 쓸수있는 시스템이다.


![[15_Reading_Permissions_3.jpg]]


![[15_Reading_Permissions_4.jpg]]


![[15_Reading_Permissions_5.jpg]]

![[15_Reading_Permissions_6.jpg]]

![[15_Reading_Permissions_7.jpg]]

![[15_Reading_Permissions_8.jpg]]



![[15_Reading_Permissions_9.jpg]]


![[15_Reading_Permissions_10.jpg]]

![[15_Reading_Permissions_11.jpg]]


## 권한 정리와 실습

![[15_Reading_Permissions_12.jpg]]
1. 맨 앞이 - 이므로, 파일이다.
2. 이 파일을 읽고 쓸 수 있는 사람은 파일의 소유자밖에 없다. 그룹 멤버나 그 외 사용자들은 어떠한 권한도 없어 r, w, e가 불가능하다. 소유자마저도 실행은 불가능하다.

![[15_Reading_Permissions_13.jpg]]
1. 소유자는 읽기, 쓰기, 실행이 가능하다.
2. 다른사람들은 불가능!

![[15_Reading_Permissions_14.jpg]]
1. 소유자는 읽고 쓰기가 가능하고, 실행은 불가능하다.
2. 그룹 멤버와 그 외 사용자는 파일에 대한 읽기만 가능하다.

![[15_Reading_Permissions_15.jpg]]
1. 시작 글자가 d므로 디렉토리다.
2. 소유자와 그룹멤버는 신규 파일 생성, 삭제가 가능하다.
3. 소유자와 그룹멤버는 실행권한도 있으므로 cd에 대한 접근도 가능하다.
4. 그 외 사용자들은 아무것도 할 수 없다.

![[15_Reading_Permissions_16.jpg]]
1. 사용자는 디렉토리 내부를 읽고, 쓰기가 가능하다.
2. 사용자는 디렉토리 내부에 cd 명령어 등을 통해 접근할 수 있다.
3. 그룹멤버는 접근만 가능하다. ls 명령어 등을 통해 내부를 확인할 수 없다.
4. 그 외 사용자는 어떤것도 불가능하다.