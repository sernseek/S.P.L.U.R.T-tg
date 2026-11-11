import { filter } from 'es-toolkit/compat';
import { flow } from 'tgui-core/fp';
// ZH EDIT ADDITION - I18N
import { searchableText } from '../../i18n/search';

import type { Supply, SupplyCategory } from './types';

/**
 * Take entire supplies tree
 * and return a flat supply pack list that matches search,
 * sorted by name and only the first page.
 * @param {Supply[]} supplies Supplies list, aka Object.values(data.supplies)
 * @param {string} search The search term
 * @returns {Supply[]} The flat list of supply packs.
 */
export function searchForSupplies(
  supplies: SupplyCategory[],
  search: string,
): Supply[] {
  const lowerSearch = search.toLowerCase();

  return flow([
    // Flat categories
    (initialSupplies: SupplyCategory[]) =>
      initialSupplies.flatMap((category) => category.packs),
    // Filter by name or desc
    (flatMapped: Supply[]) =>
      filter(
        flatMapped,
        (pack: Supply) =>
          // ZH EDIT CHANGE START - I18N: 也匹配显示译文 - ORIGINAL: pack.name?.toLowerCase() / pack.desc?.toLowerCase()
          searchableText(pack.name).includes(lowerSearch) ||
          searchableText(pack.desc).includes(lowerSearch),
        // ZH EDIT CHANGE END
      ),
    // Just the first page
    (filtered: Supply[]) => filtered.slice(0, 25),
  ])(supplies);
}
