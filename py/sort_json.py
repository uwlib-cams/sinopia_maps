import json

def sort_json(file):
    json_file = f"{file.split('.')[0] + '.jsonld'}"
    with open(json_file) as f:
        original = json.load(f)

    to_sort = {}
    add_at_end = []
    pts = []
    # print(len(original))

    # iterate through JSON list
    for i in original:
        if '@type' in i.keys() and i['@type'][0] == "http://sinopia.io/vocabulary/PropertyTemplate":
            pts.append(i)
        
        # these values are property template labels, store to organize later
        elif 'http://www.w3.org/2000/01/rdf-schema#label' in i.keys():
            value = i['http://www.w3.org/2000/01/rdf-schema#label'][0]['@value']

            # sort by keyword of label (skip 'is' and 'has')
            if " " in value: 
                value_keyword = value.split(" ", 1)[1]
            else:
                value_keyword = value
            # print(value_keyword)
            to_sort[value_keyword] = i
        else:
            # store the rest to be added at the end 
            add_at_end.append(i)

    # sort by label
    keys = list(to_sort.keys())
    keys.sort()

    # print(keys)
    final = []
    
    # add sorted arrays first
    for j in keys:
        final.append(to_sort[j])

    # then add pts
    for pt in pts:
        final.append(pt)

    # then the add at end arrays
    for k in add_at_end:
        final.append(k)

    # print(len(final))
    # store in original file
    with open(json_file, 'w') as f:
        json.dump(final, f, indent=2)

# sort_json("UWSINOPIA_WAU_rdaITEM_printMonograph_CAMS.jsonld")