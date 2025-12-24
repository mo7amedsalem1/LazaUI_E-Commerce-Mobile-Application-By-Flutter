from appium import webdriver
from appium.webdriver.common.appiumby import AppiumBy
from appium.options.android import UiAutomator2Options
import time

# Update these capabilities for your environment
options = UiAutomator2Options()
options.platform_name = 'Android'
options.automation_name = 'UiAutomator2'
options.device_name = 'emulator-5554'
options.app = '/path/to/your/app/build/app/outputs/flutter-apk/app-debug.apk' 
# Tip: Build the apk using `flutter build apk --debug`

driver = webdriver.Remote('http://localhost:4723', options=options)

try:
    print("Starting Auth Test...")
    
    # Wait for app to load
    time.sleep(5)
    
    # Check if we are on Login Screen (look for "Sign Up" button text or similar)
    # Note: Flutter elements might need Key or specific accessibility info.
    # Assuming text matching for simplicity in MVP.
    
    # Click "Create an Account" if we are not logged in
    # This assumes we start in fresh state or logged out.
    try:
        create_account_btn = driver.find_element(AppiumBy.ACCESSIBILITY_ID, 'Create an Account') 
        # Note: In Flutter Source, wrap TextButton with Semantics(label: 'Create an Account') or use text searching
        # If ID fails, try XPath
    except:
        # Fallback to xpath (less reliable but works for MVP without keys)
        create_account_btn = driver.find_element(AppiumBy.XPATH, '//android.widget.Button[@content-desc="Create an Account"]')
        
    create_account_btn.click()
    time.sleep(2)
    
    # Sign Up Flow
    email_input = driver.find_element(AppiumBy.XPATH, '//android.widget.EditText[1]')
    pass_input = driver.find_element(AppiumBy.XPATH, '//android.widget.EditText[2]')
    
    import random
    email = f"testuser{random.randint(1000,9999)}@example.com"
    email_input.send_keys(email)
    pass_input.send_keys("password123")
    
    signup_btn = driver.find_element(AppiumBy.XPATH, '//android.widget.Button[@content-desc="Sign Up"]')
    signup_btn.click()
    
    time.sleep(5)
    
    # Verify we are back on Login or Home? 
    # Current implementation pops back to Login after signup.
    
    # Login Flow
    print(f"Logging in with {email}...")
    email_input_login = driver.find_element(AppiumBy.XPATH, '//android.widget.EditText[1]')
    pass_input_login = driver.find_element(AppiumBy.XPATH, '//android.widget.EditText[2]')
    
    email_input_login.send_keys(email)
    pass_input_login.send_keys("password123")
    
    login_btn = driver.find_element(AppiumBy.XPATH, '//android.widget.Button[@content-desc="Login"]')
    login_btn.click()
    
    time.sleep(5)
    
    # Verify Home Screen
    # Check for "Laza" title
    laza_title = driver.find_element(AppiumBy.XPATH, '//android.view.View[@content-desc="Laza"]')
    assert laza_title.is_displayed()
    
    print("Auth Test PASSED")

except Exception as e:
    print(f"Auth Test FAILED: {e}")
finally:
    driver.quit()
