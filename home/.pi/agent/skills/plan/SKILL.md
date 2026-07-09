---
name: plan
description: Before making any code changes, write a clear plan and open it in Plannotator for the user to review, annotate, and approve. Use whenever the task involves editing files, refactoring, or multi-step changes. Do not touch any files until the plan is approved.
---

# Plan Review via Plannotator

## Workflow

1. Write a complete plan as your response — what you'll change, which files, and in what order. Be specific.
2. Tell the user you're opening Plannotator for review.
3. Run:

```bash
plannotator annotate-last
```

4. Handle the result:
   - `"The user approved."` or `{"decision": "approved"}` → proceed with implementation
   - Empty or `{"decision": "dismissed"}` → acknowledge and stop. Say: "Annotation session closed." Do not begin work.
   - Annotations or `{"decision": "annotated", "feedback": "..."}` → address the feedback, revise your plan, repeat from step 3

## Rules
- Do NOT edit any files before the user approves
- Keep plans specific: list every file you'll touch and exactly what will change
- If the scope is large, break it into phases and let the user approve each phase
