# my-godotgame-f1 — Project Rules

> Godot 4.x + GDScript 기반 게임 프로젝트.
> 기획 미정 (브레인스토밍 예정).

## Architecture

```
my-godotgame-f1/
├── CLAUDE.md
├── project.godot
├── scenes/               # 씬 파일 (.tscn)
│   ├── main/
│   ├── ui/
│   └── levels/
├── scripts/              # GDScript (.gd)
│   ├── autoload/         # 싱글톤 (GameManager 등)
│   ├── components/       # 재사용 컴포넌트
│   ├── ui/
│   └── utils/
├── assets/               # 리소스
│   ├── sprites/
│   ├── audio/
│   ├── fonts/
│   └── shaders/
├── resources/            # .tres 리소스 파일
└── export_presets.cfg
```

## Build & Run

```bash
# Godot 에디터 실행 (프로젝트 열기)
godot --editor --path .

# 게임 실행 (headless 아닌 경우)
godot --path .

# headless 실행 (CI/테스트)
godot --headless --path .

# 특정 씬 실행
godot --path . scenes/main/main.tscn
```

## Coding Conventions

- GDScript: snake_case (변수, 함수), PascalCase (클래스, 노드)
- 시그널: past_tense_verb (예: `health_changed`, `player_died`)
- 상수: UPPER_SNAKE_CASE
- 파일명: snake_case.gd, snake_case.tscn
- 노드 참조: `@onready var` 사용, 하드코딩 경로 최소화
- 타입 힌트 적극 사용: `var speed: float = 100.0`
- `@export` 활용하여 에디터에서 조정 가능하게
- 씬 트리 구조: 루트 노드는 씬 이름과 동일
- Autoload: 전역 상태는 싱글톤 패턴 사용

## Forbidden Patterns

- `sed` 명령어로 파일 수정 금지
- `get_node("경로/깊은/하드코딩")` — `@onready var` 또는 `%UniqueNode` 사용
- 프로세스 함수에서 매 프레임 인스턴스 생성 금지 (Object pool 사용)
- `await get_tree().create_timer(0).timeout` 1프레임 대기 남용 금지
- 순환 의존 (`preload` 순환) 금지
- `_ready()`에서 다른 노드 상태 의존 금지 (시그널 또는 `call_deferred` 사용)

## Agent Team

| 에이전트 | 파일 | 역할 |
|----------|------|------|
| critic | critic.md | 계획 비판, 무게 판정 검증 |
| code-reviewer | code-reviewer.md | 코드 리뷰 (읽기 전용) |
| test-writer | test-writer.md | GDScript 테스트 작성 (GUT) |
| godot-expert | godot-expert.md | Godot 4.x 씬/스크립트/셰이더 구현 |

## Domain Rules

- (기획 확정 후 추가 예정)
