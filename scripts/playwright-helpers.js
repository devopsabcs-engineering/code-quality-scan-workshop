/**
 * Playwright browser automation helpers for authenticated web captures.
 *
 * Usage:
 *   node playwright-helpers.js --url <url> --output <file.png> [--storage-state <auth.json>] [--width 1280] [--height 720]
 *
 * Dependencies:
 *   npm install -g playwright
 *   npx playwright install chromium
 */

const { chromium } = require('playwright');
const path = require('path');

async function captureScreenshot(options) {
  const {
    url,
    outputFile,
    storageState,
    width = 1280,
    height = 720,
    waitForSelector,
    waitMs = 3000,
  } = options;

  const launchOptions = {
    headless: true,
  };

  const contextOptions = {
    viewport: { width, height },
  };

  // Load authentication state if provided
  if (storageState) {
    const statePath = path.resolve(storageState);
    try {
      contextOptions.storageState = statePath;
    } catch (err) {
      console.warn(`Warning: Could not load storage state from ${statePath}: ${err.message}`);
    }
  }

  const browser = await chromium.launch(launchOptions);
  const context = await browser.newContext(contextOptions);
  const page = await context.newPage();

  try {
    console.log(`Navigating to: ${url}`);
    await page.goto(url, { waitUntil: 'networkidle', timeout: 30000 });

    // Wait for a specific selector if provided
    if (waitForSelector) {
      console.log(`Waiting for selector: ${waitForSelector}`);
      await page.waitForSelector(waitForSelector, { timeout: 15000 });
    }

    // Additional wait for dynamic content
    await page.waitForTimeout(waitMs);

    // Ensure output directory exists
    const outputDir = path.dirname(outputFile);
    const fs = require('fs');
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    // Capture screenshot
    await page.screenshot({
      path: outputFile,
      fullPage: false,
    });

    console.log(`Screenshot saved: ${outputFile}`);
  } catch (err) {
    console.error(`Error capturing ${url}: ${err.message}`);
    process.exit(1);
  } finally {
    await browser.close();
  }
}

// Parse CLI arguments
function parseArgs() {
  const args = process.argv.slice(2);
  const options = {};

  for (let i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--url':
        options.url = args[++i];
        break;
      case '--output':
        options.outputFile = args[++i];
        break;
      case '--storage-state':
        options.storageState = args[++i];
        break;
      case '--width':
        options.width = parseInt(args[++i], 10);
        break;
      case '--height':
        options.height = parseInt(args[++i], 10);
        break;
      case '--wait-for':
        options.waitForSelector = args[++i];
        break;
      case '--wait-ms':
        options.waitMs = parseInt(args[++i], 10);
        break;
      default:
        console.warn(`Unknown argument: ${args[i]}`);
    }
  }

  if (!options.url || !options.outputFile) {
    console.error('Usage: node playwright-helpers.js --url <url> --output <file.png> [options]');
    console.error('Options:');
    console.error('  --storage-state <file>  Playwright auth state JSON file');
    console.error('  --width <pixels>        Viewport width (default: 1280)');
    console.error('  --height <pixels>       Viewport height (default: 720)');
    console.error('  --wait-for <selector>   CSS selector to wait for');
    console.error('  --wait-ms <ms>          Additional wait time (default: 3000)');
    process.exit(1);
  }

  return options;
}

// Main
const options = parseArgs();
captureScreenshot(options).catch((err) => {
  console.error(`Fatal error: ${err.message}`);
  process.exit(1);
});
