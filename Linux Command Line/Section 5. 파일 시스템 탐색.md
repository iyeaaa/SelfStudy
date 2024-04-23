- [[#Navigation|Navigation]]
	- [[#Navigation#root & home directories|root & home directories]]
	- [[#Navigation#pwd command|pwd command]]
	- [[#Navigation#ls command|ls command]]
	- [[#Navigation#cd command|cd command]]
	- [[#Navigation#relative and absolute paths|relative and absolute paths]]

# Navigation

![[04_Navigation_1.jpg]]


## root & home directories

![[04_Navigation_3.jpg]]
전체 파일 시스템이 The Root Directory에서 시작한다.
윈도우하고는 C, D 드라이브에서 시작하지만, 유닉스 시스템에 있는 모든 파일과 폴더는 Root Directory에서 시작한다.
Root Drectory라고 부르지만 실제 이름은 `'/'` 다.


![[root directory in kali linux.jpg]]
칼리리눅스의 Root Directory
X가 표시된 폴더는 들어가기 위해 권한 인증이 필요하다.


![[04_Navigation_4.jpg]]
공교롭게도 root라는 이름을 가진 디렉토리가 있다. 이는 최상위 디렉토리가 아님에 유의해야한다.
루트 디렉토리라고 하면 일반적으로 최상위 폴더를 가리킴에 주의하자.


![[04_Navigation_5.jpg]]
/home 안에 사용자 관련 정보가 존재한다.
모든 사용자는 각자의 이름으로 된 서브 디렉토리가 있다.

**홈 디렉토리라고 하면 home 폴더가 아닌 그 안에있는 유저 디렉토리를 의미함에 주의하자.**
이 그림에서는 사용자, 즉 홈 디렉토리가 priya, colt, lily 셋이다.
기본적으로 사용자에 대한 모든 자원들이(Documents, Desktop.. ) 사용자 폴더 내에 존재한다.


![[home directory in kali.jpg]]
내 칼리 리눅스의 경우 사용자가 한명이므로, 폴더가 kali 하나다.


![[04_Navigation_6.jpg]]
root, home 디렉토리의 약칭이다.
**여기서 root는 최상위 폴더를 의미한다는 것이고, home은 home이라는 이름을 가진 폴더내의 사용자 폴더를 의미함에 유의하라**


## pwd command

![[04_Navigation_7.jpg]]
현재 위치에 대한 정보, 경로를 보여준다.

```
┌──(kali㉿kali)-[~]
└─$ pwd                     
/home/kali
```


## ls command

![[04_Navigation_8.jpg]]

![[04_Navigation_9.jpg]]

```
┌──(kali㉿kali)-[~/Documents]
└─$ ls -l
total 40
drwxr-xr-x  3 kali kali 4096 Mar 18 03:18 branch-demo
drwxr-xr-x  3 kali kali 4096 Mar 25 02:31 cherry-pick-demo
drwxr-xr-x 17 kali kali 4096 Apr  2 22:10 cnu_os_prac
-rw-r--r--  1 kali kali 2848 Apr 16 05:48 GreatGatsby.txt
drwxr-xr-x  3 kali kali 4096 Mar 18 03:45 merge-demo
-rw-r--r--  1 kali kali   13 Mar 18 03:19 README.md
drwxr-xr-x  2 kali kali 4096 Mar 25 02:39 REAL-CODING
drwxr-xr-x  3 kali kali 4096 Mar 25 02:16 reset-demo
drwxr-xr-x  2 kali kali 4096 Mar 19 10:00 test
drwxr-xr-x  3 kali kali 4096 Mar 18 02:52 working-dir
```

```
┌──(kali㉿kali)-[~/Documents]
└─$ ls -a
.                 cnu_os_prac      README.md    working-dir
..                .git             REAL-CODING
branch-demo       GreatGatsby.txt  reset-demo
cherry-pick-demo  merge-demo       test
```

```
┌──(kali㉿kali)-[~/Documents]
└─$ ls -la
total 52
drwxr-xr-x 11 kali kali 4096 Apr 16 05:48 .
drwx------ 18 kali kali 4096 Apr 23 03:26 ..
drwxr-xr-x  3 kali kali 4096 Mar 18 03:18 branch-demo
drwxr-xr-x  3 kali kali 4096 Mar 25 02:31 cherry-pick-demo
drwxr-xr-x 17 kali kali 4096 Apr  2 22:10 cnu_os_prac
drwxr-xr-x  8 kali kali 4096 Mar 18 03:19 .git
-rw-r--r--  1 kali kali 2848 Apr 16 05:48 GreatGatsby.txt
drwxr-xr-x  3 kali kali 4096 Mar 18 03:45 merge-demo
-rw-r--r--  1 kali kali   13 Mar 18 03:19 README.md
drwxr-xr-x  2 kali kali 4096 Mar 25 02:39 REAL-CODING
drwxr-xr-x  3 kali kali 4096 Mar 25 02:16 reset-demo
drwxr-xr-x  2 kali kali 4096 Mar 19 10:00 test
drwxr-xr-x  3 kali kali 4096 Mar 18 02:52 working-dir
```


## cd command

![[04_Navigation_10.jpg]]

![[04_Navigation_11.jpg]]

## relative and absolute paths

![[04_Navigation_12.jpg]]

![[04_Navigation_13.jpg]]



