# Clara AI Implementation Plan

## Current State Analysis

### ✅ What Exists
1. **Tools** (`tools/studyplan_agent_tools.py`):
   - `quick_subject_research()` - Research subjects and identify key concepts
   - `divide_into_study_sections()` - Create structured study plans

2. **Infrastructure**:
   - Dockerfile (port 6060)
   - Kubernetes manifests (deployment, service, ingress, configmap, secret)
   - CI/CD workflow (GitHub Actions)
   - Backstage catalog entry
   - ArgoCD application template

3. **Dependencies** (`pyproject.toml`):
   - `google-adk` - Google Agent Development Kit
   - `litellm` - LLM interface (OpenAI via LiteLLM)
   - `python-dotenv` - Environment variables

### ❌ What's Missing
1. **Agents Directory** - Referenced in `__init__.py` but doesn't exist
2. **Main Agent** (`agents/agent.py`) - StudyBuddyAgent implementation
3. **StudyPlan Agent** (`agents/studyplan_agent.py`) - Subject research agent
4. **ADK Configuration** - How Google ADK discovers agents

## Implementation Steps

### Step 1: Create Agents Directory Structure
```bash
mkdir -p clara/agents
touch clara/agents/__init__.py
```

### Step 2: Implement StudyPlan Agent
**File**: `agents/studyplan_agent.py`
- Uses `quick_subject_research()` and `divide_into_study_sections()` tools
- Researches subjects and creates study plans
- Exposed as an ADK agent

### Step 3: Implement Main Clara Agent
**File**: `agents/agent.py`
- Main tutor agent (StudyBuddyAgent)
- Orchestrates the learning process:
  1. Get student info (grade, subject, timeline)
  2. Research subject (via StudyPlan agent)
  3. Create study plan
  4. Iterative learning loop:
     - Teach concepts
     - Quiz student
     - Assess performance
     - Re-teach weak areas

### Step 4: Fix Package Imports
**File**: `__init__.py`
- Ensure imports work correctly
- Export agents properly

### Step 5: Create ADK Configuration
- Google ADK needs to discover agents
- May need `agent.yaml` or similar config file
- Or agents are auto-discovered from package structure

### Step 6: Test Locally
```bash
cd clara
uv venv
uv sync
uv run adk web . --host 0.0.0.0 --port 6060
```

### Step 7: Add Environment Variables
Create `.env` file:
```bash
OPENAI_API_KEY=your-key-here
GOOGLE_CLOUD_PROJECT=your-project-id (if needed)
LOG_LEVEL=INFO
```

### Step 8: Deploy to Kubernetes
- Push code to GitHub
- ArgoCD will auto-deploy via GitOps
- Or manually apply: `kubectl apply -f k8s/`

## Google ADK Agent Structure

Based on Google ADK patterns, agents typically:
1. Inherit from ADK's Agent class
2. Define system instructions
3. Register tools
4. Handle conversations

Example structure:
```python
from google.adk import Agent
from tools import quick_subject_research, divide_into_study_sections

class StudyPlanAgent(Agent):
    def __init__(self):
        super().__init__(
            name="studyplan",
            instructions="You are a study plan creation agent...",
            tools=[quick_subject_research, divide_into_study_sections]
        )
```

## Next Actions

**Immediate (Priority 1)**:
1. Research Google ADK documentation/patterns
2. Create `agents/` directory
3. Implement StudyPlan agent first (simpler, uses existing tools)
4. Test locally

**Short-term (Priority 2)**:
5. Implement main Clara agent
6. Add teaching/quizzing tools
7. Test full learning flow

**Medium-term (Priority 3)**:
8. Deploy to Kubernetes
9. Test in production
10. Add monitoring/logging
11. Enhance tools with real LLM calls

## Questions to Resolve

1. **Google ADK Discovery**: How does ADK find agents? Auto-discovery or config file?
2. **Agent Registration**: Do agents need to be explicitly registered?
3. **Tool Integration**: How are tools passed to agents in ADK?
4. **LLM Configuration**: How is LiteLLM configured with OpenAI API key?
5. **Web Interface**: What does `adk web .` provide? Chat UI? API docs?

## Resources Needed

- Google ADK documentation
- Example ADK agent implementations
- Understanding of ADK's agent discovery mechanism
- LiteLLM configuration for OpenAI

