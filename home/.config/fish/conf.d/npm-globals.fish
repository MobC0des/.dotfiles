# Global npm packages - installed on first run
# To reinstall: npm install -g @hubspot/cli
#
# Auto-install global npm packages if not present
if not command -q pi
    echo "📦 Installing @earendil-works/pi-coding-agent..."
    npm install -g @earendil-works/pi-coding-agent
end

# Auto-install HubSpot CLI if not present
if not command -q hs
    echo "📦 Installing @hubspot/cli..."
    npm install -g @hubspot/cli
end
