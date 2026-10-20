# predator-free

Predator Free Aotearoa above the Claude Code prompt, for the minutes Claude spends working. You're the ranger on the bottom row; waves of possums (ʘʘ), stoats (≈>) and rats (~o) are coming for the kiwi. Set traps before they reach the forest floor. Pauses when Claude finishes the turn ("Kua oti"), keeps your best score, costs no tokens.

Adapted from the invaders mod in [sezaakgun/cc-arcade](https://github.com/sezaakgun/cc-arcade) (MIT, Seza Akgün). Same rules, new skin.

## Play

1. `/kiwi` opens the board (`/kiwi stop` or the `close` button closes it).
2. Click the board to give it the keyboard; Esc gives it back to the prompt.
3. ← → or the mouse move the ranger; Space, ↑ or a click sets a trap. `p` pauses, `r` restarts. One trap at a time, three kiwi, and each cleared ngaru (wave) starts a row lower and moves faster.

Status line words: piro = score, ngaru = wave, auē = oh no, ka pai = good one, kia ora = hello, ka kite = see you.

## Requirements

Claude Code 2.1.287 or later, in an interactive terminal that reports the mouse. Nothing draws in the desktop app, mobile or `claude -p`.
