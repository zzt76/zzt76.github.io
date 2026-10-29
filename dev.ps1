[CmdletBinding()]
param(
    [ValidateRange(1024, 65535)][int]$Port = 4000,
    [switch]$Open,
    [switch]$Build,
    [switch]$Install
)

$ErrorActionPreference = 'Stop'
$previousJekyllEnvironment = $env:JEKYLL_ENV
Push-Location -LiteralPath $PSScriptRoot
try {
    $rubyCommand = Get-Command ruby.exe -ErrorAction SilentlyContinue
    if (-not $rubyCommand) { $rubyCommand = Get-Command ruby -ErrorAction SilentlyContinue }
    if (-not $rubyCommand) {
        throw 'Ruby is required. Install Ruby+Devkit from https://rubyinstaller.org/, then reopen your terminal.'
    }
    $rubyPath = $rubyCommand.Source
    function Invoke-Ruby {
        param([string[]]$RubyArguments)
        # Use a real process so native output and Ctrl+C work in both Windows PowerShell and pwsh.
        $quotedArguments = $RubyArguments | ForEach-Object { '"' + ($_ -replace '"', '\"') + '"' }
        $rubyProcess = Start-Process -FilePath $rubyPath -ArgumentList ($quotedArguments -join ' ') -NoNewWindow -Wait -PassThru
        return $rubyProcess.ExitCode
    }
    if ((Invoke-Ruby -RubyArguments @('--version')) -ne 0) {
        throw 'Ruby could not start. Check your Ruby installation.'
    }
    $bundlerPath = Join-Path (Split-Path -Parent $rubyPath) 'bundle'
    if (-not (Test-Path -LiteralPath $bundlerPath)) {
        throw 'Bundler is missing. Run: gem install bundler'
    }

    $dependenciesMissing = (Invoke-Ruby -RubyArguments @($bundlerPath, 'check')) -ne 0
    if ($Install -or $dependenciesMissing) {
        Write-Host 'Installing Jekyll dependencies locally...' -ForegroundColor Cyan
        if ((Invoke-Ruby -RubyArguments @($bundlerPath, 'config', 'set', '--local', 'path', 'vendor/bundle')) -ne 0) { throw 'Could not configure Bundler.' }
        if ((Invoke-Ruby -RubyArguments @($bundlerPath, 'install')) -ne 0) { throw 'Dependency installation failed. Check the output above and retry: .\dev.ps1 -Install' }
    }

    if ($Build) {
        $env:JEKYLL_ENV = 'production'
        if ((Invoke-Ruby -RubyArguments @($bundlerPath, 'exec', 'jekyll', 'build', '--strict_front_matter')) -ne 0) { throw 'The Jekyll build failed.' }
        Write-Host 'Production site built in _site/.' -ForegroundColor Green
    } else {
        $env:JEKYLL_ENV = 'development'
        $liveReloadPort = if ($Port -eq 65535) { 65534 } else { $Port + 1 }
        Write-Host "Preview: http://127.0.0.1:$Port/" -ForegroundColor Green
        Write-Host 'Save a page, post, or stylesheet to rebuild and refresh the browser. Ctrl+C stops the preview.'
        $serveArguments = @('exec', 'jekyll', 'serve', '--host', '127.0.0.1', '--port', $Port, '--livereload', '--livereload-port', $liveReloadPort, '--force_polling')
        if ($Open) { $serveArguments += '--open-url' }
        if ((Invoke-Ruby -RubyArguments (@($bundlerPath) + $serveArguments)) -ne 0) { throw 'The preview stopped with an error. If the port is occupied, try: .\dev.ps1 -Port 4002 -Open' }
    }
} finally {
    $env:JEKYLL_ENV = $previousJekyllEnvironment
    Pop-Location
}
