// Comprehensive Playwright Test Suite
const { chromium, firefox, webkit, test, expect } = require('@playwright/test');

/**
 * This script demonstrates a comprehensive Playwright test suite including:
 * - Test fixtures and annotations
 * - Page object model pattern
 * - Advanced locators and selectors
 * - Network interception and mocking
 * - Authentication and storage state
 * - Visual comparisons and screenshots
 * - API testing capabilities
 * - Accessibility testing
 * - Parallel test execution
 * - Reporting and CI integration
 */

// Page Object Model example
class LoginPage {
  /**
   * @param {import('@playwright/test').Page} page
   */
  constructor(page) {
    this.page = page;
    this.usernameInput = page.locator('#username');
    this.passwordInput = page.locator('#password');
    this.loginButton = page.locator('button[type="submit"]');
    this.errorMessage = page.locator('.error-message');
  }

  /**
   * Navigate to login page
   */
  async goto() {
    await this.page.goto('/login');
  }

  /**
   * Login with credentials
   * @param {string} username
   * @param {string} password
   */
  async login(username, password) {
    await this.usernameInput.fill(username);
    await this.passwordInput.fill(password);
    await this.loginButton.click();
  }
}

// Test fixtures
const test = base.extend({
  loginPage: async ({ page }, use) => {
    const loginPage = new LoginPage(page);
    await use(loginPage);
  },
  authenticatedPage: async ({ browser }, use) => {
    // Create a new context with authentication
    const context = await browser.newContext({
      storageState: 'auth.json'
    });
    const page = await context.newPage();
    await use(page);
    await context.close();
  }
});

// Test suite
test.describe('Authentication tests', () => {
  test.beforeEach(async ({ page }) => {
    // Setup for each test
    await page.route('**/api/login', route => {
      route.fulfill({
        status: 200,
        body: JSON.stringify({ token: 'fake-token' })
      });
    });
  });

  test('successful login', async ({ loginPage, page }) => {
    await loginPage.goto();
    await loginPage.login('user@example.com', 'password123');

    // Assert navigation occurred
    await expect(page).toHaveURL(/dashboard/);

    // Save storage state for authenticated tests
    await page.context().storageState({ path: 'auth.json' });
  });

  test('failed login shows error message', async ({ loginPage }) => {
    // Override the route for this specific test
    await loginPage.page.route('**/api/login', route => {
      route.fulfill({
        status: 401,
        body: JSON.stringify({ error: 'Invalid credentials' })
      });
    });

    await loginPage.goto();
    await loginPage.login('wrong@example.com', 'wrongpassword');

    // Assert error message is displayed
    await expect(loginPage.errorMessage).toBeVisible();
    await expect(loginPage.errorMessage).toContainText('Invalid credentials');
  });
});

// API testing example
test.describe('API tests', () => {
  test('GET request returns expected data', async ({ request }) => {
    const response = await request.get('https://api.example.com/users');
    expect(response.status()).toBe(200);

    const data = await response.json();
    expect(data.users.length).toBeGreaterThan(0);
  });

  test('POST request creates a resource', async ({ request }) => {
    const response = await request.post('https://api.example.com/users', {
      data: {
        name: 'John Doe',
        email: 'john@example.com'
      }
    });

    expect(response.status()).toBe(201);
    const data = await response.json();
    expect(data.id).toBeDefined();
  });
});

// Visual comparison testing
test('visual comparison', async ({ page }) => {
  await page.goto('https://example.com');

  // Take a screenshot and compare with baseline
  await expect(page).toHaveScreenshot('homepage.png', {
    fullPage: true,
    mask: [page.locator('.dynamic-content')],
    threshold: 0.2
  });
});

// Accessibility testing
test('accessibility check', async ({ page }) => {
  await page.goto('https://example.com');

  // Run accessibility audit
  const accessibilityScanResults = await page.accessibility.snapshot();

  // Check for specific accessibility issues
  expect(accessibilityScanResults.children.length).toBeGreaterThan(0);
});

// Mobile device testing
test('responsive design on mobile', async ({ browser }) => {
  // Create context with mobile device emulation
  const context = await browser.newContext({
    ...devices['iPhone 13'],
  });

  const page = await context.newPage();
  await page.goto('https://example.com');

  // Check mobile-specific elements
  const mobileMenu = page.locator('.mobile-menu');
  await expect(mobileMenu).toBeVisible();

  await context.close();
});

// Parallel test execution with sharding
test.describe.configure({ mode: 'parallel' });

// Trace viewer for debugging
test('capture trace for debugging', async ({ page, context }) => {
  await context.tracing.start({ screenshots: true, snapshots: true });

  await page.goto('https://example.com');
  await page.click('text=Login');

  await context.tracing.stop({ path: 'trace.zip' });
});

// Custom test fixtures
test.use({
  viewport: { width: 1920, height: 1080 },
  ignoreHTTPSErrors: true,
  video: 'on-first-retry',
  launchOptions: {
    slowMo: 100,
  }
});

// Run all tests
if (require.main === module) {
  test.run();
}
