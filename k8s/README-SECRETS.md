# Managing Clara Secrets

## Overview

Clara requires a Google ADK API key to function. Since this repository is public, **never commit plain-text secrets** to Git.

## Two Options for Secret Management

### Option 1: Sealed Secrets (Recommended for GitOps)

Sealed Secrets allow you to safely commit encrypted secrets to Git. The cluster automatically decrypts them.

**To create a sealed secret:**

1. Ensure your Kubernetes cluster is accessible:
   ```bash
   kubectl cluster-info
   ```

2. Run the sealing script:
   ```bash
   cd k8s
   ./seal-secret.sh YOUR_GOOGLE_API_KEY
   ```
   
   Or if you want to be prompted:
   ```bash
   ./seal-secret.sh
   ```

3. The script will create `secret-sealed.yaml` which is **safe to commit to Git**.

4. Apply the sealed secret:
   ```bash
   kubectl apply -f secret-sealed.yaml
   ```

**Note:** The sealed secret is cluster-specific. Each cluster needs its own sealed secret.

### Option 2: Manual Secret Creation (For Local Testing)

For local development or if Sealed Secrets aren't available:

```bash
kubectl create secret generic clara-secrets \
  --from-literal=google-api-key=YOUR_GOOGLE_API_KEY \
  -n clara
```

**⚠️ Warning:** Never commit the API key to Git. Keep it in your local `.env` file only.

## Local Development

For local testing, use a `.env` file in the project root:

```bash
echo "GOOGLE_API_KEY=your-api-key-here" > .env
```

The `.env` file is already in `.gitignore` and won't be committed.

## Files

- `secret.yaml` - Template with empty values (safe to commit)
- `secret-sealed.yaml` - Encrypted secret (safe to commit, created by `seal-secret.sh`)
- `seal-secret.sh` - Script to create sealed secrets

## Security Best Practices

✅ **DO:**
- Use Sealed Secrets for production deployments
- Keep API keys in `.env` for local development
- Rotate API keys periodically

❌ **DON'T:**
- Commit plain-text secrets to Git
- Share API keys in chat or email
- Hard-code secrets in application code

