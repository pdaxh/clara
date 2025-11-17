# Clara Language Support

Clara supports multiple languages and can switch between them based on configuration.

## Supported Languages

- **English** (`en`) - Default
- **Swedish** (`sv`)

## How to Configure Language

### Local Development

Set the `CLARA_LANGUAGE` environment variable in your `.env` file:

```bash
# For English (default)
CLARA_LANGUAGE=en

# For Swedish
CLARA_LANGUAGE=sv
```

Or export it before running:
```bash
export CLARA_LANGUAGE=sv
uv run adk web . --host 0.0.0.0 --port 6060
```

### Kubernetes Deployment

Update the `language` value in `k8s/configmap.yaml`:

```yaml
data:
  language: "sv"  # Change from "en" to "sv" for Swedish
```

Then apply the updated ConfigMap:
```bash
kubectl apply -f k8s/configmap.yaml
kubectl rollout restart deployment/clara -n clara
```

## How It Works

1. The agent reads the `CLARA_LANGUAGE` environment variable
2. It selects the appropriate instructions and descriptions for that language
3. The Gemini model follows the language-specific instructions
4. All communication with students will be in the configured language

## Adding New Languages

To add support for a new language:

1. Edit `agents/agent.py`
2. Add a new entry to the `INSTRUCTIONS` dictionary with your language code
3. Add a corresponding entry to the `DESCRIPTIONS` dictionary
4. Update this documentation

Example:
```python
INSTRUCTIONS = {
    'en': "...",
    'sv': "...",
    'de': """Du bist Clara, ein hilfreicher KI-Tutor...""",  # German
}

DESCRIPTIONS = {
    'en': "...",
    'sv': "...",
    'de': "Ein systematischer KI-Tutor...",  # German
}
```

## Language Codes

Use ISO 639-1 language codes:
- `en` - English
- `sv` - Swedish
- `de` - German
- `fr` - French
- `es` - Spanish
- etc.

