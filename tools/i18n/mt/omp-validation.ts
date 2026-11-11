/** Preserve the catalog's literal DM escapes when a model emits equivalent JSON whitespace. */
export function normalizeOmpLineEscapes(source: string, translated: unknown): unknown {
  if (typeof translated !== 'string') return translated;
  let result = translated;
  if (source.includes('\\n') && !source.includes('\n')) result = result.replace(/\r?\n/g, '\\n');
  if (source.includes('\\t') && !source.includes('\t')) result = result.replace(/\t/g, '\\t');
  return result;
}

/** Validate the structural parts of a model translation before writing it to a catalog. */
export function validateOmpTranslation(source: string, translated: unknown): boolean {
  if (typeof translated !== 'string' || !translated.trim()) return false;
  if (/\\s(?![A-Za-z])/.test(translated)) return false;
  const tokens = (value: string) =>
    (value.match(/\{\d+\}|%[A-Za-z_]+%?|@[A-Za-z_]+\([^)]*\)|\\(?:improper|proper|[Tt]he|[Aa]n|[Aa]|[Rr]oman|ref|red|black|he|n|t|r|s|[A-Za-z]+|[\[\]])/g) ?? [])
      // DM's plural suffix is intentionally omitted in Chinese translations.
      .filter((token) => token !== '\\s')
      .sort();
  const tags = (value: string) => value.match(/<\/?[A-Za-z][^>]*>/g) ?? [];
  if (JSON.stringify(tokens(source)) !== JSON.stringify(tokens(translated))) return false;
  if (JSON.stringify(tags(source)) !== JSON.stringify(tags(translated))) return false;
  // Do not silently whitelist untranslated prose when the model simply echoed its input.
  if (source === translated && /[a-z]/.test(source)) return false;
  // A changed English-only response is not evidence of a Chinese translation either.
  if (source !== translated && /[A-Za-z]/.test(source) && !/[\u3400-\u9fff]/.test(translated)) return false;
  return true;
}
