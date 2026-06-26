# Global npm packages - installed on first run
# To reinstall: npm install -g @hubspot/cli
#
# Auto-install global npm packages if not present
if not command -q hs
    echo "📦 Installing @hubspot/cli..."
    npm install -g @hubspot/cli
end
