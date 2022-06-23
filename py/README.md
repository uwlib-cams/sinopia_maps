# Notes

[Previous script that uses Sinopia API, post_to_sinopia.py](https://github.com/uwlib-cams/rml/blob/master/rda-to-bf-conversion-for-sinopia/scripts/post_to_sinopia.py) (needs updating; no longer works)

[Link to API spec re: deleting resources](https://ld4p.github.io/sinopia_api/#tag/resources/paths/~1resource~1%7BresourceId%7D/delete)

## Reading Sinopia API spec

- Looks like our header should still be okay? Authorization scheme is still bearer, bearer format is still JWT, and content type is still "application/json", so it seems like that's not the error in post_to_sinopia.py
- Path parameters includes "resourceId" -- does this need to be included separate from the IRI?
  - Tested it out, it works whether it's included or not
- Success = 204; failure = 401 (Unauthorized) or 404 (Not found)

# delete_rt.py

I got two 204s deleting test RTs from Stage (both of which are saved here as JSON files, if they need to be recovered)!
