# dungeon-haul — Project Rules

> Phaser 3 + TypeScript 기반 2D 탑다운 로그라이트 웹 게임.
> "한 층만 더..."의 유혹과 "지금 빠질까"의 긴장감이 핵심.

## Architecture

```
dungeon-haul/
├── CLAUDE.md
├── package.json
├── tsconfig.json
├── vite.config.ts
├── index.html
├── src/
│   ├── main.ts              # 엔트리포인트, Phaser.Game 생성
│   ├── config.ts             # 게임 설정 (해상도, 물리 등)
│   ├── scenes/               # Phaser Scene 클래스
│   │   ├── BootScene.ts
│   │   ├── MainMenuScene.ts
│   │   ├── DungeonScene.ts
│   │   ├── BaseScene.ts
│   │   └── UIScene.ts
│   ├── entities/             # 게임 오브젝트 (Player, Enemy 등)
│   │   ├── Player.ts
│   │   ├── enemies/
│   │   └── projectiles/
│   ├── systems/              # 게임 시스템 (전투, 인벤토리 등)
│   │   ├── CombatSystem.ts
│   │   ├── InventorySystem.ts
│   │   └── DungeonGenerator.ts
│   ├── managers/             # 싱글톤 매니저
│   │   ├── GameManager.ts
│   │   ├── EventBus.ts
│   │   └── SaveManager.ts
│   ├── data/                 # 정적 데이터 (무기, 적, 아이템 정의)
│   │   ├── weapons.ts
│   │   ├── enemies.ts
│   │   └── items.ts
│   ├── ui/                   # UI 컴포넌트
│   └── utils/                # 유틸리티
├── public/                   # 정적 에셋
│   ├── sprites/
│   ├── audio/
│   └── fonts/
├── test/                     # Vitest 테스트
│   ├── unit/
│   └── integration/
└── docs/
    └── prd/
```

## Build & Run

```bash
# 의존성 설치
npm install

# 개발 서버 (HMR)
npm run dev

# 프로덕션 빌드
npm run build

# 빌드 미리보기
npm run preview

# 테스트 실행
npm test

# 테스트 (watch 모드)
npm run test:watch

# 린트
npm run lint
```

## Coding Conventions

- TypeScript strict 모드 사용
- 변수/함수: camelCase, 클래스: PascalCase, 상수: UPPER_SNAKE_CASE
- 파일명: PascalCase.ts (클래스), camelCase.ts (유틸/데이터)
- Phaser Scene 이름: PascalCase (예: `DungeonScene`)
- 이벤트 이름: `kebab-case` (예: `player-died`, `health-changed`)
- 타입 힌트 필수, `any` 사용 금지
- `@ts-ignore` 사용 금지
- Phaser 오브젝트는 Scene의 `create()`에서 생성
- 전역 상태는 EventBus 또는 GameManager 싱글톤 사용

## Forbidden Patterns

- `sed` 명령어로 파일 수정 금지
- `any` 타입 사용 금지
- `document.querySelector` 직접 사용 금지 (Phaser API 사용)
- `setInterval`/`setTimeout` 직접 사용 금지 (Phaser Timer 사용)
- 매 프레임 `new` 객체 생성 금지 (Object Pool 사용)
- 순환 import 금지
- 전역 변수 (`window.*`) 사용 금지

## Agent Team

| 에이전트 | 역할 |
|----------|------|
| critic | 계획 비판, 무게 판정 검증 |
| code-reviewer | 코드 리뷰 (읽기 전용) |
| test-writer | Vitest 테스트 작성 |

## Tech Stack

| 영역 | 기술 |
|------|------|
| 엔진 | Phaser 3.80+ |
| 언어 | TypeScript 5.x |
| 빌드 | Vite 6.x |
| 테스트 | Vitest |
| 린트 | ESLint + Prettier |
| 물리 | Phaser Arcade Physics |
| 저장 | localStorage (JSON) |

## Domain Rules

- (기획 확정 후 추가 예정)
