##### 202202624 이예인


>정답 : 악기 functional 9280
>
>인증 영상 : https://youtu.be/s8CKZiHrPL8


- [[#Code 설명|Code 설명]]
	- [[#Code 설명#def RSDecode(hexstr):|def RSDecode(hexstr):]]
	- [[#Code 설명#def receive()|def receive()]]
		- [[#def receive()#오디오 스트림 설정|오디오 스트림 설정]]
		- [[#def receive()#오디오 데이터 읽기|오디오 데이터 읽기]]
		- [[#def receive()#소음에 대한 처리|소음에 대한 처리]]
		- [[#def receive()#고속 푸리에 변환|고속 푸리에 변환]]
		- [[#def receive()#리드 솔로몬 디코딩 & 동기화하여 주파수 서칭|리드 솔로몬 디코딩 & 동기화하여 주파수 서칭]]


# Code 설명


## def RSDecode(hexstr):

```
def RSDecode(hexstr):  
    import reedsolo  
  
    RSC_LEN = 4  
    rsc = reedsolo.RSCodec(RSC_LEN)  
    result = ''  
  
    for splited_hex in [hexstr[i:i+32] for i in range(0, len(hexstr), 32)]:  
        byte = bytes.fromhex(splited_hex)  
        rsc_decoded_byte = rsc.decode(byte)[0]  
        utf8_decoded_byte = rsc_decoded_byte.decode('utf-8')  
        result = result + utf8_decoded_byte  
  
    return result
```

Reed Solomon 알고리즘으로 인코딩된 HEX로 이루어진 문자열을 받았을 때,
16바이트씩 Reed Solomon으로 디코딩하고, utf-8로 디코딩하여 원래 문자열을 찾아주는 함수를 구현했습니다.


```
    RSC_LEN = 4  
    rsc = reedsolo.RSCodec(RSC_LEN) 
```
N-K를 4로 정의한 리드 솔로몬 코덱을 정의합니다.



```
[hexstr[i:i+32] for i in range(0, len(hexstr), 32)]
```

이 부분에서는 HEX의 문자열 중 문자 두개가 1byte이므로, 길이를 앞에서부터 32씩 잘라서 나오는 문자열들을 List에 담습니다.


```
    for splited_hex in [hexstr[i:i+32] for i in range(0, len(hexstr), 32)]:  
        byte = bytes.fromhex(splited_hex)  
        rsc_decoded_byte = rsc.decode(byte)[0]  
        utf8_decoded_byte = rsc_decoded_byte.decode('utf-8')  
        result = result + utf8_decoded_byte  
```

자른 문자열들을 리드솔로몬으로 디코딩하고, utf-8로 디코딩하여 리턴하는 문자열에 더해줍니다.


## def receive()

이 함수를 실행하면 소리를 입력받은 후 비밀번호를 출력합니다.

```python
def receive():
    unit = 0.1  # 각 신호의 지속 시간(초)
    samplerate = 48000  # 샘플링 레이트
    chunk_size = 1024
    padding = 20  # 주파수 판정 시 허용 오차
    sound_start = False
    audio = []
    tuning = False
    hex_string = ''
    end_cnt = 0
    start_cnt = 0

    p = pyaudio.PyAudio()
    stream = p.open(format=pyaudio.paInt16,
                    channels=1,
                    rate=samplerate,
                    input=True)

    while True:
        codeData = stream.read(chunk_size)  # 2048 바이트 읽어들인다. 0x13 ..
        data = struct.unpack('<' + ('h' * chunk_size), codeData)  # 2바이트씩 10진수로 변환한다.

        for entry in data:
            if abs(entry) > 5000:
                audio.append(entry)
                tuning = True
            elif tuning:
                audio.append(entry)

            if len(audio) == 4800:
                freq = scipy.fftpack.fftfreq(len(audio), d=1 / samplerate)
                fourier = scipy.fftpack.fft(audio)
                top = freq[np.argmax(abs(fourier))]

                for k, v in rules.items():
                    if v - padding <= top <= v + padding:
                        if k == "START":
                            start_cnt += 1
                            if start_cnt == 2:  # 시작 신호 2회 인식 시
                                print("START")
                                sound_start = True
                        elif not sound_start:
                            pass
                        elif k == "END":
                            end_cnt += 1
                            if end_cnt == 2:  # 종료 신호 2회 인식 시
                                result = RSDecode(hex_string)
                                print("\nEND")
                                print(f'입력한 값: {result}')
                                exit(0)
                        else:
                            hex_string += k  # 인식된 키를 문자열에 추가
                            print(k, end='')
                        break
                audio.clear()
```

### 오디오 스트림 설정

```python
p = pyaudio.PyAudio()  # PyAudio 객체 생성
stream = p.open(format=pyaudio.paInt16,
                channels=1,
                rate=samplerate,
                input=True)  # 오디오 스트림 열기
```


### 오디오 데이터 읽기

```python
while True:
    codeData = stream.read(chunk_size)  # 오디오 데이터 읽기
    data = struct.unpack('<' + ('h' * chunk_size), codeData)  # 바이트 데이터를 정수로 변환
```

무한 루프를 통해 오디오 데이터를 지속적으로 읽고, 바이트 데이터를 정수 형태로 변환합니다.


### 소음에 대한 처리

```python
for entry in data:
    if abs(entry) > 5000:
        audio.append(entry)  # 오디오 데이터 저장
        tuning = True
    elif tuning:
        audio.append(entry)
```

읽은 데이터 중에서 일정 크기 이상의 신호를 감지하면, 해당 데이터를 처리하기 시작합니다. 이는 신호의 시작을 감지하는 조건입니다. 그 크기 이하라면 소음으로 판단하고 데이터를 읽지 않습니다.


### 고속 푸리에 변환

```python
if len(audio) == 4800:
    freq = scipy.fftpack.fftfreq(len(audio), d=1 / samplerate)
    fourier = scipy.fftpack.fft(audio)  # FFT(고속 푸리에 변환) 실행
    top = freq[np.argmax(abs(fourier))]  # 가장 높은 주파수 성분 찾기
```

적절한 양의 오디오 데이터가 모이면 FFT(고속 푸리에 변환)를 실행하여 주파수 성분을 분석합니다. 이를 통해 가장 높은 주파수 성분을 찾습니다.


### 리드 솔로몬 디코딩 & 동기화하여 주파수 서칭

- `sound_start`가 `True`인 상태에서, `END` 키에 대응하는 주파수가 인식되면 `end_cnt`를 증가시킵니다. 
- FFT 결과로 얻어진 주파수(`top`)가 `rules` 딕셔너리에 정의된 각각의 주파수 범위 내에 있는지를 검사합니다.
- `START` 신호와 `END` 신호 사이에 인식된 다른 주파수는 해당하는 키를 `hex_string`에 추가합니다.
- `end_cnt`가 2에 도달하면 신호의 종료를 알리고, 수신된 데이터(헥스 문자열)를 정의한 RSDeocde 함수에 전달하여 result변수에 찾은 비밀번호를 전달받고 이를 출력합니다. 이제 모든 과정을 마쳤으므로 프로그램을 종료합니다(`exit(0)`).

```python
for k, v in rules.items():  
    if v - padding <= top <= v + padding:  
        if k == "START":  
            start_cnt += 1  
            if start_cnt == 2:  # 시작 신호 2회 인식 시  
                print("START")  
                sound_start = True  
        elif not sound_start:  
            pass  
        elif k == "END":  
            end_cnt += 1  
            if end_cnt == 2:  # 종료 신호 2회 인식 시  
                result = RSDecode(hex_string)  
                print("\nEND")  
                print(f'입력한 값: {result}')  
                exit(0)  
        else:  
            hex_string += k  # 인식된 키를 문자열에 추가  
            print(k, end='')  
        break

```

