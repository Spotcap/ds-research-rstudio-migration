#!/bin/bash

# CONNECT_SERVER="https://r-studio-connect.spotcap.com/"
# API_KEY="uM9beDW9X8LWlBnygcxUU0i69apUWcjp"

CONNECT_SERVER="https://r-studio-connect-staging.spotcap.com/"
CONNECT_API_KEY="zk0tjMh3MMXxRfjQjcr80Mk5yZWjGIuD"


#!/bin/bash

API_KEY="your api key"

# 0: get R version
# curl --silent --show-error -L --max-redirs 0 --fail \
#     -X GET \
#     -H "Authorization: Key ${API_KEY}" \
#     "${CONNECT_SERVER}/connect.example.com/__api__/v1/server_settings/r"

# 1: List Content Items
# curl --silent --show-error -L --max-redirs 0 --fail \
#     -H "Authorization: Key ${CONNECT_API_KEY}" \
#     "${CONNECT_SERVER}__api__/v1/content"

# 2: Read a Content Item (not useful for current task)
# curl --silent --show-error -L --max-redirs 0 --fail \
#     -H "Authorization: Key ${CONNECT_API_KEY}" \
#     "${CONNECT_SERVER}__api__/v1/content/710a10bc-1d59-4ee6-8840-717ecee93c0e"
# => {
# =>   "guid": "ccbd1a41-90a0-4b7b-89c7-16dd9ad47eb5",
# =>   "name": "shakespeare",
# =>   "title": "Shakespeare Word Clouds",
# =>   ...
# =>   "init_timeout": null,
# =>   "min_processes": null,
# =>   ...
# => }

# 3: Update a Content Item (like title or min_processes)
# export DATA='{"title": "Bank Account COVID stats"}'
# curl --silent --show-error -L --max-redirs 0 --fail -X PATCH \
#     -H "Authorization: Key ${CONNECT_API_KEY}" \
#     --data "${DATA}" \
#     "${CONNECT_SERVER}__api__/v1/content/710a10bc-1d59-4ee6-8840-717ecee93c0e"
# => {
# =>   "guid": "ccbd1a41-90a0-4b7b-89c7-16dd9ad47eb5",
# =>   "name": "shakespeare",
# =>   "title": "Word Clouds from Shakespeare",
# =>   ...
# =>   "init_timeout": null,
# =>   "min_processes": null,
# => }

# 4: Setting a Vanity URL for a Content Item
# export DATA='{"path": "/test/covid-api"}'
# curl --silent --show-error -L --max-redirs 0 --fail -X PUT \
#     -H "Authorization: Key ${CONNECT_API_KEY}" \
#     --data "${DATA}" \
#     "${CONNECT_SERVER}__api__/v1/content/710a10bc-1d59-4ee6-8840-717ecee93c0e/vanity"
# => {
# =>   "content_guid": "ccbd1a41-90a0-4b7b-89c7-16dd9ad47eb5",
# =>   "path": "/shakespeare/",
# =>   ...
# => }

# 5: Get content details
# curl --silent --show-error -L --max-redirs 0 --fail \
#     -X GET \
#     -H "Authorization: Key ${CONNECT_API_KEY}" \
#     "${CONNECT_SERVER}__api__/v1/experimental/content/710a10bc-1d59-4ee6-8840-717ecee93c0e"


# 6: download bundle
STAGING_CONTENT_GUID=710a10bc-1d59-4ee6-8840-717ecee93c0e
STAGING_BUNDLE_ID=1368
curl --silent --show-error -L --max-redirs 0 --fail -J -O \
    -H "Authorization: Key ${CONNECT_API_KEY}" \
    "${CONNECT_SERVER}__api__/v1/content/${STAGING_CONTENT_GUID}/bundles/${STAGING_BUNDLE_ID}/download"
