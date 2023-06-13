# This program scrapes the titles and URLs of the Resource Description & Access (RDA) Metadata Guidance Documentation

import requests, bs4, json

def get_raw(page, mgds):
    
    res = requests.get(page)

    soup = bs4.BeautifulSoup(res.text, 'html.parser')

    links = soup.select('#main_body a')
  
    for i in range(0, len(links)-1):
        if 'mg' in links[i].get('href'):
            mgds.append({'title': links[i].getText(), 'uri': page + links[i].get('href')})

pages = ['https://www.loc.gov/aba/rda/mgd/',
         'https://www.loc.gov/aba/rda/mgd/work/',
         'https://www.loc.gov/aba/rda/mgd/expression/',
         'https://www.loc.gov/aba/rda/mgd/manifestation/',
         'https://www.loc.gov/aba/rda/mgd/item/',
         'https://www.loc.gov/aba/rda/mgd/corporateBody/',
         'https://www.loc.gov/aba/rda/mgd/family/',
         'https://www.loc.gov/aba/rda/mgd/person/',
         'https://www.loc.gov/aba/rda/mgd/place/',
         'https://www.loc.gov/aba/rda/mgd/timespan/',
         'https://www.loc.gov/aba/rda/mgd/relationshipLabels/',
         'https://www.loc.gov/aba/rda/mgd/relationships/',
         'https://www.loc.gov/aba/rda/mgd/relationshipsSubject/',
         'https://www.loc.gov/aba/rda/mgd/seriesSubseries/'
         ]

mgds = []

for page in pages:
    get_raw(page, mgds)
    
# remove duplicates
seen = set()
mgds_unq = []

for mgd in mgds:
    key = (mgd['uri'])
    if key in seen:
        continue
    
    # complete titles for relationship labels
    if '-rl-' in key:
        mgd['title'] = 'MG: Relationship labels: ' + mgd['title']

    mgds_unq.append(mgd)
    seen.add(key)

with open('mgd_sample.json', "w") as outfile:
    json.dump(mgds_unq, outfile, indent=2)