# Settings the shared CI workflow uses when it lints this repo.
# Run the same check locally with:
#   Invoke-ScriptAnalyzer -Path . -Recurse -Settings ./PSScriptAnalyzerSettings.psd1
@{
    Severity     = @('Error', 'Warning', 'Information')

    # Add rule names here to switch them off for this repo only,
    # for example 'PSUseShouldProcessForStateChangingFunctions'.
    ExcludeRules = @()
}
