# Doppler - secrets management
# Usage: doppler run -- <command>  (injects secrets as env vars)
# Usage: doppler setup             (configure a project)
# Usage: doppler secrets           (list secrets for current project)

# Load shell completions
if command -q doppler
    doppler completion fish | source
end
