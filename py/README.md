# Sinopia API

## mcm104 notes

[Previous script that uses Sinopia API, post_to_sinopia.py](https://github.com/uwlib-cams/rml/blob/master/rda-to-bf-conversion-for-sinopia/scripts/post_to_sinopia.py) (needs updating; no longer works)

[Link to API spec re: deleting resources](https://ld4p.github.io/sinopia_api/#tag/resources/paths/~1resource~1%7BresourceId%7D/delete)

### Reading Sinopia API spec

- Looks like our header should still be okay? Authorization scheme is still bearer, bearer format is still JWT, and content type is still "application/json", so it seems like that's not the error in post_to_sinopia.py
- Path parameters includes "resourceId" -- does this need to be included separate from the IRI?
  - Tested it out, it works whether it's included or not
- Success = 204; failure = 401 (Unauthorized) or 404 (Not found)

### delete_rt.py

I got two 204s deleting test RTs from Stage (both of which are saved here as JSON files, if they need to be recovered)!

### Fixing [post_to_sinopia.py](https://github.com/uwlib-cams/rml/blob/master/rda-to-bf-conversion-for-sinopia/scripts/post_to_sinopia.py)

- Currently returns [400 error](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/400) -- Bad Request: "the server cannot or will not process the request due to something that is perceived to be a client error (for example, malformed request syntax, invalid request message framing, or deceptive request routing)"
- My initial thinking is that the request itself -- i.e. `requests.post()` or `requests.put()` is malformed somehow, BUT I used the same format for delete_rt.py, just with `requests.delete()`, so maybe the data is wrong
- [Sinopia API spec re: inserting resources](https://ld4p.github.io/sinopia_api/#tag/resources/paths/~1resource~1{resourceId}/post)
   - This is one problem, at least: we don't have all the elements (?) listed in the request body schema
     - What we currently have:
       - data
       - user
       - group
       - templateId
       - types
       - id
       - uri
       - timestamp
     - What we need to add, according to spec:
       - bfAdminMetadataRefs
       - bfItemRefs
       - bfInstanceRefs
       - bfWorkRefs
       - sinopiaLocalAdminMetadataForRefs
       - editGroups
   - These are added a step earlier in [edit_json.py](https://github.com/uwlib-cams/rml/blob/master/rda-to-bf-conversion-for-sinopia/scripts/edit_json.py) [link to line](https://github.com/uwlib-cams/rml/blob/5dfcbb39ea95995f306f3c9399531a64de676181/rda-to-bf-conversion-for-sinopia/scripts/edit_json.py#L69)
 - Edited [edit_json.py](https://github.com/uwlib-cams/rml/blob/master/rda-to-bf-conversion-for-sinopia/scripts/edit_json.py) to add these missing elements (?)
 - Still getting 400 error...
 - Created a test record in Sinopia Stage to see what the metadata looks like when Sinopia generates it itself:
```
{
  "data": [
    {
      "@id": "https://api.stage.sinopia.io/resource/6495f84f-2c0d-41cd-8d39-98f0dedca9cd",
      "http://sinopia.io/vocabulary/hasResourceTemplate": [
        {
          "@value": "TESTRT:WAU:rdacExpression:test_literal_props:ries07"
        }
      ],
      "@type": [
        "http://rdaregistry.info/Elements/c/C10006"
      ],
      "http://rdaregistry.info/Elements/e/P20315": [
        {
          "@value": "The Preferred Title of the Test Expression",
          "@language": "en"
        }
      ],
      "http://rdaregistry.info/Elements/e/P20214": [
        {
          "@value": "2022",
          "@language": "en"
        }
      ]
    }
  ],
  "user": "mcm104",
  "group": "washington",
  "editGroups": [],
  "templateId": "TESTRT:WAU:rdacExpression:test_literal_props:ries07",
  "types": [
    "http://rdaregistry.info/Elements/c/C10006"
  ],
  "bfAdminMetadataRefs": [],
  "sinopiaLocalAdminMetadataForRefs": [],
  "bfItemRefs": [],
  "bfInstanceRefs": [],
  "bfWorkRefs": [],
  "id": "6495f84f-2c0d-41cd-8d39-98f0dedca9cd",
  "uri": "https://api.stage.sinopia.io/resource/6495f84f-2c0d-41cd-8d39-98f0dedca9cd",
  "timestamp": "2022-06-23T19:22:07.990Z"
}
```
 - So it has all those elements... The only thing I see is that the time stamp is formatted slightly differently? We haven't been including milliseconds...
 - Edited [edit_json.py](https://github.com/uwlib-cams/rml/blob/master/rda-to-bf-conversion-for-sinopia/scripts/edit_json.py) to include milliseconds
 - Posting resources now successful (200)
    