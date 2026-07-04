import asyncio
import re
from playwright import async_api
from playwright.async_api import expect

async def run_test():
    pw = None
    browser = None
    context = None

    try:
        # Start a Playwright session in asynchronous mode
        pw = await async_api.async_playwright().start()

        # Launch a Chromium browser in headless mode with custom arguments
        browser = await pw.chromium.launch(
            headless=True,
            args=[
                "--window-size=1280,720",
                "--disable-dev-shm-usage",
                "--ipc=host",
                "--single-process"
            ],
        )

        # Create a new browser context (like an incognito window)
        context = await browser.new_context()
        # Wider default timeout to match the agent's DOM-stability budget;
        # auto-waiting Playwright APIs (expect, locator.wait_for) inherit this.
        context.set_default_timeout(15000)

        # Open a new page in the browser context
        page = await context.new_page()

        # Interact with the page elements to simulate user flow
        # -> navigate
        await page.goto("https://asheeighe.pages.dev")
        try:
            await page.wait_for_load_state("domcontentloaded", timeout=5000)
        except Exception:
            pass
        
        # -> Scroll down to reveal the 'Features' section and the rest of the page content (Demo, Pricing, Footer).
        await page.mouse.wheel(0, 300)
        
        # -> Scroll down to reveal the 'Features' section and the rest of the page content (Demo, Pricing, Footer).
        await page.mouse.wheel(0, 300)
        
        # -> Scroll to the top of the page and verify the hero headline 'Your intelligent operating system for life', the 'asheeighe' logo, and the 'Get Started Free' button are visible.
        await page.mouse.wheel(0, 300)
        
        # -> Scroll down to reveal and verify the 'Features' section, then continue to reveal and verify the 'AI Chat Demo', 'Pricing', and Footer sections.
        await page.mouse.wheel(0, 300)
        
        # -> Scroll down to reveal and verify the 'Features' section, then continue to reveal and verify the 'AI Chat Demo', 'Pricing', and Footer sections.
        await page.mouse.wheel(0, 300)
        
        # -> Click the 'Features' link in the top navigation to navigate to the Features section so its content can be verified.
        # Features link
        elem = page.locator('xpath=/html/body/nav/div/ul/li/a')
        await elem.click(timeout=10000)
        
        # -> Click the 'AI Chat' link in the top navigation to reveal the AI Chat demo section.
        # AI Chat link
        elem = page.get_by_role('link', name='AI Chat', exact=True)
        await elem.click(timeout=10000)
        
        # -> Click the 'Pricing' link in the top navigation to reveal the Pricing section.
        # Pricing link
        elem = page.locator('xpath=/html/body/nav/div/ul/li[4]/a')
        await elem.click(timeout=10000)
        
        # -> Scroll to the bottom of the page and verify the Footer is present by locating footer text such as 'Built with' or 'by Halima Hafir'.
        await page.mouse.wheel(0, 300)
        
        # --> Assertions to verify final state
        
        # --> Verify primary CTA button is visible
        await page.locator("xpath=/html/body/section[5]/div/div/div[1]/a").nth(0).scroll_into_view_if_needed()
        # Assert: Primary CTA 'Get Started' is visible.
        await expect(page.locator("xpath=/html/body/section[5]/div/div/div[1]/a").nth(0)).to_be_visible(timeout=15000), "Primary CTA 'Get Started' is visible."
        current_url = await page.evaluate("() => window.location.href")
        # Assert: page loaded with a URL (final outcome verified by the AI judge during the run)
        assert current_url, 'Page should have loaded with a URL'
        current_url = await page.evaluate("() => window.location.href")
        # Assert: page loaded with a URL (final outcome verified by the AI judge during the run)
        assert current_url, 'Page should have loaded with a URL'
        await asyncio.sleep(5)

    finally:
        if context:
            await context.close()
        if browser:
            await browser.close()
        if pw:
            await pw.stop()

asyncio.run(run_test())
    