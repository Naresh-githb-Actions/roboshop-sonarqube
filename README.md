# Python Hello World - CI Pipeline

## 1. Project Overview

This project is a simple Python **Hello World** application created to demonstrate a basic **CI (Continuous Integration)** pipeline.

The project uses:

- Python
- Flake8
- Pytest
- SonarQube
- SonarQube Quality Gate
- Docker
- GitHub Actions

The CI pipeline automatically checks the code, runs unit tests, analyzes code quality, validates the build, and creates a Docker image.

### CI Pipeline Flow

```text
GitHub Push
     ↓
Code Checkout
     ↓
Lint
     ↓
Unit Tests
     ↓
Build
     ↓
SonarQube Scan
     ↓
Quality Gate
     ↓
Docker Image Build
     ↓
SUCCESS
```

---

## 2. Application

The application is a simple Python program that prints:

```text
Hello, World!
```

Application file:

```text
app/main.py
```

```python
def hello():
    return "Hello, World!"


if __name__ == "__main__":
    print(hello())
```

Run the application locally:

```bash
python app/main.py
```

Expected output:

```text
Hello, World!
```

---

## 3. Project Structure

```text
roboshop-sonarqube/
│
├── app/
│   ├── __init__.py
│   └── main.py
│
├── tests/
│   └── test_main.py
│
├── .github/
│   └── workflows/
│       └── ci.yml
│
├── Dockerfile
├── requirements.txt
├── sonar-project.properties
└── README.md
```

### File Description

| File | Purpose |
|---|---|
| `app/main.py` | Python application |
| `app/__init__.py` | Python package |
| `tests/test_main.py` | Unit test |
| `Dockerfile` | Docker image instructions |
| `requirements.txt` | Python dependencies |
| `sonar-project.properties` | SonarQube configuration |
| `.github/workflows/ci.yml` | GitHub Actions CI pipeline |
| `README.md` | Project documentation |

---

## 4. GitHub Actions

GitHub Actions is used to automate the CI pipeline.

Workflow file:

```text
.github/workflows/ci.yml
```

The workflow runs when code is pushed to the `main` branch or when a pull request is created.

```yaml
on:
  push:
    branches:
      - main

  pull_request:
```

GitHub Actions executes the pipeline on a runner.

```text
GitHub Repository
       ↓
GitHub Actions Runner
       ↓
CI Pipeline
```

---

## 5. Lint

**Linting** checks Python source code for coding-style problems and basic programming issues.

This project uses **Flake8**.

Run locally:

```bash
python -m flake8 app tests
```

Flake8 checks for:

- Coding style problems
- Unused imports
- Undefined names
- Whitespace problems
- PEP 8 violations

During development, examples of lint errors included:

```text
W292 no newline at end of file
W293 blank line contains whitespace
W391 blank line at end of file
```

After fixing the issues:

```text
Lint: PASS
```

If lint fails, the pipeline stops.

---

## 6. Unit Tests

Unit tests verify that the application behaves as expected.

This project uses **Pytest**.

Test file:

```text
tests/test_main.py
```

```python
from app.main import hello


def test_hello():
    assert hello() == "Hello, World!"
```

Run locally:

```bash
PYTHONPATH=. python -m pytest
```

Expected result:

```text
1 passed
```

### Why `PYTHONPATH=.`?

`PYTHONPATH=.` tells Python to include the current project directory when looking for modules.

This allows the test to find:

```text
roboshop-sonarqube/
        ↓
       app/
        ↓
     main.py
```

---

## 7. Build

The Build stage validates that the Python application can be compiled successfully.

The pipeline runs:

```bash
python -m compileall app
```

This checks that the Python source code can be compiled without syntax errors.

Flow:

```text
Python Source Code
        ↓
Python Compilation
        ↓
Build Success
```

---

## 8. SonarQube and Quality Gate

### SonarQube

SonarQube performs deeper analysis of the source code.

It can identify:

- Bugs
- Vulnerabilities
- Security issues
- Code smells
- Duplicated code
- Maintainability problems
- Test coverage

Configuration file:

```text
sonar-project.properties
```

Example:

```properties
sonar.projectKey=hello-world-python
sonar.projectName=Hello World Python

sonar.sources=app
sonar.tests=tests

sonar.python.version=3.12
```

### SonarQube Scan

The pipeline runs the SonarQube scanner:

```yaml
- name: SonarQube Scan
  uses: SonarSource/sonarqube-scan-action@v6
  env:
    SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
    SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}
```

### Quality Gate

The **Quality Gate** is the PASS/FAIL checkpoint based on the SonarQube analysis.

The relationship is:

```text
Source Code
     ↓
SonarQube Scan
     ↓
Analysis Results
     ↓
Quality Gate
     ↓
PASS / FAIL
```

The Quality Gate can evaluate conditions such as:

- Bugs
- Vulnerabilities
- Code coverage
- Duplications
- Maintainability

If the Quality Gate passes:

```text
Quality Gate: PASSED
        ↓
Docker Image Build
```

If the Quality Gate fails:

```text
Quality Gate: FAILED
        ↓
Pipeline stops
```

The workflow checks the Quality Gate using:

```yaml
- name: Quality Gate
  uses: SonarSource/sonarqube-quality-gate-action@v1
  timeout-minutes: 5
  env:
    SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
```

### SonarQube vs Quality Gate

| Component | Purpose |
|---|---|
| SonarQube Scan | Analyzes the code |
| Quality Gate | Decides whether the code meets the required quality standards |

---

## 9. Docker Image Build

Docker packages the application into a container image.

### Dockerfile

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY app/ ./app/

