

# Python 예제

```
import reedsolo  

# 오류 정정 바이트 수
RSC_LEN = 4  

# utf-8 문자열 생성
text = '🐯사용자 입력!💻'
byte_hex = text.encode('utf-8')  
string_hex = byte_hex.hex().upper()  

# 리드 솔로몬 인코딩
rsc = reedsolo.RSCodec(RSC_LEN)  
byte_rsc = rsc.encode(byte_hex)  

# 송신자의 문자열
string_rsc = byte_rsc.hex().upper()  

# 수신자의 문자열
client_string_rsc = string_rsc  

# 에러 생성
client_string_list = list(client_string_rsc)  
client_string_list[2] = 'a'  
client_string_list[5] = 'e'  
client_string_rsc = ''.join(client_string_list)  

# 리드 솔로몬 디코드
client_byte_hex = bytes.fromhex(client_string_rsc)  
client_rsc = reedsolo.RSCodec(RSC_LEN)  
client_byte = client_rsc.decode(client_byte_hex)[0]  
client_text = client_byte.decode('utf-8')  

# 확인
print(client_text)
```


## 오류 정정 코드 확인

```
인코딩 전
F09F90AFEC82ACEC9AA9EC9E9020EC9E85EBA0A521F09F92BB

인코딩 후
F09F90AFEC82ACEC9AA9EC9E9020EC9E85EBA0A521F09F92BB19F7312E
```

인코딩하면 RSC_LEN(N-K = 4)에 해당하는 바이트만큼 추가된다. 

RS Code : 19F7312E
- (N-K)/2 = 4/2 = 2바이트 이하의 오류를 정정할 수 있고, 
- N-K = 4 바이트 이하의 오류를 검출할 수 있다.


## 오류정정 한도

```
import random  
import reedsolo  
  
# 오류 정정 바이트 수  
RSC_LEN = 4  


# 송신자

# utf-8 문자열 생성  
text = '🐯사용자 입력!💻'  
byte_hex = text.encode('utf-8')  
string_hex = byte_hex.hex().upper()  
  
print(string_hex)  
# 리드 솔로몬 인코딩  
rsc = reedsolo.RSCodec(RSC_LEN)  
byte_rsc = rsc.encode(byte_hex)  
  
# 송신자의 문자열  
string_rsc = byte_rsc.hex().upper()  


  
# 수신자  

HEX = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'}  
client_rsc = reedsolo.RSCodec(RSC_LEN)  
  
# i : 바꿀 문자 수  
for i in range(0, RSC_LEN+1):  
    client_string_list = list(string_rsc)  
  
    for r in random.sample(range(0, len(client_string_list)//2), i):  
        m = random.randint(0, 2)  
        if m == 0:  
            # random.choice(list(HEX - {client_string_list[(r-2)*2]})) : 같은 문자로 바뀌지 않게하기 위한 과정  
            client_string_list[(r-1)*2] = random.choice(list(HEX - {client_string_list[(r-1)*2]}))  
        elif m == 1:  
            client_string_list[(r-1)*2+1] = random.choice(list(HEX - {client_string_list[(r-1)*2+1]}))  
        else:  # m == 2  
            client_string_list[(r - 1) * 2] = random.choice(list(HEX - {client_string_list[(r - 1) * 2]}))  
            client_string_list[(r - 1) * 2 + 1] = random.choice(list(HEX - {client_string_list[(r - 1) * 2 + 1]}))  
  
    client_string_rsc = ''.join(client_string_list)  
    client_byte_hex = bytes.fromhex(client_string_rsc)  
  
    try:  
        client_byte = client_rsc.decode(client_byte_hex)[0]  
        client_text = client_byte.decode('utf-8')  
  
        if client_text == text:  
            print(f'{i}개 오류 통과')  
            print(f'> {string_rsc}')  
            print(f'> {client_string_rsc}')  
              
    except reedsolo.ReedSolomonError:  
        print(f'{i}개 오류 통과 실패:')  
        print(f'> {string_rsc}')  
        print(f'> {client_string_rsc}')
```


#### Output

```
0개 오류 통과
> F09F90AFEC82ACEC9AA9EC9E9020EC9E85EBA0A521F09F92BB19F7312E
> F09F90AFEC82ACEC9AA9EC9E9020EC9E85EBA0A521F09F92BB19F7312E
1개 오류 통과
> F09F90AFEC82ACEC9AA9EC9E9020EC9E85EBA0A521F09F92BB19F7312E
> F09F90AFEC82ACEC9AA9EC9E9020E99E85EBA0A521F09F92BB19F7312E
2개 오류 통과
> F09F90AFEC82ACEC9AA9EC9E9020EC9E85EBA0A521F09F92BB19F7312E
> F09F90AFD882ACEC9AA9EC9E9020EC9E89EBA0A521F09F92BB19F7312E
3개 오류 통과 실패:
> F09F90AFEC82ACEC9AA9EC9E9020EC9E85EBA0A521F09F92BB19F7312E
> F09F80AFEC82ACEC9AA9EC1E9020EC9E85EBA0A521F09F92BB19F7362E
4개 오류 통과 실패:
> F09F90AFEC82ACEC9AA9EC9E9020EC9E85EBA0A521F09F92BB19F7312E
> F69F90AFEE82ACEC9AA9EE9E9020EC9E85EBA0A521F09F91BB19F7312E
```

R/2 = 2 이므로 두 개까지의 오류를 정정가능함을 확인할 수 있다.
