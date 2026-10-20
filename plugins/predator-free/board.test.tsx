import { test, expect } from 'claude-code/testing'

const props = (maxRows: number, bodyColumns: number) => ({
  hasSurvey: false, isWorking: true, maxRows, bodyColumns,
  scroll: { offset: 0, bodyRows: maxRows - 1 }, view: {},
})

test('the board draws above the prompt after /kiwi', async ($, on) => {
  on('ui.render', async () => ({ type: 'Box', props: {} }) as any)
  await $.command.run({ command: 'kiwi', args: '' } as any)
  for (const surface of ['terminal', 'desktop'] as const) {
    const ui = await $.ui.mount({ plugin: 'predator-free', surface, component: 'AbovePrompt', props: props(20, 80) } as any)
    expect(await ui.find({ key: 'predator-free:close' } as any)).toBeDefined()
    // the first wave waits on the board before any click
    expect(await ui.find({ type: 'Text', text: /ʘʘ/, in: 'board:predator-free' } as any)).toBeDefined()
    await ui.unmount()
  }
})
