---
disable-model-invocation: true
description: Pass a prompt to Codex CLI and return the result
argument-hint: [prompt text, or leave blank to use current conversation context]
---

<objective>
Send a prompt to `codex exec` and return the output. This is a simple pass-through — no analysis, no waves, no frameworks. Just relay the prompt to Codex CLI and bring back what it produces.
</objective>

<process>

## Step 1: Determine the Prompt

If $ARGUMENTS is provided, use it as the prompt text.

If $ARGUMENTS is empty, synthesize a prompt from the current conversation context — summarize what the user has been discussing and what they want Codex to do. Confirm with the user before sending: "Sending this to Codex CLI: [prompt summary]. OK?"

## Step 2: Write Prompt File

Write the prompt to `/tmp/codex-prompt.txt` using the Write tool.

## Step 3: Run Codex CLI

```bash
codex exec --full-auto - < /tmp/codex-prompt.txt
```

Use timeout 600000ms. If the task may need file writes, the `--full-auto` flag handles sandbox permissions.

If the user specified a working directory in the prompt or conversation, add `-C <dir>`.

## Step 4: Report Result

Show the user what Codex returned. If Codex wrote files, list them. If it produced text output, display it.

## Step 5: Cleanup

```bash
rm -f /tmp/codex-prompt.txt
```

</process>
