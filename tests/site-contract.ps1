$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$html = Get-Content -Raw -Encoding utf8 (Join-Path $root 'index.html')
$css = Get-Content -Raw -Encoding utf8 (Join-Path $root 'style.css')
$scriptPath = Join-Path $root 'script.js'
$clientScript = if (Test-Path $scriptPath) {
  Get-Content -Raw -Encoding utf8 $scriptPath
} else {
  ''
}

$failures = [System.Collections.Generic.List[string]]::new()

function Assert-Match {
  param(
    [string]$Value,
    [string]$Pattern,
    [string]$Message
  )

  if ($Value -notmatch $Pattern) {
    $script:failures.Add($Message)
  }
}

function Assert-Literal {
  param(
    [string]$Value,
    [string]$Expected,
    [string]$Message
  )

  Assert-Match $Value ([regex]::Escape($Expected)) $Message
}

function Assert-Count {
  param(
    [string]$Value,
    [string]$Pattern,
    [int]$Expected,
    [string]$Message
  )

  $actual = [regex]::Matches($Value, $Pattern).Count
  if ($actual -ne $Expected) {
    $script:failures.Add("$Message (expected $Expected, found $actual)")
  }
}

Assert-Literal $html 'Junru Zhang' 'Missing English name'
$chineseName = -join ([char[]](0x5F20, 0x541B, 0x5982))
Assert-Literal $html $chineseName 'Missing Chinese name'
Assert-Literal $html 'PhD Student @ ZJU &amp; Visiting @ NTU' 'Position wording changed from the source homepage'
Assert-Literal $html 'junruzhang@zju.edu.cn' 'Missing ZJU email'
Assert-Literal $html 'jrzhang1999@gmail.com' 'Missing Gmail address'
Assert-Literal $html 'Google Scholar' 'Missing Google Scholar link'
Assert-Literal $html 'GitHub' 'Missing GitHub link'
Assert-Literal $html 'LinkedIn' 'Missing LinkedIn link'

$researchTopics = @(
  'LLMs for Time Series',
  'Time Series Analysis',
  'Generative Models',
  'Transfer Learning',
  'Federated Learning'
)

foreach ($topic in $researchTopics) {
  Assert-Literal $html $topic "Missing research topic: $topic"
}

Assert-Count $html 'data-research-topic' 5 'Research topic count changed'

$aboutNames = @(
  'Prof. Duanqing Xu',
  'Prof. Yabo Dong',
  'Prof. Han Yu',
  'Zhejiang University',
  'Nanyang Technological University'
)

foreach ($name in $aboutNames) {
  Assert-Literal $html $name "Missing About Me information: $name"
}

Assert-Literal $html 'TimeMaster: Training Time-Series Multimodal LLMs to Reason via Reinforcement Learning' 'Missing TimeMaster preprint'
Assert-Literal $html 'https://arxiv.org/pdf/2506.13705' 'Missing TimeMaster paper link'
Assert-Literal $html 'https://github.com/langfengQ/TimeMaster' 'Missing TimeMaster code link'

$publicationTitles = @(
  'Federated Domain Generalization for Time-Series Classification via Dynamics-to-Domain Generation',
  'AnomSeer: Reinforcing Multimodal LLMs to Reason for Time-Series Anomaly Detection',
  'FedDiG: Frequency-Guided Diffusion Diversity for Generalizable Federated Time Series Classification',
  'Diffusion-Guided Diversity for Single Domain Generalization in Time Series Classification',
  'DI2SDiff++: Activity Style Decomposition and Diffusion-Based Fusion for Cross-Person Generalization in Activity Recognition',
  'Diverse Intra- and Inter-Domain Activity Style Fusion for Cross-Person Generalization in Activity Recognition',
  "Temporal Convolutional Explorer Helps Understand 1D-CNN's Learning Behavior in Time Series Classification from Frequency Domain",
  'Adacket: ADAptive Convolutional KErnel Transform for Multivariate Time Series Classification',
  'A Unified Framework for Modeling Heterogeneous Financial Data via Dual-Granularity Prompting'
)

foreach ($title in $publicationTitles) {
  Assert-Literal $html $title "Missing selected publication: $title"
}

Assert-Count $html '<article class="publication" data-year="(?:2023|2024|2025|2026)"' 9 'Selected publication count changed'
Assert-Count $html 'data-publication-filter=' 4 'Publication filter count changed'
Assert-Match $html 'data-publication-filter="all"[^>]*aria-pressed="true"' 'All filter must be selected by default'
Assert-Literal $html 'IEEE Transactions on Mobile Computing' 'Full IEEE Transactions on Mobile Computing venue name was shortened'
Assert-Count $html '<a[^>]+aria-label="(?:Paper|Code): [^"]+"' 16 'Publication action links need descriptive accessible names'

$serviceItems = @(
  'Program Committee (PC) Member',
  'ACM SIGKDD Conference on Knowledge Discovery and Data Mining (KDD) 2025',
  'AAAI Conference on Artificial Intelligence (AAAI) 2025',
  'IEEE International Conference on Multimedia and Expo (ICME) 2025',
  'ACM International Conference on Information and Knowledge Management (CIKM) 2024',
  'Reviewer',
  'IEEE Transactions on Knowledge and Data Engineering (TKDE)',
  'ACM Transactions on Knowledge Discovery from Data (TKDD)',
  'IEEE Transactions on Industrial Informatics (TII)',
  'IEEE Transactions on Neural Networks and Learning Systems (TNNLS)'
)

foreach ($item in $serviceItems) {
  Assert-Literal $html $item "Missing academic service: $item"
}

Assert-Literal $html 'Created by Junru Zhang' 'Missing approved footer attribution'
Assert-Match $html '(?:\u00A9|&copy;) 2026 Junru' 'Missing copyright notice'
Assert-Literal $html 'Last updated May 2026' 'Missing last-updated date'
Assert-Match $html '<script src="script\.js" defer></script>' 'Missing deferred interaction script'
Assert-Match $html 'target="_blank" rel="noopener noreferrer"' 'External links need safe new-tab attributes'

Assert-Match $css '--color-paper:' 'Missing sage paper color token'
Assert-Match $css '--color-paper-deep:' 'Missing secondary sage paper token'
Assert-Match $css '@media \(max-width: 800px\)' 'Missing responsive breakpoint'
Assert-Match $css '@media \(max-width: 480px\)' 'Missing small-screen breakpoint'
Assert-Match $css 'prefers-reduced-motion' 'Missing reduced-motion support'
Assert-Match $css ':focus-visible' 'Missing visible keyboard focus styling'
Assert-Match $css '\.js-enabled \.menu-toggle' 'Mobile menu must collapse only when JavaScript is available'
Assert-Match $css '\.js-enabled \.nav-links' 'Mobile navigation needs a no-JavaScript fallback'

Assert-Match $clientScript 'data-publication-filter' 'Missing publication filter logic'
Assert-Match $clientScript "documentElement\.classList\.add\('js-enabled'\)" 'JavaScript capability class is not applied'
Assert-Match $clientScript "setAttribute\('aria-pressed'" 'Filter buttons do not expose state'
Assert-Match $clientScript "setAttribute\('aria-expanded'" 'Mobile menu does not expose state'
Assert-Match $clientScript 'publication\.hidden' 'Publication visibility is not updated'

if ($failures.Count -gt 0) {
  $failures | ForEach-Object { Write-Output "FAIL: $_" }
  exit 1
}

Write-Output 'PASS: static site contract'
