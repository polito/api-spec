#!/usr/bin/env node

import { Command } from 'commander';
import { spawn } from 'child_process';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import { existsSync, readdirSync, statSync, readFileSync, mkdtempSync, rmSync } from 'fs';
import { tmpdir } from 'os';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT_DIR = join(__dirname, '..');
const CLIENTS_DIR = join(ROOT_DIR, 'src/clients');

const CONFIG = {
  gitUserId: "polito",
  gitRepoId: "api-spec",
  npmRepository: "https://npm.pkg.github.com/",
  generator: "typescript-fetch",
};

const colors = {
  red: "\x1b[31m",
  reset: "\x1b[0m",
  green: "\x1b[32m",
  yellow: "\x1b[33m",
  blue: "\x1b[34m",
  cyan: "\x1b[36m",
};

let verbose = false;

function log(color, ...args) {
  console.log(`${color}[apimanager]${colors.reset}`, ...args);
}

function debug(...args) {
  if (verbose) {
    log(colors.yellow, '[debug]', ...args);
  }
}

function discoverClients() {
  if (!existsSync(CLIENTS_DIR)) {
    return [];
  }
  return readdirSync(CLIENTS_DIR).filter((name) => {
    const clientPath = join(CLIENTS_DIR, name);
    const mainFile = join(clientPath, "main.tsp");
    return statSync(clientPath).isDirectory() && existsSync(mainFile);
  });
}

function getClientConfig(clientName) {
  return {
    srcDir: `src/clients/${clientName}`,
    outputDir: `dist/clients/${clientName}`,
    npmName: `@polito/${clientName}-api-client`,
    localAppDir: `./${clientName}-app`,
  };
}

function runCommand(command, args, options = {}) {
  return new Promise((resolve, reject) => {
    debug(`Running: ${command} ${args.join(' ')}`);

    const prc = spawn(command, args, {
      cwd: ROOT_DIR,
      stdio: 'inherit',
      shell: true,
      ...options,
    });

    prc.on('close', (code) => {
      if (code === 0) {
        resolve();
      } else {
        reject(new Error(`Command failed with exit code ${code}`));
      }
    });

    prc.on("error", reject);
  });
}

async function compileClient(clientName) {
  const { srcDir, outputDir } = getClientConfig(clientName);
  log(colors.cyan, `Compiling ${clientName}...`);
  await runCommand("tsp", ["compile", srcDir, "--output-dir", outputDir]);
  log(colors.green, `Compiled ${clientName}`);
}

async function generateClient(clientName) {
  const { outputDir, npmName } = getClientConfig(clientName);
  const clientDir = `${outputDir}/client`;
  const openapiFile = `${outputDir}/openapi.yaml`;

  log(colors.cyan, `Generating client for ${clientName}...`);
  await runCommand("rm", ["-rf", clientDir]);

  const additionalProps = [
    `npmName=${npmName}`,
    `npmRepository=${CONFIG.npmRepository}`,
    "supportsES6=true",
    "modelPropertyNaming=original",
    "removeOperationIdPrefix=true",
  ].join(",");

  await runCommand("npx", [
    "openapi-generator-cli",
    "generate",
    "-i", openapiFile,
    "-g", CONFIG.generator,
    "-o", clientDir,
    `--git-user-id=${CONFIG.gitUserId}`,
    `--git-repo-id=${CONFIG.gitRepoId}`,
    `--additional-properties=${additionalProps}`,
  ]);

  await runCommand("cp", [openapiFile, `${clientDir}/openapi.yaml`]);
  log(colors.green, `Generated client for ${clientName}`);
}

async function deployLocalClient(clientName, targetDir) {
  await compileClient(clientName);
  await generateClient(clientName);
  await copyLocalClient(clientName, targetDir);
}

async function copyLocalClient(clientName, targetDir) {
  const { outputDir, npmName, localAppDir } = getClientConfig(clientName);
  const clientDir = `${outputDir}/client`;
  const finalTargetDir = targetDir || `${localAppDir}/node_modules/${npmName}`;

  log(colors.cyan, `Copying ${clientName} to ${finalTargetDir}...`);
  await runCommand("rm", ["-rf", `${finalTargetDir}/*`]);
  await runCommand("rsync", ["-av", `${clientDir}/`, `${finalTargetDir}/`]);
  await runCommand("npm", ["run", "build"], { cwd: join(ROOT_DIR, finalTargetDir) });
  log(colors.green, `Copied ${clientName} to local app`);
}

async function checkClient(clientName) {
  const { srcDir, outputDir } = getClientConfig(clientName);
  const tmpDir = mkdtempSync(join(tmpdir(), 'tsp-check-'));

  try {
    log(colors.cyan, `Checking ${clientName}...`);
    await runCommand("tsp", ["compile", srcDir, "--output-dir", tmpDir]);

    const currentFile = join(ROOT_DIR, outputDir, "openapi.yaml");
    const tmpFile = join(tmpDir, "openapi.yaml");

    if (!existsSync(currentFile)) {
      log(colors.red, `${clientName}: dist openapi.yaml not found`);
      return false;
    }

    const current = readFileSync(currentFile, "utf-8");
    const compiled = readFileSync(tmpFile, "utf-8");

    if (current !== compiled) {
      log(colors.red, `${clientName}: OpenAPI spec is out of date`);
      return false;
    }

    log(colors.green, `${clientName}: up to date`);
    return true;
  } finally {
    rmSync(tmpDir, { recursive: true, force: true });
  }
}

