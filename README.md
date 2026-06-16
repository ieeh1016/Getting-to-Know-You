# 알아가기

소개팅 이후 하루 한 질문으로 천천히 가까워지는 Flutter Web 우선 MVP입니다.

## 개발 방식

- Product Spec: [docs/spec.md](docs/spec.md)를 진입점으로 두고, 기능별 상세 요구사항은 [docs/spec/](docs/spec/)에서 관리합니다.
- SDD: [docs/sdd.md](docs/sdd.md)는 기존 MVP 기록이며, 새 개발은 Product Spec을 기준으로 진행합니다.
- TDD: 새 행동은 domain/widget test로 먼저 표현하고 구현합니다.
- AI Harness: [AGENTS.md](AGENTS.md)에 AI/maintainer 작업 순서와 guardrail을 고정합니다.
- Code Structure: [docs/code_structure.md](docs/code_structure.md)에 feature-first 분리 기준을 고정합니다.
- 배포: v0.1은 Flutter Web 링크 공유를 우선합니다.

## 시작하기

```sh
flutter test
flutter analyze
flutter run -d chrome
```

전체 검증은 아래 한 줄로 실행할 수 있습니다.

```sh
./scripts/verify.sh
```

## Git 연결

로컬 저장소는 `main` 브랜치로 초기화되어 있습니다. GitHub/GitLab 원격 저장소를 만든 뒤 아래만 연결하면 됩니다.

```sh
git remote add origin <your-repo-url>
git add .
git commit -m "Build Alagagi MVP"
git push -u origin main
```
