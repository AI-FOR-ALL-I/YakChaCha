
# readme

# 약 먹었어? 아 맞다! 복약관리 어플리케이션 YakChaCha(약차차)

---

<aside>
💊 삼성청년SW아카데미 8기 특화프로젝트 - 인공지능(영상) 도메인 프로젝트

</aside>

### [안드로이드 APK 다운로드 링크](https://drive.google.com/drive/folders/1ASdcb5IMNfGEtCmVmMNd8i0HtgrvzIAd)

## 개발 기간

---

2023년 2월 20일 ~2023년 4월 7일 

## 팀원소개

---

![팀원소개](https://user-images.githubusercontent.com/59593223/230527479-949e89d7-6c6a-441a-b0ba-43b3e35f3a32.PNG)

`FE` 김동준, 김준형, 이윤진

`BE` 정환석, 함철훈

`AI` 박장훈, 함철훈

`INFRA` 정환석

## 환경 설정

---

### Front-End

```
- Flutter 3.9.0
- Dart 3.0.0
- cupertino_icons: 1.0.2
- curl_logger_dio_interceptor: 0.0.3
- dio: 4.0.6
- firebase_analytics: 10.1.6
- firebase_core: 2.8.0
- firebase_messaging: 14.3.0
- flutter_local_notifications: 8.2.0
- flutter_time_picker_spinner: 2.0.0
- get: 4.6.5
- http: 0.13.5
- image_picker: 0.8.7
- intl: 0.18.0
- kakao_flutter_sdk: 1.4.1
- shared_preferences: 2.0.20
- kakaomap_webview: 0.6.2
- webview_flutter: 3.0.2
- geolocator: 7.6.2
- xml: 6.2.2
- url_launcher: 6.1.10
- location: 4.2.0
- material_design_icons_flutter: 6.0.7096
- xml2json: 5.3.6
- image: 4.0.15
- rxdart: 0.27.7
- table_calendar: 3.0.9
- flutter_launcher_icons: 0.12.0
- marquee: 2.2.3
- auto_size_text: 3.0.0
- confirm_dialog: 1.0.1
- permission_handler: 10.2.0
```

### Back-End

```
- java: 11
- spring boot: 2.7.9
- spring security
- spring data jpa
- spring data redis
- lombok
- firebase-admin: 9.1.1
- jjwt: 0.9.1

- mariaDB: 10.11.2
- redis: 7.0.10
```

### Server

```
- AWS EC2
- ubuntu: 20.04 LTS
- jenkins: 2.394
- nginx: 1.23.3
- docker-engine: 23.0.1 
- docker-compose: 1.25.0
- certbot
- letsencrypt
```

### AI

```
ImageRecognition - Docker
- Python: 3.9
- certifi: 2022.12.7
- charset-normalizer: 3.1.0
- click: 8.1.3
- colorama: 0.4.6
- easyocr: 1.6.2
- filelock: 3.10.7
- Flask: 2.2.3
- idna: 3.4
- imageio: 2.27.0
- importlib-metadata: 6.1.0
- itsdangerous: 2.1.2
- Jinja2: 3.1.2
- lazy_loader: 0.2
- MarkupSafe: 2.1.2
- mpmath: 1.3.0
- networkx: 3.1
- ninja: 1.11.1
- numpy: 1.24.2
- opencv-python-headless: 4.5.4.60
- packaging: 23.0
- Pillow: 9.5.0
- pyclipper: 1.3.0.post4
- python-bidi: 0.4.2
- PyWavelets: 1.4.1
- PyYAML: 6.0
- requests: 2.28.2
- scikit-image: 0.20.0
- scipy: 1.9.1
- shapely: 2.0.1
- six: 1.16.0
- sympy: 1.11.1
- tifffile: 2023.3.21
- torch: 2.0.0
- torchvision: 0.15.1
- typing_extensions: 4.5.0
- urllib3: 1.26.15
- Werkzeug: 2.2.3
- zipp: 3.15.0

OCR - GPU server
- Pytorch 1.7.1+cu110
- Tensorflow 2.10.1
- Flask 2.2.3
```

## 서비스 아키텍처

---

![기술스택](https://user-images.githubusercontent.com/59593223/230527606-5ae58691-4507-4e2a-b069-e39c7664af55.PNG)

![아키텍처](https://user-images.githubusercontent.com/59593223/230527620-c5dbd603-3eda-4fba-b4ee-c28537ea3dfc.PNG)

## 서비스 실행방법

---

### Git Repository

```bash
$git clone {URL}
```

### Back - Dockerfile

```yaml
FROM gradle:jdk11 as builder

ENV APP_HOME=/apps

WORKDIR $APP_HOME

COPY build.gradle settings.gradle $APP_HOME/

COPY src $APP_HOME/src

ENV SPRING_PROFILES_ACTIVE=dev

RUN gradle clean build

FROM openjdk:11-jdk

ENV APP_HOME=/apps
ARG ARTIFACT_NAME=app.jar
ARG JAR_FILE_PATH=build/libs/ycc-0.0.1-SNAPSHOT.jar

WORKDIR $APP_HOME
COPY --from=builder $APP_HOME/$JAR_FILE_PATH $ARTIFACT_NAME

EXPOSE 8080

ENV SPRING_PROFILES_ACTIVE=dev

ENTRYPOINT ["java", "-jar", "app.jar"]
```

### AI - Dockerfile

```yaml
FROM python:3.9

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
RUN pip install efficientnet_pytorch

COPY . .

ENTRYPOINT ["python", "app.py"]
```

### nginx.conf

```yaml
server {

    location /api {
            proxy_pass http://back:8080;
    }

    location /run {
            proxy_pass http://ai:8090;
    }

    listen 443 ssl; 
    ssl_certificate /etc/letsencrypt/live/{DOMAIN}/fullchain.pem; 
    ssl_certificate_key /etc/letsencrypt/live/{DOMAIN}/privkey.pem;

}

server {
    if ($host = {DOMAIN}) {
        return 301 https://$host$request_uri;
    } 

    listen 80;
    server_name {DOMAIN};

    return 404;
}
```

### docker-compose.yml

```yaml
version: "3"
services:
  nginx:
    container_name: nginx
    image: nginx:latest
    restart: unless-stopped
    volumes:
      - ./ssl/conf:/etc/nginx/conf.d
      - ./ssl/data/certbot/conf:/etc/letsencrypt
      - ./ssl/data/certbot/www:/var/www/certbot
      - /etc/localtime:/etc/localtime
    ports:
      - 80:80
      - 443:443
    depends_on:
      - back
      - ai

  back:
    container_name: back
    image: ycctest:1.0
    volumes:
      - ./logs:/apps/logs
    environment:
      - TZ=${TZ}
    ports:
      - 8080:8080
    depends_on:
      - mariadb
      - redis

  ai:
    container_name: ai
    image: predict_pill
    shm_size: 2gb
    environment:
      - TZ=${TZ}
    ports:
      - 8090:8090
    depends_on:
      - mariadb

  mariadb:
    container_name: mariadb
    image: mariadb
    volumes:
      - /home/ubuntu/db/mariadb:/var/lib/mysql
    environment:
      - TZ=${TZ}
      - MYSQL_DATABASE=dev
      - MYSQL_ROOT_PASSWORD={PASSWORD}
    ports:
      - 3356:3306

  redis:
    hostname: redis
    container_name: redis
    image: bitnami/redis
    environment:
      - TZ=${TZ}
      - REDIS_REPLICATION_MODE=master
      - REDIS_PASSWORD={PASSWORD}
    volumes:
      - /home/ubuntu/db/redis/master:/data
    ports:
      - 6379:6379

  redis-slave:
    hostname: redis-slave
    container_name: redis-slave
    image: bitnami/redis
    environment:
      - TZ=${TZ}
      - REDIS_REPLICATION_MODE=slave
      - REDIS_MASTER_HOST=redis
      - REDIS_MASTER_PASSWORD={PASSWORD}
      - REDIS_PASSWORD={PASSWORD}
    volumes:
      - /home/ubuntu/db/redis/slave:/data
    ports:
      - 6480:6379
    depends_on:
      - redis
```

### 실행 방법

```bash
$docker compose up -d
```

## 기능소개

---

### 1. 로그인

<img
  src="https://user-images.githubusercontent.com/59593223/232363436-95454809-b14f-4ba2-9c56-bb32f63aa3ba.gif"
  width="30%"
  height="30%"
/>

**로그인**

- 카카오로그인 SDK 적용하여 소셜로그인 구현
- 프로필 연동 시 카카오계정의 이메일 활용

### 2. 프로필선택

![프로필선택](https://user-images.githubusercontent.com/59593223/230528264-a544ab96-dbd2-4e0f-8b5c-141aa26dbbb8.png)|![메인화면](https://user-images.githubusercontent.com/59593223/230528268-2dda0158-1486-470d-a51c-ce32e5716e49.png)
--- | --- |

**멀티프로필 및 프로필 연동**

- 휴대폰이 없는 아이를위한  멀티프로필
- 공동관리가 가능한 프로필 연동
- 프로필 맞춤 페이지

### 3. 약

![복용중인약](https://user-images.githubusercontent.com/59593223/230528226-033417a3-f89d-4f1e-87a6-f414aed8493a.png)|![텍스트약검색](https://user-images.githubusercontent.com/59593223/232368936-f5e02aae-4baf-4030-935b-bc55adf28c17.gif)
--- | --- |

**약 관리** 

- 현재 복용 중인 약관리
- 지난 복용 기록
- 태그를 이용한 약 관리

**약 정보**

- 프로필 정보에 따른 약 정보 제공
- 임부, 노인, 아동 주의 및 복용 중인 약과 충돌 여부

### 4. 알람

![알람 등록 및 알람 달성](https://user-images.githubusercontent.com/59593223/232369047-23600e91-dd36-412b-ae40-61ef0a5fc738.gif)|![알람 상세](https://user-images.githubusercontent.com/59593223/232369051-3fb54982-0588-4565-9c80-51538b753478.gif)
--- | --- |



**알람 관리**

- 시간대별 복용 알람 설정
- 놓친 알람, 복용한 알람, 곧 다가오는 알람, 미래 알람 구분
- 알람 설정 시간에 푸시 알림
- 연동 중인 모든 계정에 푸시 알림

### 5. 사진으로 약 등록 및 검색

![약 사진 검색](https://user-images.githubusercontent.com/59593223/232369199-c446d8cf-2917-4ef8-b54c-65a4227e22d5.gif)|![OCR](https://user-images.githubusercontent.com/59593223/230527304-ebc6c5ce-0633-4812-8a64-4007dc961408.png)
--- | --- |

**알약 사진으로 약 등록 & 검색**

- AI 모델을 통한 알약 인식
- Top1과 Top5 출력

**처방전으로 약 등록**

- 처방전 OCR을 통해 약 등록 간편화
- 손쉬운 등록, 검색으로 사용자 편의 증대

### 6. 연동(Sender)

![sender1](https://user-images.githubusercontent.com/59593223/230527457-356d181e-1d39-4bc1-9a5d-0cb7434b79af.png)|![sender2](https://user-images.githubusercontent.com/59593223/230527467-72bdb943-3062-4dea-8b3d-eb26871904ca.png)
--- | --- |

![인증번호입력](https://user-images.githubusercontent.com/59593223/230528085-760e41a3-c47b-40d0-bd8f-5d219948b9f2.png)|![sender3](https://user-images.githubusercontent.com/59593223/230527476-3f0e4884-db3c-4ab3-8ba2-729f61ae4da3.png)
--- | --- |

**프로필 연동 발신자 입장**

- 연동하고자하는 사용자의 계정아이디를 입력
- 존재하는 계정이라면 수신자에게 푸시알림 전송
- 수신자가 연동할 계정을 선택한 뒤 인증번호 입력하면 연동 성공

### 7. 연동(Receiver)

<img
  src="https://user-images.githubusercontent.com/59593223/232369554-01894b5b-57ad-4094-9f76-dad43c253709.gif"
  width="30%"
  height="30%"
/>

**프로필 연동 수신자 입장**

- 발신자가 이메일을 입력하면 연동 요청 알림을 수신하게 됨
- 발신자 계정과 공유하고자하는 프로필들을 선택 가능
- 이미 발신자와 연동 중인 프로필이거나 다른 사람과 공유중인 프로필은 공유가 불가능함
- 프로필 선택 후 생성된 인증번호를 수신자에게 공유

## 설계문서

---

📎 링크를 통해 확인가능합니다.

### [ERD](https://drawsql.app/teams/-212/diagrams/psg)

### [API 명세서](https://www.notion.so/API-ee3ecc00852d4e52954305027509c73a)

### [와이어프레임 / GUI](https://www.figma.com/file/dmY3SAA89E649Nd9weqCXl/목업?node-id=33%3A38728&t=PI3VkyXrkYDEGrTt-1)
