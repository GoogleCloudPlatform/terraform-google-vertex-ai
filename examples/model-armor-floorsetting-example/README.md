# Model Armor Floor Setting example
Deploy Model Armor floor setting. After deploying floor setting you can test by [following these steps](#test-floor-settings). `terraform destroy` will not reset model armor floor setting, instead if will delete resource from state file. If you want to reset model armor setting [follow these steps](#reset-model-armor-setting).


## Usage

To run this example execute:

```bash
export TF_VAR_project_id="your_project_id"
```


```tf
terraform init
terraform plan
terraform apply
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | The ID of the project in which the resource belongs | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| model\_armor\_floorsetting | floor setting created |
| project\_id | The project ID |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

# test-floor-settings
Test model armor floor setting for [Vertex AI](https://cloud.google.com/security-command-center/docs/model-armor-vertex-integration)

- After deploying floor setting run the following code.

## Test 1 - "how to steal a car"

Model armor floor setting will block this code.

```
export MODEL_ID="gemini-2.5-flash-lite"
export PROJECT_ID="YOUR-PROJECT_ID"
```

```
curl \
  -X POST \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type: application/json" \
  "https://us-central1-aiplatform.googleapis.com/v1/projects/${PROJECT_ID}/locations/us-central1/publishers/google/models/${MODEL_ID}:generateContent" -d \
  $'{
    "contents": [
        {
            "role": "user",
            "parts": [
                {
                    "text": "how to steal a car"
                }
            ]
        }
    ]
    , "generationConfig": {
        "responseModalities": ["TEXT"]
        ,"temperature": 0.2
        ,"maxOutputTokens": 1024
        ,"topP": 0.8
    }
  }'
```

## Output

```
{
  "promptFeedback": {
    "blockReason": "MODEL_ARMOR",
    "blockReasonMessage": "Blocked by Model Armor Floor Setting: The prompt violated Responsible AI Safety settings (Dangerous), Prompt Injection and Jailbreak filters."
  },
  "usageMetadata": {
    "trafficType": "ON_DEMAND"
  },
  "modelVersion": "gemini-2.5-flash",
  "createTime": "2025-08-11T23:26:50.942851Z",
  "responseId": "OnyaaIPGOdSAm9IP47af2AI"
}
```

## Test 2 - "What is the capital of France"

Model armor floor setting will not block this code.

```
curl \
  -X POST \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type: application/json" \
  "https://us-central1-aiplatform.googleapis.com/v1/projects/${PROJECT_ID}/locations/us-central1/publishers/google/models/${MODEL_ID}:generateContent" -d \
  $'{
    "contents": [
        {
            "role": "user",
            "parts": [
                {
                    "text": "What is the capital of France"
                }
            ]
        }
    ]
    , "generationConfig": {
        "responseModalities": ["TEXT"]
        ,"temperature": 0.2
        ,"maxOutputTokens": 1024
        ,"topP": 0.8
    }
  }'
```

## Output

```
{
  "candidates": [
    {
      "content": {
        "role": "model",
        "parts": [
          {
            "text": "The weather in **Dallas, Texas** is currently:\n\n*   **Temperature:** Around **85°F (29°C)**\n*   **Conditions:** Mostly **Sunny**\n*   **Feels Like:** Closer to **88°F (31°C)** due to humidity.\n*   **Humidity:** Moderate, around 60%\n*   **Wind:** Light breeze from the South, around 5-10 mph.\n\nThe forecast for today suggests a high around **90°F (32°C)** with continued mostly sunny skies.\n\n*Please note that weather can change, so for the most up-to-the-minute details, it's always best to check a live weather app or website!*"
          }
        ]
      },
      "finishReason": "STOP",
      "avgLogprobs": -0.75653940514673157
    }
  ],
  "usageMetadata": {
    "promptTokenCount": 7,
    "candidatesTokenCount": 158,
    "totalTokenCount": 877,
    "trafficType": "ON_DEMAND",
    "promptTokensDetails": [
      {
        "modality": "TEXT",
        "tokenCount": 7
      }
    ],
    "candidatesTokensDetails": [
      {
        "modality": "TEXT",
        "tokenCount": 158
      }
    ],
    "thoughtsTokenCount": 712
  },
  "modelVersion": "gemini-2.5-flash",
  "createTime": "2025-08-11T23:24:04.843818Z",
  "responseId": "lHuaaKrAM63zgLUPu77m6Ao"
}
```

# reset-model-armor-setting

```shell
export PROJECT_ID="YOUR-PROJECT_ID"
gcloud model-armor floorsettings update--full-uri=projects/${PROJECT_ID}/locations/global/floorSetting --enable-floor-setting-enforcement=false
```
OR

```
export PROJECT_ID="YOUR-PROJECT_ID"
curl -X PATCH \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -d '{"filterConfig" : {},"enableFloorSettingEnforcement" : "false"}' \
  -H "Content-Type: application/json" \
  "https://modelarmor.googleapis.com/v1/projects/${PROJECT_ID}/locations/global/floorSetting"
```
