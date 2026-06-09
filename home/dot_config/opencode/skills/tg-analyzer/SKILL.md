---
name: tg-analyzer
description: Analyzes Telegram chat history via tdl (text only), installs Ralph autonomous agent, and generates a detailed report based on topic.md.
user-invocable: true
---

# Telegram Chat Analyzer Skill

This skill automates the extraction of text-only Telegram messages using `tdl`, installs the Ralph autonomous agent, and generates an analysis report based on specified topics.

## The Job

When invoked, you MUST execute the following steps sequentially using your available tools:

### Step 1: Initialize Environment
Use the `bash` tool to create the necessary directories:
```bash
mkdir -p .tg/data .tg/ralph
```

### Step 2: Export Chat via TDL
Ask the user for the target chat identifier (e.g., `@username`, `chat_id`, or `https://t.me/...`).
Once provided, use the `bash` tool to run the following commands to export messages and filter out media:
```bash
# Export all messages (including non-media) with content
tdl chat export -c <CHAT_ID> --all --with-content -o .tg/data/chat_history_raw.json

# Filter JSON to strictly keep only text messages (remove empty or media-only entries)
jq '[.[] | select(.message != null and .message != "")]' .tg/data/chat_history_raw.json > .tg/data/chat_history.json
```

### Step 3: Install Ralph
Use the `bash` tool to download Ralph and its prompt template. Rename the template to `AGENTS.md` as required:
```bash
cd .tg/ralph
curl -O https://raw.githubusercontent.com/snarktank/ralph/main/ralph.sh
chmod +x ralph.sh
curl -o AGENTS.md https://raw.githubusercontent.com/snarktank/ralph/main/CLAUDE.md
git init
git add .
git commit -m "Initial ralph commit"
```

### Step 4: Create Topics File
Use the `write` tool to create `.tg/topic.md` with the following default structure:
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
Use the `write` tool to create `.tg/prd.json` to instruct Ralph. You MUST read the `.tg/topic.md` file and generate a distinct story for each individual topic listed.

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

Finally, inform the user that the setup is complete and they can start the analysis by running:
```bash
cd .tg && ./ralph/ralph.sh
```
