#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

declare ES_URL
declare ES_USERNAME
declare ES_PASSWORD

if [[ -z "${ES_URL}" ]]; then
  echo "env variable 'ES_URL' not specified!"
  exit 1
fi
if [[ -z "${ES_USERNAME}" ]]; then
  echo "env variable 'ES_USERNAME' not specified!"
  exit 1
fi
if [[ -z "${ES_PASSWORD}" ]]; then
  echo "env variable 'ES_PASSWORD' not specified!"
  exit 1
fi

curl -u $ES_USERNAME:$ES_PASSWORD -k -X POST "${ES_URL}/_index_template/knative-serving" -H 'Content-Type: application/json' -d'
{
  "index_patterns": ["knative-serving*"],
  "template": {
    "settings": {
      "number_of_shards": 1
    },
    "mappings": {
      "_source": {
        "enabled": true
      },
      "properties": {
        "@timestamp": {
           "type": "date"
        },
        "_measurement": {
          "type": "keyword"
        },
        "tags": {
          "type": "nested"
        },
        "requests": {
          "type": "unsigned_long"
        },
        "rate": {
          "type": "double"
        },
        "throughput": {
          "type": "double"
        },
        "duration": {
          "type": "long"
        },
        "latency-mean": {
          "type": "long"
        },
        "latency-min": {
          "type": "long"
        },
        "latency-max": {
          "type": "long"
        },
        "latency-p95": {
          "type": "long"
        },
        "success": {
          "type": "double"
        },
        "errors": {
          "type": "long"
        },
        "bytes-in": {
          "type": "double"
        },
        "bytes-out": {
          "type": "double"
        },
        "activator-pod-count": {
          "type": "long"
        },
        "desired-replicas": {
          "type": "long"
        },
        "ready-replicas": {
          "type": "long"
        },
        "sks": {
          "type": "long"
        },
        "num-of-activators": {
          "type": "long"
        },
        "desired-pods": {
          "type": "long"
        },
        "available-pods": {
          "type": "long"
        },
        "desired-pods-new": {
          "type": "long"
        },
        "available-pods-new": {
          "type": "long"
        },
        "service-ready-latency": {
          "type": "long"
        },
        "deployment-updated-latency": {
          "type": "long"
        },
        "Service": {
          "type": "double"
        },
        "Configuration": {
          "type": "double"
        },
        "Route": {
          "type": "double"
        },
        "Revision": {
          "type": "double"
        },
        "Ingress": {
          "type": "double"
        },
        "ServerlessService": {
          "type": "double"
        },
        "PodAutoscaler": {
          "type": "double"
        }
      }
    }
  },
  "priority": 200,
  "version": 1,
  "_meta": {
    "description": "knative performance"
  }
}
'