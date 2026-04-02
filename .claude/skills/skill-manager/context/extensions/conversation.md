# Skill-Type Extension: Conversation

Applies to skills with `primary_category: conversation`.
Inherits all rules from `shared-foundation.md`. This extension adds conversation-specific rules.

---

## Purpose

Conversation skills manage interactive, multi-turn dialogues toward a defined goal. Examples: requirements gathering, interviewing, guided configuration, interactive troubleshooting.

## Goal coherence

- Every conversation skill MUST declare a goal — what the conversation should achieve
- Each turn must make progress toward the goal or explicitly acknowledge a detour
- The agent must track what information has been gathered and what remains
- If the goal is reached, the skill must produce a final output (summary, decision, artifact)

## Turn rules

- Each response must be focused — one question or one information delivery at a time
- Do not front-load multiple questions in one turn
- Summarize understanding periodically to confirm alignment
- If the user goes off-topic, gently redirect toward the goal

## State management

- The skill must define what information needs to be gathered (a checklist or schema)
- As the conversation progresses, track which items are resolved and which remain
- Never re-ask for information already provided (unless clarifying contradictions)

## Closure rules

- When all required information is gathered, produce the final artifact
- If the user wants to stop early, produce a partial artifact with gaps clearly marked
- State what was covered and what was not

## Output contract (default)

Conversation skills have two output types:

**Per-turn output**: Natural conversational response (no special format required)

**Final artifact** (at conversation end):

```markdown
## Conversation Result

### Goal
[what was being achieved]

### Status
Complete / Partial

### Gathered information
[structured summary of what was collected]

### Gaps (if partial)
| Item | Status |
|---|---|
| ... | Missing / Uncertain |

### Artifact
[the deliverable: requirements doc, configuration, decision, etc.]
```

## Self-check (per turn)

```
□ Does this response advance the conversation goal?
□ Am I asking only one question at a time?
□ Am I tracking what has been gathered vs. what remains?
□ Am I not re-asking for information already provided?
```

## Self-check (at closure)

```
□ Is all required information gathered (or gaps stated)?
□ Does the final artifact match the skill's output contract?
□ Is the conversation status accurately reported?
```

## Test requirements (in addition to foundation §14)

- **Goal completion**: Multi-turn test that reaches the goal — verify final artifact is complete
- **Early termination**: User stops mid-conversation — verify partial artifact with gaps
- **Coherence**: Verify the agent does not re-ask answered questions
- **Redirect**: User goes off-topic — verify gentle redirection
