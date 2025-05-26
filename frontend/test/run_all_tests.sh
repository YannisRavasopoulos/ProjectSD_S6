#!/bin/bash

# This script runs all the tests in the frontend directory. Run it with:
#chmod +x run_all_tests.sh
#./run_all_tests.sh
echo "Running user repository tests..."
dart test -r expanded user_repository_testing.dart

echo ""
echo "Running reports repository tests..."
dart test -r expanded reports_repository_testing.dart

echo ""
echo "Running rewards repository tests..."
dart test -r expanded rewards_repository_testing.dart

echo ""
echo "Running ratings repository tests..."
dart test -r expanded rating_repository_testing.dart

echo ""
echo "All tests completed."