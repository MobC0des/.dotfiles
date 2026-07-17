function blend-skills-update --description "Pull latest Blend Claude skills and update ~/.claude/skills and ~/.pi/agent/skills"
    set repo ~/Sites/Blend/claude-skills

    if not test -d $repo
        echo "❌ Blend skills repo not found at $repo"
        return 1
    end

    echo "⬇️  Pulling latest Blend skills..."
    git -C $repo pull

    if test $status -eq 0
        echo "✅ ~/.claude/skills and ~/.pi/agent/skills updated"
    else
        echo "❌ Pull failed — check $repo"
        return 1
    end
end
