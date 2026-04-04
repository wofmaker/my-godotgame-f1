---
name: req
description: >
  이 프로젝트의 통합 진입점. 모든 요청을 접수하여
  글로벌 harness 코어 엔진이 처리한다.
  /req 또는 자연어 요청 시 활성화.
harness_version: "5.27"
---

# /req — my-godotgame-f1 통합 진입점

## 프로젝트 설정

| 항목 | 명령 |
|------|------|
| 에디터 | `godot --editor --path .` |
| 게임 실행 | `godot --path .` |
| headless 실행 | `godot --headless --path .` |
| 테스트 | `godot --headless --path . -s addons/gut/gut_cmdln.gd` |

## 에이전트 매핑

| 영역 | 에이전트 | 담당 파일 범위 |
|------|----------|---------------|
| 계획 비판 | critic | 전체 (읽기 전용) |
| 코드 리뷰 | code-reviewer | 전체 (읽기 전용) |
| 테스트 | test-writer | `test/**` |
| Godot 전문가 | godot-expert | `scenes/**`, `scripts/**`, `resources/**`, `*.tscn`, `*.gd`, `*.tres` |

## 도메인 규칙

<!-- custom-start -->
<!-- 이 영역에 프로젝트 고유 도메인 규칙을 추가한다. -->
<!-- /harness upgrade 시 이 블록은 보존된다. -->

- (기획 확정 후 추가 예정)

<!-- custom-end -->

## 머지 충돌 규칙

하네스 파일(`.claude/skills/`, `.claude/agents/`, `.harness/issue-runner.*`, `.claude/settings.json`)은 충돌 시 항상 master(theirs) 버전을 선택한다.

## 코어 엔진 참조

상세 실행 절차는 글로벌 코어 엔진을 따른다:

- 코어 엔진: `~/.claude/skills/harness/references/core-engine.md`
- 라우팅 규칙: `~/.claude/skills/harness/references/routing-rules.md`
- UI 테스트: `~/.claude/skills/harness/references/ui-testing.md`
