import { expect, it, spyOn } from 'bun:test';
import { fireEvent, render, screen } from '@testing-library/react';
import { gameDataAtom, store } from '../events/store';
import { BubberChangelog } from './BubberChangelog';

it('loads the verb window, its localized server entries and its separate localization archive', async () => {
  const previousData = store.get(gameDataAtom);
  store.set(gameDataAtom, {
    dates: ['2026-10'],
    translated_dates: ['2026-10'],
    localization_dates: ['2026-11'],
  });
  const files = {
    '2026-10.yml': '2026-10-01:\n  TG:\n  - bugfix: Upstream entry',
    'bubber_2026-10.yml': '2026-10-01:\n  Bubber:\n  - qol: Bubber entry',
    'splurt_2026-10.yml': '2026-10-01:\n  SPLURT:\n  - qol: SPLURT entry',
    'changelog-translation-2026-10.json': '{"SPLURT entry":"已翻译的更新"}',
    'localization-2026-11.yml':
      '2026-11-18:\n  Team:\n  - bugfix: 汉化修复记录\n' +
      '  - spellcheck: 更新社区校对译文。完整改动见 https://github.com/sernseek/S.P.L.U.R.T-tg/pull/1',
  };
  const request = spyOn(
    globalThis as { fetch: (input: RequestInfo | URL) => Promise<Response> },
    'fetch',
  ).mockImplementation(async (input) => {
    const text = files[String(input)];
    return new Response(text, { status: text ? 200 : 404 });
  });
  try {
    render(<BubberChangelog />);
    expect(await screen.findByText('已翻译的更新')).toBeDefined();
    expect(screen.getByText('Upstream entry')).toBeDefined();
    expect(screen.getByText('Bubber entry')).toBeDefined();
    fireEvent.click(screen.getByText('Localization changes'));
    expect(await screen.findByText('汉化修复记录')).toBeDefined();
    expect(
      screen.getByRole('link', { name: 'PR #1' }).getAttribute('href'),
    ).toBe('https://github.com/sernseek/S.P.L.U.R.T-tg/pull/1');
    expect(screen.queryByText('已翻译的更新')).toBeNull();
    expect(
      screen
        .getByRole('link', { name: 'NovaSector localization history' })
        .getAttribute('href'),
    ).toBe(
      'https://github.com/sernseek/NovaSector/tree/master/html/changelogs/localization/archive',
    );
  } finally {
    request.mockRestore();
    store.set(gameDataAtom, previousData);
  }
});
