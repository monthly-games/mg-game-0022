# MG-0022: 몬스터 레벨업 파티

미니 게임 모음 + 방치 성장

## 개요

| 항목 | 내용 |
|------|------|
| Game ID | game_0022 |
| 코드명 | MG-0022 |
| 장르 | 미니 게임 모음 + 방치 성장 |
| 타깃 지역 | KR, SEA, Global |
| Year 2 역할 | 라이브 이벤트용 미니게임 플랫폼 실험 |

## 구조

```
mg-game-0022/
  ├─ common/                    # submodules
  │   ├─ game/                  # → mg-common-game
  │   ├─ backend/               # → mg-common-backend
  │   ├─ analytics/             # → mg-common-analytics
  │   └─ infra/                 # → mg-common-infra
  ├─ game/
  │   ├─ lib/
  │   │   ├─ features/          # 게임 고유 기능
  │   │   ├─ theme/             # 테마/스타일
  │   │   └─ main.dart
  │   ├─ assets/                # 에셋 파일
  │   └─ test/                  # 테스트
  ├─ backend/                   # 게임 전용 백엔드 확장
  ├─ analytics/                 # 게임 전용 이벤트/쿼리
  ├─ marketing/
  │   ├─ campaigns/             # 캠페인 정의
  │   └─ creatives/             # 크리에이티브 에셋
  ├─ docs/
  │   ├─ design/                # GDD, 경제 설계, 레벨 디자인
  │   └─ notes/                 # 개발 노트
  ├─ config/
  │   └─ game_manifest.json     # 게임 메타데이터
  ├─ .github/workflows/         # CI/CD
  └─ README.md
```

## 시작하기

### 1. 저장소 클론 및 submodule 초기화

```bash
git clone --recursive git@github.com:monthly-games/mg-game-0022.git
cd mg-game-0022
git submodule update --init --recursive
```

### 2. Flutter 프로젝트 실행

```bash
cd game
flutter pub get
flutter run
```

## 관련 문서

- [GDD](docs/design/gdd_game_0022.json)
- [경제 설계](docs/design/economy.json)
- [레벨 디자인](docs/design/level_design.json)
