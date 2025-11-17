"""
StudyPlan Agent

Researches subjects and creates structured study plans for students.
"""

from google.adk.agents.llm_agent import Agent
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent.parent))
from tools import quick_subject_research, divide_into_study_sections

studyplan_agent = Agent(
    model='gemini-1.5-flash',
    name='studyplan_agent',
    description="Researches academic subjects and creates structured study plans with sequential learning sections.",
    instruction="""You are a study plan creation agent. Your role is to:
1. Research subjects to understand key concepts and curriculum requirements
2. Break down subjects into logical, sequential study sections
3. Create structured learning plans that build knowledge progressively
4. Consider grade level, exam timeline, and learning objectives

Use the available tools to research subjects and organize them into study sections.
Always create study plans that are appropriate for the student's grade level and timeline.""",
    tools=[quick_subject_research, divide_into_study_sections],
)

