#!/bin/bash

# Minimal test suite for kata-audit-runner.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUDIT_RUNNER="$SCRIPT_DIR/kata-audit-runner.sh"
TEST_REPO="$SCRIPT_DIR/examples/sample_kata_repo"

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Test counter
TESTS_RUN=0
TESTS_PASSED=0

# Test helper functions
test_start() {
    echo -n "Testing $1... "
    ((TESTS_RUN++))
}

test_pass() {
    echo -e "${GREEN}PASSED${NC}"
    ((TESTS_PASSED++))
}

test_fail() {
    echo -e "${RED}FAILED${NC}: $1"
}

# Create sample test repository
setup_test_repo() {
    mkdir -p "$TEST_REPO/src" "$TEST_REPO/tests"
    
    # Create a complex function for pattern detection
    cat > "$TEST_REPO/src/complex_function.py" << 'EOF'
def calculate_order_total(order_items, customer_type, discount_code):
    """Complex function that needs refactoring"""
    total = 0
    discount = 0
    
    # Calculate base total
    for item in order_items:
        if item['quantity'] > 0:
            if item['price'] > 0:
                subtotal = item['quantity'] * item['price']
                if customer_type == 'premium':
                    if item['category'] == 'electronics':
                        subtotal = subtotal * 0.9
                    elif item['category'] == 'clothing':
                        subtotal = subtotal * 0.85
                elif customer_type == 'regular':
                    if item['category'] == 'electronics':
                        subtotal = subtotal * 0.95
                total += subtotal
    
    # Apply discount codes
    if discount_code:
        if discount_code == 'SAVE10':
            discount = total * 0.1
        elif discount_code == 'SAVE20':
            discount = total * 0.2
        elif discount_code == 'HALFOFF':
            discount = total * 0.5
    
    # Calculate tax
    tax_rate = 0.08
    if customer_type == 'business':
        tax_rate = 0.06
    
    final_total = (total - discount) * (1 + tax_rate)
    
    return final_total
EOF

    # Create untested function
    cat > "$TEST_REPO/src/untested.js" << 'EOF'
export function parseUserInput(input) {
    if (!input || typeof input !== 'string') {
        return null;
    }
    
    const parts = input.split(':');
    if (parts.length !== 2) {
        return null;
    }
    
    return {
        username: parts[0].trim(),
        action: parts[1].trim()
    };
}
EOF
}

# Test 1: Script exists and is executable
test_start "Script exists and is executable"
if [[ -x "$AUDIT_RUNNER" ]]; then
    test_pass
else
    test_fail "Script not found or not executable"
fi

# Test 2: Help option works
test_start "Help option"
if "$AUDIT_RUNNER" --help | grep -q "Usage:"; then
    test_pass
else
    test_fail "Help output not as expected"
fi

# Test 3: Setup test repository
test_start "Setting up test repository"
setup_test_repo
if [[ -d "$TEST_REPO" ]]; then
    test_pass
else
    test_fail "Failed to create test repository"
fi

# Test 4: Run basic audit
test_start "Basic audit execution"
if "$AUDIT_RUNNER" "$TEST_REPO" > /dev/null 2>&1; then
    test_pass
else
    test_fail "Basic audit failed"
fi

# Test 5: JSON output format
test_start "JSON output format"
if OUTPUT=$("$AUDIT_RUNNER" --format json "$TEST_REPO" 2>/dev/null) && echo "$OUTPUT" | python -m json.tool > /dev/null 2>&1; then
    test_pass
else
    test_fail "JSON output is invalid"
fi

# Test 6: Markdown output format
test_start "Markdown output format"
if "$AUDIT_RUNNER" --format markdown "$TEST_REPO" 2>/dev/null | grep -q "# Kata Audit Results"; then
    test_pass
else
    test_fail "Markdown output not as expected"
fi

# Test 7: Output to file
test_start "Output to file"
OUTPUT_FILE="$SCRIPT_DIR/test_output.json"
if "$AUDIT_RUNNER" --output "$OUTPUT_FILE" "$TEST_REPO" > /dev/null 2>&1 && [[ -f "$OUTPUT_FILE" ]]; then
    test_pass
    rm -f "$OUTPUT_FILE"
else
    test_fail "Failed to write output to file"
fi

# Test 8: Invalid repository path
test_start "Invalid repository path handling"
if ! "$AUDIT_RUNNER" "/nonexistent/path" > /dev/null 2>&1; then
    test_pass
else
    test_fail "Should fail for invalid path"
fi

# Test 9: Specific audit type
test_start "Specific audit type (patterns)"
if "$AUDIT_RUNNER" --type patterns "$TEST_REPO" > /dev/null 2>&1; then
    test_pass
else
    test_fail "Pattern audit failed"
fi

# Test 10: Unknown audit type
test_start "Unknown audit type handling"
if ! "$AUDIT_RUNNER" --type unknown "$TEST_REPO" > /dev/null 2>&1; then
    test_pass
else
    test_fail "Should fail for unknown audit type"
fi

# Cleanup
rm -rf "$TEST_REPO"

# Summary
echo ""
echo "========================================="
echo "Test Summary: $TESTS_PASSED/$TESTS_RUN tests passed"
echo "========================================="

if [[ $TESTS_PASSED -eq $TESTS_RUN ]]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
fi