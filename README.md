# 민영 Pick

소개팅 이후 다음 약속을 부담 없이 고르는 Flutter Web 우선 MVP입니다.

## 개발 방식

- SDD: [docs/sdd.md](docs/sdd.md)에 MVP 범위와 인수 기준을 먼저 고정합니다.
- TDD: 새 행동은 domain/widget test로 먼저 표현하고 구현합니다.
- 배포: v0.1은 Flutter Web 링크 공유를 우선합니다.

## 시작하기

```sh
flutter test
flutter analyze
flutter run -d chrome
```

## Git 연결

로컬 저장소는 `main` 브랜치로 초기화되어 있습니다. GitHub/GitLab 원격 저장소를 만든 뒤 아래만 연결하면 됩니다.

```sh
git remote add origin <your-repo-url>
git add .
git commit -m "Start Minyoung Pick MVP"
git push -u origin main
```
