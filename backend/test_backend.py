#!/usr/bin/env python3
"""
Simple test script to verify the inSwing backend is working correctly.
"""

import requests
import json
import time
import random
import string

def generate_phone():
    """Generate a random phone number for testing."""
    return f"+91{random.randint(7000000000, 9999999999)}"

def generate_name():
    """Generate a random name for testing."""
    first_names = ["Rahul", "Virat", "Rohit", "Hardik", "Jasprit", "Bhuvneshwar", "Yuvraj", "MS", "Sachin", "Virender"]
    last_names = ["Sharma", "Kohli", "Dhoni", "Tendulkar", "Dravid", "Ganguly", "Sehwag", "Bumrah", "Pandya", "Kumar"]
    return f"{random.choice(first_names)} {random.choice(last_names)}"

def test_health_check():
    """Test the health check endpoint."""
    print("Testing health check...")
    try:
        response = requests.get("http://localhost:8000/health")
        if response.status_code == 200:
            print("✅ Health check passed")
            return True
        else:
            print(f"❌ Health check failed: {response.status_code}")
            return False
    except requests.exceptions.ConnectionError:
        print("❌ Could not connect to backend. Make sure it's running on port 8000.")
        return False

def test_api_info():
    """Test the API info endpoint."""
    print("\nTesting API info...")
    try:
        response = requests.get("http://localhost:8000/")
        if response.status_code == 200:
            data = response.json()
            print(f"✅ API info retrieved: {data.get('message', 'Unknown')}")
            return True
        else:
            print(f"❌ API info failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ API info error: {e}")
        return False

def test_docs_accessible():
    """Test that API documentation is accessible."""
    print("\nTesting API documentation...")
    try:
        # Test Swagger UI
        response = requests.get("http://localhost:8000/docs")
        if response.status_code == 200:
            print("✅ Swagger UI is accessible")
            return True
        else:
            print(f"❌ Swagger UI not accessible: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Documentation error: {e}")
        return False

def test_authentication_flow():
    """Test the complete authentication flow."""
    print("\nTesting authentication flow...")
    
    # Generate test user data
    phone = generate_phone()
    print(f"Using test phone: {phone}")
    
    try:
        # Step 1: Login (send OTP)
        print("Step 1: Sending login request...")
        login_data = {"phone": phone}
        login_response = requests.post("http://localhost:8000/api/v1/auth/login", json=login_data)
        
        if login_response.status_code == 200:
            print("✅ Login request successful")
            login_result = login_response.json()
            print(f"   Session ID: {login_result.get('session_id', 'N/A')}")
        else:
            print(f"❌ Login request failed: {login_response.status_code}")
            print(f"   Response: {login_response.text}")
            return False
        
        # Note: In a real test, you would need to get the actual OTP from the server/database
        # For this test, we'll just verify the endpoint is working
        print("✅ Authentication endpoints are responding (OTP verification would need actual OTP)")
        return True
        
    except Exception as e:
        print(f"❌ Authentication flow error: {e}")
        return False

def test_user_endpoints():
    """Test user-related endpoints (without authentication)."""
    print("\nTesting user endpoints...")
    
    try:
        # Test user search (should work without auth)
        search_response = requests.get("http://localhost:8000/api/v1/users/search", params={"query": "test"})
        if search_response.status_code in [200, 401]:  # 401 is expected without auth
            print("✅ User search endpoint is accessible")
            return True
        else:
            print(f"❌ User search failed: {search_response.status_code}")
            return False
            
    except Exception as e:
        print(f"❌ User endpoints error: {e}")
        return False

def test_match_endpoints():
    """Test match-related endpoints."""
    print("\nTesting match endpoints...")
    
    try:
        # Test match listing (should work without auth)
        matches_response = requests.get("http://localhost:8000/api/v1/matches")
        if matches_response.status_code in [200, 401]:  # 401 is expected without auth
            print("✅ Match listing endpoint is accessible")
            return True
        else:
            print(f"❌ Match listing failed: {matches_response.status_code}")
            return False
            
    except Exception as e:
        print(f"❌ Match endpoints error: {e}")
        return False

def test_leaderboard_endpoints():
    """Test leaderboard endpoints."""
    print("\nTesting leaderboard endpoints...")
    
    try:
        # Test batting leaderboard
        batting_response = requests.get("http://localhost:8000/api/v1/leaderboards/batting")
        if batting_response.status_code in [200, 401]:  # 401 is expected without auth
            print("✅ Batting leaderboard endpoint is accessible")
        else:
            print(f"❌ Batting leaderboard failed: {batting_response.status_code}")
        
        # Test bowling leaderboard
        bowling_response = requests.get("http://localhost:8000/api/v1/leaderboards/bowling")
        if bowling_response.status_code in [200, 401]:  # 401 is expected without auth
            print("✅ Bowling leaderboard endpoint is accessible")
            return True
        else:
            print(f"❌ Bowling leaderboard failed: {bowling_response.status_code}")
            return False
            
    except Exception as e:
        print(f"❌ Leaderboard endpoints error: {e}")
        return False

def test_search_endpoints():
    """Test search endpoints."""
    print("\nTesting search endpoints...")
    
    try:
        # Test user search
        user_search_response = requests.get("http://localhost:8000/api/v1/search/users", params={"query": "test"})
        if user_search_response.status_code in [200, 401]:  # 401 is expected without auth
            print("✅ User search endpoint is accessible")
        else:
            print(f"❌ User search failed: {user_search_response.status_code}")
        
        # Test match search
        match_search_response = requests.get("http://localhost:8000/api/v1/search/matches", params={"query": "test"})
        if match_search_response.status_code in [200, 401]:  # 401 is expected without auth
            print("✅ Match search endpoint is accessible")
            return True
        else:
            print(f"❌ Match search failed: {match_search_response.status_code}")
            return False
            
    except Exception as e:
        print(f"❌ Search endpoints error: {e}")
        return False

def main():
    """Run all tests."""
    print("🚀 Starting inSwing Backend Tests")
    print("=" * 50)
    
    tests = [
        ("Health Check", test_health_check),
        ("API Info", test_api_info),
        ("Documentation", test_docs_accessible),
        ("Authentication Flow", test_authentication_flow),
        ("User Endpoints", test_user_endpoints),
        ("Match Endpoints", test_match_endpoints),
        ("Leaderboard Endpoints", test_leaderboard_endpoints),
        ("Search Endpoints", test_search_endpoints),
    ]
    
    passed = 0
    total = len(tests)
    
    for test_name, test_func in tests:
        try:
            if test_func():
                passed += 1
            time.sleep(0.5)  # Small delay between tests
        except Exception as e:
            print(f"❌ {test_name} test failed with exception: {e}")
    
    print("\n" + "=" * 50)
    print(f"📊 Test Results: {passed}/{total} tests passed")
    
    if passed == total:
        print("🎉 All tests passed! The backend appears to be working correctly.")
        return 0
    else:
        print("⚠️  Some tests failed. Please check the backend logs for more details.")
        return 1

if __name__ == "__main__":
    exit(main())