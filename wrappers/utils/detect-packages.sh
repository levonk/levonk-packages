#!/usr/bin/env sh
# Dynamic package detection utility for governance wrappers

# Function to detect available packages
detect_available_packages() {
    local target_tool="$1"
    local preferred_tools="$2"
    
    echo "🔍 Available package alternatives for $target_tool:"
    
    # Check each preferred tool and list available ones
    for tool in $preferred_tools; do
        if command -v "$tool" >/dev/null 2>&1; then
            version_output=$("$tool" --version 2>/dev/null || "$tool" version 2>/dev/null || echo "")
            if [ -n "$version_output" ]; then
                echo "  ✅ $tool - $version_output"
            else
                echo "  ✅ $tool - (version unknown)"
            fi
        fi
    done
    
    echo ""
}

# Function to suggest best available alternative
suggest_best_alternative() {
    local preferred_tools="$2"
    
    # Check tools in order of preference
    for tool in $preferred_tools; do
        if command -v "$tool" >/dev/null 2>&1; then
            echo "$tool"
            return 0
        fi
    done
    
    # Fallback to first option if none found
    echo "$preferred_tools" | awk '{print $1}'
}