async function formatFiles() {
  log(colors.cyan, "Formatting TypeSpec files...");
  await runCommand("tsp", ["format", "src/**/*.tsp"]);
  log(colors.green, "Formatted all .tsp files");
}

function resolveClients(clientArg, availableClients, { allowAll = true } = {}) {
  const client = clientArg;

  if (client === 'all') {
    if (!allowAll) {
      log(colors.red, "The 'all' option is not supported for this command");
      log(colors.yellow, `Available clients: ${availableClients.join(", ") || "(none)"}`);
      process.exit(1);
    }
    if (availableClients.length === 0) {
      log(colors.red, "No clients found in src/clients/");
      process.exit(1);
    }
    return availableClients;
  }
  if (!availableClients.includes(client)) {
    log(colors.red, `Client not found: ${client}`);
    log(colors.yellow, `Available clients: ${availableClients.join(", ") || "(none)"}`);
    process.exit(1);
  }
  return [client];
}

async function runForClients(clients, action) {
  for (const client of clients) {
    log(colors.blue, `\n=== ${client} ===\n`);
    await action(client);
  }
}

const program = new Command();
const availableClients = discoverClients();

const banner = `${colors.cyan}               __
 .---.-.-----|__.--------.---.-.-----.---.-.-----.-----.----.
 |  _  |  _  |  |        |  _  |     |  _  |  _  |  -__|   _|
 |___._|   __|__|__|__|__|___._|__|__|___._|___  |_____|__|
       |__|                                |_____|           ${colors.reset}`;

program
  .name('apimanager')
  .description('CLI to manage TypeSpec API clients')
  .version('1.0.0')
  .addHelpText('beforeAll', banner)
  .option('-v, --verbose', 'enable verbose output')
  .hook('preAction', (thisCommand) => {
    verbose = thisCommand.opts().verbose || false;
  });

program
  .command('compile')
  .description('Compile TypeSpec to OpenAPI')
  .argument('<client>', `client name or "all" (available: ${availableClients.join(', ') || 'none'})`)
  .action(async (client) => {
    const clients = resolveClients(client, availableClients);
    await runForClients(clients, compileClient);
    log(colors.green, "Done!");
  });

program
  .command('generate')
  .description('Generate TypeScript client from OpenAPI spec')
  .argument('<client>', `client name or "all" (available: ${availableClients.join(', ') || 'none'})`)
  .action(async (client) => {
    const clients = resolveClients(client, availableClients);
    await runForClients(clients, generateClient);
    log(colors.green, "Done!");
  });

program
  .command('deploy-local')
  .description('Build and deploy client to local app (compile + generate + copy)')
  .argument('<client>', `client name or "all" (available: ${availableClients.join(', ') || 'none'})`)
  .option('-t, --target <dir>', 'custom target directory (overrides default)')
  .action(async (client, options) => {
    const clients = resolveClients(client, availableClients);
    await runForClients(clients, (c) => deployLocalClient(c, options.target));
    log(colors.green, "Done!");
  });

program
  .command('check')
  .description('Check if OpenAPI specs are up to date (without modifying files)')
  .argument('<client>', `client name or "all" (available: ${availableClients.join(', ') || 'none'})`)
  .action(async (client) => {
    const clients = resolveClients(client, availableClients);
    const outdated = [];
    for (const c of clients) {
      log(colors.blue, `\n=== ${c} ===\n`);
      const ok = await checkClient(c);
      if (!ok) outdated.push(c);
    }
    if (outdated.length > 0) {
      const suggestion = outdated.length === availableClients.length
        ? "npm run compile all"
        : outdated.map(c => `npm run compile ${c}`).join(" && ");
      log(colors.red, `\nRun '${suggestion}' to update.`);
      process.exit(1);
    }
    log(colors.green, "Done!");
  });

program
  .command('format')
  .description('Format all TypeSpec files')
  .action(async () => {
    await formatFiles();
    log(colors.green, "Done!");
  });

program
  .command('list')
  .alias('ls')
  .description('List available clients')
  .action(() => {
    if (availableClients.length === 0) {
      log(colors.yellow, "No clients found in src/clients/");
      return;
    }
    console.log(`\n${colors.cyan}Available clients:${colors.reset}`);
    for (const client of availableClients) {
      const config = getClientConfig(client);
      console.log(`  ${colors.green}${client}${colors.reset}`);
      console.log(`    Source:  ${config.srcDir}`);
      console.log(`    Output:  ${config.outputDir}`);
      console.log(`    Package: ${config.npmName}`);
    }
    console.log();
  });

program.parseAsync(process.argv).catch((err) => {
  log(colors.red, err.message);
  process.exit(1);
});
