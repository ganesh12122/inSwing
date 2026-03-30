# 🤝 inSwing — Contributing Guide

## Getting Started

### Prerequisites

- Python 3.11+
- Flutter SDK 3.10+
- Docker Desktop (for Redis)
- PostgreSQL 15+ (local or Neon)
- Git

### Clone & Setup

```bash
git clone https://github.com/ganesh12122/inSwing.git
cd inSwing
```

### Backend Setup

```bash
cd backend
python -m venv venv
venv\Scripts\activate          # Windows
# source venv/bin/activate     # Linux/Mac

pip install -r requirements.txt

# Create .env file from template
cp .env.example .env
# Edit .env with your database credentials

# Run migrations
alembic upgrade head

# Start server
uvicorn app.main:app --reload --port 8000
```

### Frontend Setup

```bash
cd flutter
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

---

## Development Workflow

### Branch Naming

```
feat/short-description     # New feature
fix/short-description      # Bug fix
refactor/short-description # Code improvement
docs/short-description     # Documentation
```

### Commit Messages (Conventional Commits)

```
feat: add tournament bracket support
fix: correct overs calculation in innings
refactor: extract scoring logic to service layer
docs: update API reference for ball endpoint
test: add tests for match creation flow
chore: update dependencies
```

### Pull Request Process

1. Create feature branch from `main`
2. Make changes, write tests
3. Run linters: `flutter analyze` and `pylint`
4. Push and create PR
5. Ensure CI passes
6. Request review

---

## Code Standards

### Python (Backend)

- **Formatter**: Black (line length 88)
- **Import sorting**: isort
- **Linter**: pylint
- **Type hints**: Required on all functions
- **Docstrings**: Required on all public functions/classes
- **Logging**: Use `structlog`, never `print()`
- **Tests**: pytest with async support

### Dart (Flutter)

- **Formatter**: dart format (built-in)
- **Linter**: flutter analyze with strict rules
- **No `dynamic` types** unless unavoidable
- **Freezed** for all data models
- **Riverpod** with code generation
- **Tests**: flutter test

---

## Project Rules

1. Never commit secrets, tokens, or passwords
2. Never commit `.env` files
3. Always update documentation when behavior changes
4. Always write tests for new endpoints/features
5. Keep the service layer thin — business logic in services, not controllers
6. Update both backend AND frontend when changing API contracts
7. Use Alembic for ALL database schema changes