CMD ["python", "app/main.py"]
```

Build the image locally:

```bash
docker build -t hello-world-python .
```

Run the container:

```bash
docker run --rm hello-world-python
```

Expected output:

```text
Hello, World!
```

### GitHub Actions Docker Build

The pipeline builds the image using:

```yaml
- name: Docker Image Build
  run: |
    docker build -t hello-world-python:${{ github.sha }} .
```

The image is tagged using the Git commit SHA.

Example:

```text
hello-world-python:a82f91c
```

> **Note:** This project builds the Docker image but does not push it to Docker Hub or another container registry.

---

## 10. Complete Pipeline and Success

The complete CI pipeline is:

```text
                         GitHub Push
                              │
                              ↓
                       Code Checkout
                              │
                              ↓
                            Lint
                              │
                              ↓
                         Unit Tests
                              │
                              ↓
                            Build
                              │
                              ↓
                      SonarQube Scan
                              │
                              ↓
                        Quality Gate
                              │
                       ┌──────┴──────┐
                       │             │
                     PASS           FAIL
                       │             │
                       ↓             ↓
                Docker Image      Pipeline
                    Build          Stops
                       │
                       ↓
                    SUCCESS
```

### Successful Pipeline

```text
Code Checkout       ✅
Lint                ✅
Unit Tests          ✅
Build               ✅
SonarQube Scan      ✅
Quality Gate        ✅
Docker Image Build  ✅
SUCCESS             ✅
```

---

## Local Verification

Before pushing code, the following commands can be used to verify the project locally.

### 1. Install dependencies

```bash
python -m pip install -r requirements.txt
```

### 2. Run Lint

```bash
python -m flake8 app tests
```

### 3. Run Unit Tests

```bash
PYTHONPATH=. python -m pytest
```

### 4. Run Build

```bash
python -m compileall app
```

### 5. Build Docker Image

```bash
docker build -t hello-world-python .
```

### 6. Run Docker Container

```bash
docker run --rm hello-world-python
```

---

## GitHub Actions Secrets

The SonarQube integration requires these GitHub Actions secrets:

```text
SONAR_TOKEN
SONAR_HOST_URL
```

They are configured under:

```text
GitHub Repository
    ↓
Settings
    ↓
Secrets and variables
    ↓
Actions
```

The SonarQube token should not be stored directly in the workflow file.

The workflow accesses it using:

```yaml
${{ secrets.SONAR_TOKEN }}
```

---


---

# GitHub Actions Workflow

The CI pipeline is defined in:

```text
.github/workflows/ci.yml
```

The current workflow uses a **self-hosted GitHub Actions runner**.

```yaml
name: Python CI

on:
  push:
    branches:
      - main
  pull_request:

jobs:
  ci:
    runs-on: self-hosted

    steps:

      # 1. Code Checkout
      - name: Code Checkout
        uses: actions/checkout@v4

      # 2. Setup Python
      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      # 3. Install Dependencies
      - name: Install Dependencies
        run: |
          pip install -r requirements.txt

      # 4. Lint
      - name: Lint
        run: |
          python -m flake8 app tests

      # 5. Unit Tests
      - name: Unit Tests
        run: |
          PYTHONPATH=. pytest

      # 6. Build
      - name: Build
        run: |
          python -m compileall app

      # 7. SonarQube Scan
      - name: SonarQube Scan
        uses: SonarSource/sonarqube-scan-action@v6
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
          SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}

      # 8. Quality Gate
      - name: Quality Gate
        uses: SonarSource/sonarqube-quality-gate-action@v1
        timeout-minutes: 5
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}

      # 9. Docker Image Build
      - name: Docker Image Build
        run: |
          docker build -t hello-world-python:${{ github.sha }} .

      # 10. Success
      - name: SUCCESS
        run: |
          echo "CI Pipeline completed successfully!"
```

## Workflow Explanation

### Trigger

```yaml
on:
  push:
    branches:
      - main
  pull_request:
```

The workflow runs when:

- Code is pushed to the `main` branch.
- A pull request is created or updated.

### Self-Hosted Runner

```yaml
runs-on: self-hosted
```

The pipeline runs on a self-hosted GitHub Actions runner instead of a GitHub-hosted runner.

The runner provides the environment where the following tasks are executed:

```text
GitHub
   ↓
Self-Hosted Runner
   ↓
Python
   ↓
Flake8
   ↓
Pytest
   ↓
SonarQube
   ↓
Docker
```

### SonarQube Authentication

The workflow uses GitHub Actions secrets:

```text
SONAR_TOKEN
SONAR_HOST_URL
```

These values are stored securely in:

```text
GitHub Repository
    ↓
Settings
    ↓
Secrets and variables
    ↓
Actions
```

### Docker Image Tag

The Docker image is tagged with the Git commit SHA:

```yaml
docker build -t hello-world-python:${{ github.sha }} .
```

This creates a unique image tag for each commit.

Example:

```text
hello-world-python:a82f91c
```

---

## Complete Workflow File

The actual `.github/workflows/ci.yml` should contain the active workflow shown above.

The commented-out workflow that was previously used can be removed once the new workflow is confirmed working. Keeping only the active workflow makes the file easier to maintain and understand.

## Technologies Used

| Technology | Purpose |
|---|---|
| Python | Application |
| Flake8 | Linting |
| Pytest | Unit Testing |
| SonarQube | Code Quality and Security Analysis |
| Quality Gate | Quality PASS/FAIL Decision |
| Docker | Container Image |
| GitHub Actions | CI Automation |

---

## Final Result

A successful pipeline should show:

```text
Code Checkout       ✅
Lint                ✅
Unit Tests          ✅
Build               ✅
SonarQube Scan      ✅
Quality Gate        ✅
Docker Image Build  ✅
SUCCESS             ✅
```

This project demonstrates a basic CI workflow where source code is checked, tested, analyzed for quality, validated, and finally packaged into a Docker image.
