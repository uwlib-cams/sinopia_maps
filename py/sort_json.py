import json

def sort_json(file):
    json_file = f"{file.split('.')[0] + '.jsonld'}"
    with open(json_file) as f:
        original = json.load(f)

    to_sort = {}
    add_at_end = []
    pts = []
    print(len(original))

    for i in original:
        if '@type' in i.keys() and i['@type'][0] == "http://sinopia.io/vocabulary/PropertyTemplate":
            pts.append(i)
        elif 'http://www.w3.org/2000/01/rdf-schema#label' in i.keys():
            value = i['http://www.w3.org/2000/01/rdf-schema#label'][0]['@value']
            to_sort[value] = i
        else:
            add_at_end.append(i)

    keys = list(to_sort.keys())
    keys.sort()
        # for i in keys:
        #     sorted_value = to_sort[i]
        #     print(sorted_value)

    final = []
        
    for j in keys:
        final.append(to_sort[j])

    for pt in pts:
        final.append(pt)

    for k in add_at_end:
        final.append(k)

    print(len(final))
    with open(json_file, 'w') as f:
        json.dump(final, f, indent=2)

#sort_json("UWSINOPIA_WAU_rdaWork_test_cspayne.jsonld")