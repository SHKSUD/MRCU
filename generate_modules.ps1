$basePath = Split-Path -Parent $MyInvocation.MyCommand.Path
$modulesPath = Join-Path $basePath "modules"
New-Item -ItemType Directory -Force -Path $modulesPath | Out-Null

$levelDefs = @(
  @("L1",  "Awareness Training",       "#0A1D44"),
  @("L2",  "Operator Training",        "#1A5276"),
  @("L3A", "Fleet Management",         "#1A7A4A"),
  @("L3B", "Systems Integration",      "#7D6608"),
  @("L4A", "Supervisor Operations",    "#922B21"),
  @("L4B", "Supervisor Maintenance",   "#76448A"),
  @("L5",  "Technical Certification",  "#17202A")
)

$titleMap = @{}
$titleMap["L1"]  = @("What is MoRo","MoRo in Your Workplace","Control Interfaces and Operations","Working Safely Alongside MoRo","Incident Reporting and Escalation")
$titleMap["L2"]  = @("Operator Role and Responsibilities","Starting and Stopping Procedures","Mission Assignment and Monitoring","Troubleshooting Common Issues","End of Shift Handover")
$titleMap["L3A"] = @("Fleet Overview and Configuration","Multi-Robot Coordination","Route Planning and Optimisation","Fleet Monitoring and Analytics","Fleet Incident Management")
$titleMap["L3B"] = @("Integration Overview","Conveyor and Machine Integration","WMS and ERP Integration","API and Data Exchange","Integration Testing and Validation")
$titleMap["L4A"] = @("Supervisor Role in AMR Operations","Performance Metrics and KPIs","Shift Management with MoRo","Safety Oversight and Compliance","Continuous Improvement")
$titleMap["L4B"] = @("Preventive Maintenance Overview","Hardware Inspection Procedures","Software Updates and Calibration","Battery and Charging Management","Maintenance Documentation")
$titleMap["L5"]  = @("System Architecture Deep Dive","ANT Navigation Advanced Concepts","Sensor Calibration and Diagnostics","Network and Communication Systems","Certification Assessment")

$secTitles = @("Introduction","Core Concepts","Procedures and Practice","Common Scenarios","Summary and Key Takeaways")

$count = 0

foreach ($ld in $levelDefs) {
  $lid      = $ld[0]
  $lname    = $ld[1]
  $lcolor   = $ld[2]
  $titles   = $titleMap[$lid]

  for ($m = 1; $m -le 5; $m++) {
    $mid   = "$lid-M$m"
    $title = $titles[$m - 1]
    $prev  = if ($m -eq 1) { "null" } else { """$lid-M$($m-1)""" }
    $next  = if ($m -eq 5) { "null" } else { """$lid-M$($m+1)""" }
    $preq  = if ($m -eq 1) { "null" } else { """$lid-M$($m-1) (80%)""" }

    $sectionsJson = ""
    for ($s = 1; $s -le 5; $s++) {
      $st = $secTitles[$s - 1]
      $pad = "{0:D2}" -f $s
      if ($s -gt 1) { $sectionsJson += "," }
      $sectionsJson += @"

    {
      "sectionId": $s,
      "eyebrow": "$lid - Module $m - Section $pad",
      "title": "$st",
      "learningObjectives": [
        "Understand the key principles covered in this section.",
        "Apply the concepts to real factory floor scenarios."
      ],
      "content": "PLACEHOLDER - This section covers $st for the module '$title'. Final content will be provided by the subject-matter expert. The structure, quiz, and navigation are all live and ready.",
      "keyTerms": ["MoRo", "$lid", "placeholder", "content pending"]
    }
"@
    }

    $questionsJson = ""
    for ($q = 1; $q -le 5; $q++) {
      if ($q -gt 1) { $questionsJson += "," }
      $questionsJson += @"

      {
        "id": $q,
        "question": "PLACEHOLDER - Question $q for $mid. Replace with final assessment question.",
        "options": [
          "Option A - replace with correct answer",
          "Option B - replace with distractor",
          "Option C - replace with distractor"
        ],
        "correctAnswer": 0,
        "feedback": "PLACEHOLDER - Explanation for the correct answer to question $q."
      }
"@
    }

    $json = @"
{
  "moduleId": "$mid",
  "title": "$title",
  "level": "$lid",
  "levelName": "$lname",
  "levelColor": "$lcolor",
  "moduleNumber": $m,
  "duration": "TBD",
  "previousModule": $prev,
  "nextModule": $next,
  "prerequisite": $preq,
  "contentStatus": "DRAFT - Placeholder content. Replace with final module script.",
  "sections": [$sectionsJson
  ],
  "quiz": {
    "passingScore": 80,
    "questions": [$questionsJson
    ]
  }
}
"@

    $outPath = Join-Path $modulesPath "$mid.json"
    [System.IO.File]::WriteAllText($outPath, $json, [System.Text.UTF8Encoding]::new($false))
    Write-Host "Created: $mid.json - $title"
    $count++
  }
}

Write-Host ""
Write-Host "DONE. $count files created in: $modulesPath"
