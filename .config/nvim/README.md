# Introduction

This is my nvim configuration

# Keymaps

## CodeCompanion

| Mode   | Shortcut Keys | Action         |
| ------ | ------------- | -------------- |
| Normal | ga            | Change adapter |
| Normal | gS            | Copilot statistics   |
| Normal | gs            | Toggle system prompt |
| Normal | gd            | View debug info   |
| Normal | gty           | Toggle YOLO mode  |
| Normal | gtx           | Clear approvals   |
| Normal | gba           | Toggle buffer syncing  |
| Normal | gbd           | Toggle buffer diff syncing |
| Normal | gR            | Open file under cursor   |
| Normal | gc            | Insert codeblock   |
| Normal | gy            | yank code   |
| Normal | gx            | Clear       |
| Normal | }             | Next chat       |
| Normal | {             | Previous chat   |
| Normal | ]]            | Next header       |
| Normal | [[            | Previous header   |
| Normal/Insert | Ctrl + s      | Send response  |
| Normal | Enter         | Send response  |
| Normal | gr            | Regenerate   |
| Normal | q             | Stop request   |
| Insert | Ctrl + q      | Stop request   |
| Normal/Insert | Ctrl + f      | Chose file    |
| Normal | gf            | Chose file    |
| Diff   | ga            | accept change |
| Diff   | gA            | always accept |
| Diff   | gr            | reject accept |
| Normal/Visual | Space + a     | Open CodeCompanion actions |
| Normal/Visual | Space + c     | Toggle CodeCompanion chat |
| Visual | ga            | Add selected content to CodeCompanion chat  |

## LSP / Outline

| Mode   | Shortcut Keys | Action         |
| ------ | ------------- | -------------- |
| Normal | gd            | Go to definition |
| Normal | gD            | Go to declaration |
| Normal | gt            | Go to type definition |
| Normal | gi            | Go to implementation |
| Normal | gr            | Show references |
| Normal | K             | Hover documentation |
| Normal | ,rn           | Rename symbol |
| Normal | ,ca           | Code action |
| Normal | [g            | Previous diagnostic |
| Normal | ]g            | Next diagnostic |
| Normal | ,o            | Toggle Outline |
| Normal | ,O            | Refresh Outline |
