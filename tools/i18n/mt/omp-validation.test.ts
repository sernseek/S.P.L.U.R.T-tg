import { describe, expect, test } from 'bun:test';
import { normalizeOmpLineEscapes, validateOmpTranslation } from './omp-validation';

describe('OMP translation validation', () => {
  test('preserves placeholders, macros, and HTML', () => {
    expect(validateOmpTranslation("<b>{0}</b> has %TARGET% and \\the tool.", "<b>{0}</b>拥有%TARGET%和\\the工具。")).toBe(true);
    expect(validateOmpTranslation('Open {0} and {1}.', '打开{0}。')).toBe(false);
    expect(validateOmpTranslation("<a href='{0}'>Open</a>", "<a href='{0}'>打开</span>")).toBe(false);
    expect(validateOmpTranslation('See %TARGET%.', '查看目标。')).toBe(false);
    expect(validateOmpTranslation('Found \\[{0}\\].', '找到[{0}]。')).toBe(false);
    expect(validateOmpTranslation('Found \\[{0}\\].', '找到\\[{0}\\]。')).toBe(true);
    expect(validateOmpTranslation('Guard @pick(location).', '守卫该地点。')).toBe(false);
    expect(validateOmpTranslation('Guard @pick(location).', '守卫@pick(location)。')).toBe(true);
    expect(validateOmpTranslation('First.\\nThen go.', '首先。\\n然后走。')).toBe(true);
    expect(validateOmpTranslation('First.\\nThen go.', '首先。然后走。')).toBe(false);
    expect(normalizeOmpLineEscapes('First.\\nThen go.', '首先。\n然后走。')).toBe('首先。\\n然后走。');
  });
  test('allows omitted DM plural suffix but rejects untranslated prose', () => {
    expect(validateOmpTranslation('You have {0} item\\s.', '你有{0}件物品。')).toBe(true);
    expect(validateOmpTranslation('Open the door.', 'Open the door.')).toBe(false);
    expect(validateOmpTranslation('Chair', 'Chair')).toBe(false);
    expect(validateOmpTranslation('Chair', 'A chair')).toBe(false);
    expect(validateOmpTranslation('APC', 'APC')).toBe(true);
  });
});
