from appium import webdriver
from appium.webdriver.common.appiumby import AppiumBy
from appium.options.android import UiAutomator2Options
import time

options = UiAutomator2Options()
options.platform_name = 'Android'
options.automation_name = 'UiAutomator2'
options.device_name = 'emulator-5554'
options.app = '/path/to/your/app/build/app/outputs/flutter-apk/app-debug.apk'

driver = webdriver.Remote('http://localhost:4723', options=options)

try:
    print("Starting Cart Test...")
    time.sleep(5)
    
    # Assumption: User is already logged in from previous test or manual run.
    # Check if we are on Home. If not, log in.
    
    # 1. Select first product on Home Screen
    # Grid items are likely ViewGroups/Views.
    # Let's tap approximately center or find first image.
    product_images = driver.find_elements(AppiumBy.CLASS_NAME, "android.widget.ImageView")
    if product_images:
        product_images[0].click()
    else:
        print("No products found? Check network/API")
        exit(1)
        
    time.sleep(2)
    
    # 2. Add to Cart
    add_cart_btn = driver.find_element(AppiumBy.XPATH, '//android.widget.Button[@content-desc="Add to Cart"]')
    add_cart_btn.click()
    
    time.sleep(1)
    # 3. Go Back
    driver.back()
    
    time.sleep(1)
    
    # 4. Navigate to Cart (Bottom Nav Index 2)
    # BottomBar items: Home, Wishlist, Cart, Profile.
    # Finding by icon or description.
    cart_tab = driver.find_element(AppiumBy.XPATH, '//android.view.View[@content-desc="Cart"]')
    cart_tab.click()
    
    time.sleep(2)
    
    # 5. Verify Item in Cart
    # Check for list items or specific text
    # Assuming the first item is there.
    total_text = driver.find_element(AppiumBy.XPATH, '//*[contains(@content-desc, "Total") or contains(@text, "Total")]')
    assert total_text.is_displayed()
    
    print("Cart Test PASSED")

except Exception as e:
    print(f"Cart Test FAILED: {e}")
finally:
    driver.quit()
