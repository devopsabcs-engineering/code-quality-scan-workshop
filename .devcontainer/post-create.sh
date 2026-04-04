#!/bin/bash
set -e

DOMAIN="code-quality"
SCANNER_REPO="code-quality-scan-demo-app"
ORG="devopsabcs-engineering"

echo "=========================================="
echo " Code Quality Scan Workshop — Post-Create"
echo "=========================================="

# -----------------------------------------------
# 1. Fork or clone the scanner demo-app as sibling
# -----------------------------------------------
if [ ! -d "../$SCANNER_REPO" ]; then
  echo ""
  echo "Setting up companion demo-app repository..."
  gh repo fork "$ORG/$SCANNER_REPO" --clone -- "../$SCANNER_REPO" 2>/dev/null || \
    git clone "https://github.com/$ORG/$SCANNER_REPO.git" "../$SCANNER_REPO"
  echo "Demo-app repository cloned to ../$SCANNER_REPO"
else
  echo "Demo-app repository already exists at ../$SCANNER_REPO — skipping."
fi

# -----------------------------------------------
# 2. Install ESLint (global for TypeScript linting)
# -----------------------------------------------
echo ""
echo "Installing ESLint..."
npm install -g eslint@latest 2>/dev/null || true

# -----------------------------------------------
# 3. Install Ruff (Python linter)
# -----------------------------------------------
echo ""
echo "Installing Ruff..."
pip install ruff --quiet 2>/dev/null || true

# -----------------------------------------------
# 4. Install jscpd (code duplication detection)
# -----------------------------------------------
echo ""
echo "Installing jscpd..."
npm install -g jscpd@latest 2>/dev/null || true

# -----------------------------------------------
# 5. Install Lizard (cyclomatic complexity)
# -----------------------------------------------
echo ""
echo "Installing Lizard..."
pip install lizard --quiet 2>/dev/null || true

# -----------------------------------------------
# 6. Install golangci-lint (Go linter)
# -----------------------------------------------
echo ""
echo "Installing golangci-lint..."
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$(go env GOPATH)/bin" latest 2>/dev/null || true

# -----------------------------------------------
# 7. Install Playwright for screenshot automation
# -----------------------------------------------
echo ""
echo "Installing Playwright..."
npm install -g playwright 2>/dev/null || true

# -----------------------------------------------
# 8. Install demo-app dependencies (if present)
# -----------------------------------------------
if [ -d "../$SCANNER_REPO/cq-demo-app-001" ]; then
  echo ""
  echo "Installing dependencies for cq-demo-app-001 (TypeScript)..."
  cd "../$SCANNER_REPO/cq-demo-app-001" && npm install 2>/dev/null || true
  cd -
fi

if [ -d "../$SCANNER_REPO/cq-demo-app-002" ]; then
  echo ""
  echo "Installing dependencies for cq-demo-app-002 (Python)..."
  cd "../$SCANNER_REPO/cq-demo-app-002" && pip install -r requirements.txt --quiet 2>/dev/null || true
  cd -
fi

echo ""
echo "=========================================="
echo " Setup complete! Start with Lab 00."
echo "=========================================="
