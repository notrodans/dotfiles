---
name: tg-analyzer
description: Analyze Telegram chat history via tdl text export and prepare Ralph-compatible analysis inputs with explicit approval for mutations.
---

# Telegram Chat Analyzer Skill

This skill helps extract text-only Telegram messages using `tdl`, prepare Ralph-compatible analysis inputs, and generate a report plan based on specified topics. Preserve user data and require explicit approval before any export, download, filesystem mutation, git initialization, git commit, or other persistent change.

## The Job

When invoked, work sequentially and keep the user in control. Before any command that exports data, downloads files, writes files, creates directories, initializes git, or commits changes, show the exact intended action and wait for explicit approval.

### Step 1: Initialize Environment
Ask for approval to create the working directories. Only after approval, create:
```bash
mkdir -p .tg/data .tg/ralph
```

### Step 2: Export Chat via TDL
Ask the user for the target chat identifier (e.g., `@username`, `chat_id`, or `https://t.me/...`). Then ask for explicit approval before running export commands because this writes chat data to disk.
```bash
# Export all messages (including non-media) with content
tdl chat export -c <CHAT_ID> --all --with-content -o .tg/data/chat_history_raw.json

# Filter JSON to strictly keep only text messages (remove empty or media-only entries)
jq '[.[] | select(.message != null and .message != "")]' .tg/data/chat_history_raw.json > .tg/data/chat_history.json
```

### Step 3: Prepare Ralph
Do not automatically download Ralph. If the user wants Ralph installed, request approval for the download and use a user-approved stable commit SHA, not a floating branch. If no commit is provided or verified in the local context, avoid the download and tell the user to provide a pinned commit. Do not run `git init`, `git add`, or `git commit` unless separately approved.
```bash
cd .tg/ralph
curl -O https://raw.githubusercontent.com/snarktank/ralph/<APPROVED_COMMIT_SHA>/ralph.sh
chmod +x ralph.sh
curl -o AGENTS.md https://raw.githubusercontent.com/snarktank/ralph/<APPROVED_COMMIT_SHA>/CLAUDE.md
```

### Step 4: Create Topics File
Ask for approval before writing `.tg/topic.md`. Use this default structure if the user does not provide topics:
```markdown
# Telegram Chat Analysis Topics

Carefully study the chat history (chat_history.json) and provide detailed answers to the following topics.
Be sure to support every fact with a link to the original message.

## Topics for research:
1. **Main themes**: What key issues were discussed most frequently?
2. **Agreements and decisions**: Were any important decisions made?
3. **Problems and pain points**: What did the chat participants complain about?
```

### Step 5: Integrate Ralph and Execute
Ask for approval before writing `.tg/prd.json` to instruct Ralph. Read `.tg/topic.md` and generate a distinct story for each individual topic listed.

For example, if there are 3 topics, your generated `prd.json` should look similar to this:
```json
{
  "project": "Telegram Chat Analysis",
  "description": "Analyze the extracted Telegram chat history based on the provided study topics.",
  "stories": [
    {
      "id": "STORY-1",
      "description": "Read .tg/data/chat_history.json. Analyze the chat and write a detailed section on the topic: 'Main themes: What key issues were discussed most frequently?'. Include direct links to the original messages as sources. Save this section to .tg/report_part_1.md."
    },
    {
      "id": "STORY-2",
      "description": "Read .tg/data/chat_history.json. Analyze the chat and write a detailed section on the topic: 'Agreements and decisions: Were any important decisions made?'. Include direct links to the original messages as sources. Save this section to .tg/report_part_2.md."
    },
    {
      "id": "STORY-3",
      "description": "Read .tg/data/chat_history.json. Analyze the chat and write a detailed section on the topic: 'Problems and pain points: What did the chat participants complain about?'. Include direct links to the original messages as sources. Save this section to .tg/report_part_3.md."
    },
    {
      "id": "STORY-4",
      "description": "Combine .tg/report_part_1.md, .tg/report_part_2.md, and .tg/report_part_3.md into a single final report at .tg/final_analysis_report.md with proper markdown formatting."
    }
  ]
}
```
*Note: The exact number of stories and their descriptions should match the actual content of `.tg/topic.md`.*

Finally, inform the user what was prepared and, if Ralph was installed with approval, that they can start the analysis by running:
```bash
cd .tg && ./ralph/ralph.sh
```
