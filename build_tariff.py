import re, json, os, glob, sys

RAW = 'tariff_raw'
OUT = 'tariff.json'

def extract_chapter_title(html):
    m = re.search(r'第\d+類[^\n<]*', html)
    if m:
        return m.group(0).strip()
    return ''

def parse_chapter(path):
    html = open(path, encoding='cp932', errors='replace').read()
    title = extract_chapter_title(html)
    rows = []
    trs = re.findall(r'<tr[^>]*>(.*?)</tr>', html, re.S)
    for tr in trs:
        m_cst = re.search(r'class="shell_var1_CSTNO"[^>]*>(.*?)</td>', tr, re.S)
        if not m_cst:
            continue
        cst = re.sub(r'<[^>]+>', '', m_cst.group(1)).strip()
        m_name = re.search(r'class="shell_var1_ITEM_NAME"[^>]*>(.*?)</td>', tr, re.S)
        name = re.sub(r'<[^>]+>', '', m_name.group(1)).strip() if m_name else ''
        name = re.sub(r'\s+', ' ', name)
        m_rate = re.search(r'class="shell_var1_ITEM_NAME".*?</td>\s*<td width="88px"[^>]*>(.*?)</td>', tr, re.S)
        rate = ''
        if m_rate:
            rate = re.sub(r'<[^>]+>', '', m_rate.group(1)).strip()
        if not cst or not name:
            continue
        rows.append({'hs': cst, 'name': name, 'rate': rate, 'ch': title})
    return rows

all_rows = []
files = sorted(glob.glob(os.path.join(RAW, 'j_*.htm')))
for fp in files:
    rows = parse_chapter(fp)
    all_rows.extend(rows)
    sys.stderr.write('parsed %s -> %d rows\n' % (os.path.basename(fp), len(rows)))

# de-dup by hs+name keeping first
seen = set()
uniq = []
for r in all_rows:
    key = r['hs'] + '|' + r['name']
    if key in seen:
        continue
    seen.add(key)
    uniq.append(r)

data = {'updated': '2026-07-09', 'count': len(uniq), 'items': uniq}
with open(OUT, 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, separators=(',', ':'))
sys.stderr.write('WROTE %s with %d items\n' % (OUT, len(uniq)))
