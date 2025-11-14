"""
Clara

A systematic AI tutor for students built with Google ADK.
"""

__version__ = "0.1.1"
__author__ = "Daniel"

from .agents.agent import root_agent
from .agents.studyplan_agent import studyplan_agent

__all__ = ["root_agent", "studyplan_agent"]
